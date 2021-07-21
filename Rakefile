# frozen_string_literal: true

require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rake/clean'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features'
  t.fork = false
end

RSpec::Core::RakeTask.new(:spec)
