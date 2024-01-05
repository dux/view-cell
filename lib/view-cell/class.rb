class ViewCell
  DATA ||= {
    template_root: nil,
    css: {}
  }
  
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
    def template_root name = :_
      if name != :_
        DATA[:template_root] = name
      else
        DATA[:template_root]
      end
    end

    def css text = nil
      if text      
        require 'sassc' unless Object.const_defined?('SassC')

        unless text.include?('{')
          dir_name = self.template_root || File.dirname(caller[0].split(':')[0])
          class_part = to_s.underscore.sub(/_cell$/, '')
          dir_name = dir_name % class_part if dir_name.include?('%s')
          css_file = Pathname.new(dir_name).join(text)
          text = css_file.read
        end

        key = caller[0].split(':in ')[0]
        DATA[:css][key] = SassC::Engine.new(text, style: :compact).render.gsub(/\n+/, $/).chomp
      else
        DATA[:css].inject([]) do |list, el|
          name = el[0].split('/').last.split('.')[0].gsub('_', '-')
          list.push("/* #{name} */\n" + el[1])
        end.join("\n\n")
      end
    end
  end
end
