class ViewCell
  RENDER_CACHE ||= {}

  @template_root = nil

  def initialize parent=nil, vars={}
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
    ViewCell.get @_parent, *args
  end

  # render template by name
  def template name
    template_root = self.class.template_root
    class_part    = self.class.to_s.underscore.sub(/_cell$/, '')

    if template_root
      name = [template_root, name].join '/'
    elsif name.is_a?(Symbol)
      name = './app/views/cells/%s/%s' % [class_part, name]
    elsif name.to_s =~ /^\w/
      name = './app/views/cells/%s' % name
    end

    name = name % class_part if name.include?('%s')

    RENDER_CACHE.delete(name) if _development?

    RENDER_CACHE[name] ||= proc do
      # find extension if one not provided
      file_name = name

      unless name =~ /\.\w{2,4}$/
        if (file = Dir['%s*' % name].first)
          file_name = file
        end
      end

      unless File.exist?(file_name)
        raise ArgumentError, 'Template "%s.*" not found' % name
      end

      Tilt.new(file_name)
    end.call

    out = RENDER_CACHE[name].render(self)
    out.respond_to?(:html_safe) ? out.html_safe : out
  end

  private

  def _development?
    ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  end
end
