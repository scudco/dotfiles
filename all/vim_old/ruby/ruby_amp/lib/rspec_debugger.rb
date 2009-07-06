module RubyAMP
  class RSpecDebugger
    def self.debug_rspec(focussed_or_file = :file)
      raise "Invalid argument" unless %w[focussed file].include?(focussed_or_file.to_s)
      # if RubyAMP::Config[:rspec_bundle_path].nil?
      #   puts "Can't find rspec.tmbundle.  Use 'Edit RubyAMP Global Config' to set the path to where it's installed"
      # end
  
      wrapper_file = RubyAMP::RemoteDebugger.prepare_debug_wrapper(<<-EOF)
        require '#{File.dirname(__FILE__)}/spec_runner'
        while Debugger.handler.interface.nil?; sleep 0.10; end
        RubyAMP::Spec::Runner.new.run_#{focussed_or_file} STDOUT
      EOF
      RubyAMP::Launcher.open_controller_terminal

      ARGV << "-s"
      ARGV << wrapper_file

      require 'rubygems'
      require 'ruby-debug'
      load 'rdebug'
    end
  end
end