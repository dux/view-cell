desc 'run rspec'
task :test do
  for file in `find spec -name '*_spec.rb'`.split($/)
    command = "rspec --fail-fast #{file}"
    puts "---\nbundle exec #{command}\n---"
    exit unless system command
  end
end