class ViewCell
  RENDER_CACHE ||= {}

  @template_root = nil

  class << self
    # load cell based on a name, pass context and optional vars
    # ViewCell.get(:user, self) -> UserCell.new(self)
    def get parent, name, vars={}
      ('%sCell' % name.to_s.classify)
        .constantize
        .new parent, vars
    end

    # delegate current scope methods to parent binding
    def delegate *list
      list.each do |el|
        define_method(el) { |*args, &block| parent.send(el, *args, &block) }
      end
    end

    # cell.user.profile
    # cell(:user, user: @user).profile
    def cell parent, *args
      if args.first
        ViewCell.get(parent, *args)
      else
        ViewCell::Proxy.new(parent)
      end
    end

    # set or get template root directory
    def template_root name=nil
      if name
        self.class.instance_variable_set :@template_root, name
      else
        self.class.instance_variable_get :@template_root
      end
    end
  end

  ###

  define_method(:request) { Current.request }
  define_method(:params)  { Current.request.params }
  define_method(:before)  { }

  def initialize parent=nil, vars={}
    @_parent = parent
    before
    vars.each { |k,v| instance_variable_set "@#{k}", v}
  end

  # access parent scope
  def parent &block
    if block
      @_parent.instance_exec self, &block
    else
      @_parent
    end
  end

  def cell *args
    self.cell @_parent, *args
  end

  # render template by name
  def render name
    template_root = self.class.template_root

    if template_root
      name = [template_root, name].join '/'
    elsif name.is_a?(Symbol)
      name = './app/views/cells/%s/%s' % [self.class.to_s.underscore.sub(/_cell$/, ''), name]
    elsif name.to_s =~ /^\w/
      name = './app/views/cells/%s' % name
    end

    RENDER_CACHE.delete(name) if Rails.env.development?

    RENDER_CACHE[name] ||= proc do
      # find extension if one not provided
      file_name = name

      unless name =~ /\.\w{2,4}$/
        if (file = Dir['%s*' % name].first)
          file_name = file
        else
          raise 'Template "%s.*" not found' % name
        end
      end

      Tilt.new(file_name)
    end.call

    RENDER_CACHE[name].render(self).html_safe
  end
end
