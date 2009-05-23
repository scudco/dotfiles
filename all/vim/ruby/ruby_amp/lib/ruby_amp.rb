module RubyAMP
  # since this environment will be carried over when running specs and such, be very careful not to pollute the global namespace
  
  unless const_defined?("AUTO_LOAD")
    AUTO_LOAD = {
      :Commands       => 'commands.rb',
      :Launcher       => 'launcher.rb',
      :RemoteDebugger => 'remote_debugger.rb',
      :RSpecDebugger  => 'rspec_debugger.rb',
      :Spec           => 'spec_runner.rb',
      :Inspect        => 'inspect.rb',
      :Config         => 'config.rb',
      :PrettyAlign    => 'pretty_align.rb'
    }
  end
  
  def self.lib_root
    File.dirname(__FILE__)
  end
  
  def self.plugin_root
    lib_root + "/../"
  end
  
  def self.project_path
    ENV['TM_PROJECT_DIRECTORY'] || ( ENV['TM_FILEPATH'] && File.dirname(ENV['TM_FILEPATH']) )
  end
  
  def self.const_missing(name)
    @looked_for ||= {}
    raise "Class not found: #{name}" if @looked_for[name]
    
    return super unless AUTO_LOAD[name]
    @looked_for[name] = true
    
    load File.join(lib_root, AUTO_LOAD[name])
    const_get(name)
  end
end
