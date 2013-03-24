RSpec.configure do |config|

  # rspec 2.11 turn off should monkey patching
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end

