if ENV['CI'] == 'true'
  require 'simplecov'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rspec'
require 'gemplate'

require 'webmock/rspec'
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: /raw.githubusercontent.com/
)
