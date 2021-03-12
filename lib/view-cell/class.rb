class ViewCell
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

    def before &block
      define_method :before do
        super() if self.class != ViewCell
        instance_exec &block
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
end
