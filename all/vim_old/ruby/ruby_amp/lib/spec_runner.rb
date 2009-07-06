require File.dirname(__FILE__) + '/spec_setup'

module RubyAMP
  module Spec
    class Runner
      def run_files(stdout=STDOUT, options={})
        files = ENV['TM_SELECTED_FILES'].split(" ").map do |path|
          File.expand_path(path[1..-2])
        end
        options.merge!({:files => files})
        run(stdout, options)
      end

      def run_file(stdout=STDOUT, options={})
        options.merge!({:files => [single_file]})
        run(stdout, options)
      end

      def run_focussed(stdout=STDOUT, options={})
        options.merge!({:files => [single_file], :line => ENV['TM_LINE_NUMBER']})
        run(stdout, options)
      end

      def run(stdout, options)
        argv = options[:files].dup
        # argv << '--format'
        # argv << 'textmate'
        if options[:line]
          argv << '--line'
          argv << options[:line]
        end
        argv += ENV['TM_RSPEC_OPTS'].split(" ") if ENV['TM_RSPEC_OPTS']
        Dir.chdir(project_directory) do
          ::Spec::Runner::CommandLine.run(::Spec::Runner::OptionParser.parse(argv, STDERR, stdout))
        end
      end

      protected
      def single_file
        File.expand_path(ENV['TM_FILEPATH'])
      end

      def project_directory
        File.expand_path(RubyAMP.project_path)
      end
    end
  end
end
