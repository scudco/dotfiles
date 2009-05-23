module RubyAMP
  module Commands
    #
    # Debug Commands
    #
    def debug_rspec_examples
      RubyAMP::RSpecDebugger.debug_rspec(:file)
    end

    def debug_rspec_single_example
      RubyAMP::RSpecDebugger.debug_rspec(:focussed)
    end

    def debug_set_breakpoint_at_current_line
      remote_debugger do |d|
        source = ENV['TM_FILEPATH']
        line = ENV['TM_LINE_NUMBER']

        if d.breakpoint.add(source, line)
          print "Set breakpoint at #{source}:#{line}"
        else
          print "Failed to set breakpoint."
        end
      end
    end

    def debug_show_breakpoints
      #require "#{ENV["TM_BUNDLE_SUPPORT"]}/lib/ruby_amp.rb"
      #require "#{ENV["TM_BUNDLE_SUPPORT"]}/lib/ruby_tm_helpers.rb"
      #require "#{ENV['TM_SUPPORT_PATH']}/lib/ui.rb"

      #d = RubyAMP::RemoteDebugger.new
      #breakpoints = d.breakpoint.list

      #if breakpoints.empty?
        #puts "No breakpoints"
        #exit_show_tool_tip
      #end

      #b_index = TextMate::UI.menu(breakpoints.map{|b| "#{b.source}:#{b.line}"})

      #exit_discard if b_index.nil?

      #breakpoint = breakpoints[b_index]
      #tm_open(breakpoint.source, :line => breakpoint.line)
    end

    def debug_inspect_with_pretty_print
      remote_debugger do |d|
        what = RubyAMP::Inspect.get_selection
        print "#{what} = \n#{d.evaluate(what, :current, :pp)}"
      end
    end

    def debug_inspect_as_string
      remote_debugger do |d|
        what = RubyAMP::Inspect.get_selection
        print "#{what} = \n#{d.evaluate(what, :current, :string)}"
      end
    end

    #
    # Rspec Run Commands
    #
    def run_rspec_examples
      RubyAMP::Spec::Runner.new.run_file
    end

    def run_rspec_single_example
      RubyAMP::Spec::Runner.new.run_focussed
    end

    #
    # Helper methods
    #

    def remote_debugger(&block)
      RubyAMP::RemoteDebugger.connect do |d|
        yield d
      end
    end

    extend self
  end
end
