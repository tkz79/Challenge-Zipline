#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/../lib")

require 'config'
require 'exceptions'
require 'parsers/csv_parser'
require 'parsers/param_parser'
require 'writers/csv_writer'

# Main wrapper for script
def main
  options = parse_arguments(ARGV)
  validate_params(options)

  dictionary = Models::Dictionary.new
  algorithm_definitions = Config.algorithm_definitions(options.algorithm)
  csv_parser = Parsers::CsvParser.new(algorithm_definitions, dictionary, options.source_csv_path)
  parse_csv(csv_parser)

  write_csv(options.algorithm, algorithm_definitions, dictionary, options.source_csv_path)

  exit(0)
end

# @param args [Array]
# @return [ScriptOptions]
def parse_arguments(args)
  Parsers::ParamParser.parse(args)
rescue OptionParser::InvalidOption => e
  rescue_exit(1, e)
rescue OptionParser::MissingArgument => e
  rescue_exit(2, e)
end

# @param options [OptionsParser]
def validate_params(options)
  raise MissingAlgorithmArgument, 'You must provide an algorithm.' unless options.algorithm
  raise InvalidAlgorithm, "#{options.algorithm} is not a valid matching algorithm" unless Config::ALGORITHMS.include?(options.algorithm)
  raise MissingFileArgument, 'You must provide a path to a CSV.' unless options.source_csv_path
rescue MissingAlgorithmArgument => e
  rescue_exit(3, e)
rescue InvalidAlgorithm => e
  rescue_exit(4, e)
rescue MissingFileArgument => e
  rescue_exit(5, e)
end

# @param csv_parser [Parsers::CsvParser]
def parse_csv(csv_parser)
  csv_parser.parse
rescue Errno::ENOENT => e
  rescue_exit(6, e)
rescue Errno::EACCES => e
  rescue_exit(7, e)
rescue CSV::MalformedCSVError => e
  rescue_exit(8, e)
rescue ColumnNotFound => e
  rescue_exit(9, e)
end

# @param algorithm [String]
# @param algorithm_definitions [Array] of [Hash]
# @param dictionary [Models::Dictionary]
# @param source_csv_path [String]
def write_csv(algorithm, algorithm_definitions, dictionary, source_csv_path)
  Writers::CsvWriter.new(algorithm, algorithm_definitions, dictionary, source_csv_path).write
rescue Errno::EACCES => e
  rescue_exit(10, e)
end

# @param code [Integer]
# @param exception [Exception]
def rescue_exit(code, exception)
  warn "#{code} - #{exception.message}"
  exit(code)
end

main
