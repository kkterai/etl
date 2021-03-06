require 'etl'
require 'factory_girl'
require 'time_warp'

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.include FactoryGirl::Syntax::Methods

  # Print the 10 slowest examples and example groups
  #config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end

# ETL system configuration
ETL.config.core do |c|
  # override to write logs to file so they don't clutter up STDOUT
  unless c[:log][:file]
    f = "log/test.log"
    puts("Writing rspec output to #{f}")
    c[:log][:file] = f
  end
end

# Libraries in ETL rspec directory
libdir = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(libdir)
%w( jobs ).each do |d|
  dir = "#{libdir}/#{d}"
  Dir.new(dir).each do |file|
    next unless file =~ /\.rb$/
    require "#{dir}/#{file}"
  end
end
