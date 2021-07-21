# frozen_string_literal: true

require 'config'
require 'optparse'

module Parsers
  # Wrapper for OptionParser
  class ParamParser
    attr_reader :parser, :options

    # @param args [Array]
    def self.parse(args)
      @options = ScriptOptions.new
      @args = OptionParser.new do |parser|
        @options.define_options(parser)
        parser.parse!(args)
      end

      @options
    end

    # Provides easier access to options and arguments from the command line
    class ScriptOptions
      attr_accessor :algorithm, :source_csv_path

      def initialize
        @algorithm = nil
        @source_csv_path = nil
      end

      def define_options(parser)
        parser.banner = help_message
        parser.separator ''
        parser.separator 'Required:'
        algorithm_argument(parser)
        file_argument(parser)

        parser.separator ''
        parser.separator 'Optional:'
        help_option(parser)
        version_option(parser)
      end

      private

      # @return [String]
      def help_message
        <<~HELP
          Parses a csv file to find matching rows via the email, phone, or
          any other column added to the config. Output file will have a new
          first column added labeled matching_id that will contain a UUID. All
          rows that have a matching identifiable attribute will share this UUID.

          The output file will be written in your pwd, assuming you have write
          permission there.

          See README.md for more details
          Usage: bin/person_matcher.rb (-a ALGORITHM -f FILEPATH | -h | -v)
          Options are:
        HELP
      end

      # @param parser [OptionParser]
      def algorithm_argument(parser)
        msg = "[Required] Type of matching algorithm to use. Valid options are: #{Config::ALGORITHMS.join(' ')}"
        parser.on('-a', '--algorithm ALGORITHM', String, msg) { |algorithm| self.algorithm = algorithm.downcase }
      end

      # @param parser [OptionParser]
      def file_argument(parser)
        msg = '[Required] Process a CSV file: Please provide a complete file path.'
        parser.on('-f', '--file FILEPATH', String, msg) { |file| self.source_csv_path = file }
      end

      # @param parser [OptionParser]
      def help_option(parser)
        msg = 'Prints this help'
        parser.on_tail('-h', '--help', msg) do
          puts parser
          exit 0
        end
      end

      # @param parser [OptionParser]
      def version_option(parser)
        msg = 'Show version'
        parser.on_tail('-v', '--version', msg) do
          puts Config::VERSION
          exit 0
        end
      end
    end
  end
end
