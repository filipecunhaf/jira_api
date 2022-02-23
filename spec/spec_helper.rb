require 'oj'
require 'pry'
require 'excon'
# require 'regexp-examples'
# require 'simplecov'
# require 'nokogiri'
# SimpleCov.start
# require 'codecov'
# SimpleCov.formatter = SimpleCov::Formatter::Codecov
require_relative "#{__dir__}/../lib/jira_api.rb"
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |file| require file }
RSpec::Expectations.configuration.on_potential_false_positives = :nothing
# Dir[File.join(__dir__, '../lib', '*.rb')].sort_by.each do |file|
#   require file
# end
# Dir[File.join(__dir__, '../modules', '*.rb')].sort_by.sort_by.each do |file|
#   require file
# end
