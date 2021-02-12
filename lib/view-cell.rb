require_relative 'view-cell/class'
require_relative 'view-cell/instance'
require_relative 'view-cell/proxy'

require_relative 'adapters/view'

# If inflectors are not present, inject them (thx Piotr)
for el in [:underscore, :classify, :constantize]
  unless ''.respond_to?(el)
    require 'dry/inflector'

    eval %[
      class String
        def #{el}
          Dry::Inflector.new.#{el}(self)
        end
      end
    ]
  end
end