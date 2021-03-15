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
    # delegate :image_tag, :request, params
    def delegate *list
      list.each do |el|
        define_method(el) { |*args, &block| parent.send(el, *args, &block) }
      end
    end

    # = cell @users
    # = cell @user
    # = cell.user.render @user
    # = cell(:user, user: @user).render
    def cell parent, *args
      if args.first
        # covert to list of objects
        unless [String, Symbol, Array].include?(args[0].class)
          args[0] = [args.first]
        end

        out =
        if args.first.class == Array
          # cell @users
          args.first.map do |object|
            name = object.class.to_s.underscore.to_sym
            ViewCell.get(parent, name).render object
          end.join('')
        else
          # cell(:user, user: @user).profile
          ViewCell.get parent, *args
        end

        out.respond_to?(:html_safe) ? out.html_safe : out
      else
        # cell.user.profile
        ViewCell::Proxy.new(parent)
      end
    end

    # can be called as a block or a method
    # block do ...
    # def block; super; ...
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
