require 'awesome_print'
require 'tilt'

require_relative '../lib/view-cell'

require_relative './misc/user'
require_relative './misc/app_cell'
require_relative './misc/user_cell'

# basic config
RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :json, CustomFormatterClass
end


