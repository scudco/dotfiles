require 'rubygems'
# find which rspec to use
rspec_rails_plugin = File.join(RubyAMP.project_path,'vendor','plugins','rspec','lib')
if File.directory?(rspec_rails_plugin)
  $LOAD_PATH.unshift(rspec_rails_plugin)
elsif ENV['TM_RSPEC_HOME']
  rspec_lib = File.join(ENV['TM_RSPEC_HOME'], 'lib')
  unless File.directory?(rspec_lib)
    raise "TM_RSPEC_HOME points to a bad location: #{ENV['TM_RSPEC_HOME']}"
  end
  $LOAD_PATH.unshift(rspec_lib)
end
require 'spec'