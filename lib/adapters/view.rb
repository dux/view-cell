if Object.const_defined?('ActionView::Base')
  # Rails inject
  ActionView::Base.include ViewCell::ProxyMethod

elsif Object.const_defined?('Lux::Template::Helper')
  # Lux inject
  Lux::Template::Helper.include ViewCell::ProxyMethod

elsif Object.const_defined?('Sinatra::Application')
  # Sinatra inject
  Sinatra::Application.include ViewCell::ProxyMethod

end

