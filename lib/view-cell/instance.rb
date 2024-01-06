class ViewCell
  RENDER_CACHE ||= {}

  def initialize parent = nil, vars={}
    @_parent = parent
    vars.each { |k,v| instance_variable_set "@#{k}", v}
    before
  end

  # called every time for every method in a class
  def before
  end

  # access parent scope
  def parent &block
    if block
      @_parent.instance_exec self, &block
    else
      @_parent
    end
  end

  # call
  def cell *args
    ViewCell.cell @_parent, *args
  end

  # render template by name
  def template name
    path = if template_root = self.class.template_root
      [template_root, name].join '/'
    else
      [File.dirname(caller[0]), name].join '/'
    end

    class_part = self.class.to_s.underscore.sub(/_cell$/, '')
    path = path % class_part if path.include?('%s')

    RENDER_CACHE.delete(path) if _development?
    RENDER_CACHE[path] ||= begin
      file_name = ''

      # find extension if one not provided
      if path =~ /\.\w{2,4}$/
        file_name = path
      else
        if (file = Dir['%s.*' % path].first)
          file_name = file
        end
      end

      unless File.exist?(file_name)
        raise ArgumentError, 'Template "%s.*" not found' % [path.sub(Dir.pwd, '.')]
      end

      Tilt.new(file_name)
    end
    RENDER_CACHE[path].render(self)
  end

  private

  def _development?
    ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  end
end
