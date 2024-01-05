require 'awesome_print'
require 'tilt'

unless ARGV.join(' ').include?('.rb')
  raise ArgumentError, %[add *_spec.rb as argument or start with "rake test"]
end

require_relative '../lib/view-cell'

require_relative './misc/user'
require_relative './misc/app_cell'
require_relative './misc/user_cell'
require_relative './misc/tpl_cell'

# basic config
RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :json, CustomFormatterClass

  config.before do |f|
    ViewCell.template_root nil
  end
end


