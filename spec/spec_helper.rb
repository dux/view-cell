unless ARGV.join(' ').include?('.rb')
  system "rake test"
  exit!
end

require 'awesome_print'
require 'tilt'

require_relative '../lib/view-cell'

# basic config
RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :json, CustomFormatterClass
end


