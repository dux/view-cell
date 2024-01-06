# enables shorcut
#  FooCell.new(self).bar -> cell.foo.bar

# include gem before rails if you do not want to import proxy methods
# gem 'view-cell'

[
  'ActionView::Base',
  'ActionController::Base',
  'Lux::Template::Helper', 
  'Lux::Controller',
  'Sinatra::Application'
].each do |klass|
  if Object.const_defined?(klass)
    klass.constantize.include ViewCell::ProxyMethod
  end
end
