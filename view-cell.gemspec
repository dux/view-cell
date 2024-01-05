version  = File.read File.expand_path '.version', File.dirname(__FILE__)
gem_name = 'view-cell'

Gem::Specification.new gem_name, version do |gem|
  gem.summary     = 'Simple to use web view cell'
  gem.description = 'Clean, simple explicit and strait-forward web view cell for use in Rails/Sinatra/Lux.'
  gem.authors     = ["Dino Reic"]
  gem.email       = 'reic.dino@gmail.com'
  gem.files       = Dir['./lib/**/*.rb']+['./.version']
  gem.homepage    = 'https://github.com/dux/%s' % gem_name
  gem.license     = 'MIT'

  gem.add_runtime_dependency 'tilt'
  gem.add_dependency 'dry-inflector'
  gem.add_dependency 'sassc'
end