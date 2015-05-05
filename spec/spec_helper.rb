require 'webmock/rspec'
require 'simplecov'
require 'test/unit'
require 'rack/test'
require './spec/fixtures_helper'

ENV['RACK_ENV'] = 'test'

WebMock.disable_net_connect!

SimpleCov.start do
  require 'simplecov-badge'
  add_filter "/vendor/"
  add_filter "/spec/"
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::BadgeFormatter,
  ]
end

module RSpecMixin
  include Rack::Test::Methods
  include FixtureHelper
  def app() Pigeon end

  def setup_method!(method, endpoint, fixture)
    stub_request(method, endpoint).
      to_return(status: 200, headers: {'Content-Length' => fixture.length})
  end

  def setup_redirect!(method, endpoint, destination)
    stub_request(method, endpoint).
      to_return(status: 301, headers: {'Location' => destination})
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  begin
    config.filter_run :focus
    config.run_all_when_everything_filtered = true
    #config.disable_monkey_patching!
    #config.warnings = true
    if config.files_to_run.one?
      config.default_formatter = 'doc'
    end
    config.profile_examples = 10
    config.order = :random
    Kernel.srand config.seed

    config.include RSpecMixin
  end
end

require './app'
