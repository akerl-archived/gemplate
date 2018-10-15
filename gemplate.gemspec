require 'English'
$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'gemplate/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |s|
  s.name        = 'gemplate'
  s.version     = Gemplate::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.summary     = 'Bootstrap tool for making gems'
  s.description = 'Creates a basic repository layout for a new gem'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/gemplate'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['gemplate']

  s.add_dependency 'curb', '~> 0.9.0'
  s.add_dependency 'mercenary', '~> 0.3.4'
  s.add_dependency 'octoauth', '~> 1.5.5'
  s.add_dependency 'octokit', '~> 4.13.0'
  s.add_dependency 'rugged', '~> 0.27.0'
  s.add_dependency 'userinput', '~> 1.0.0'

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.3.0'
  s.add_development_dependency 'goodcop', '~> 0.6.0'
  s.add_development_dependency 'rake', '~> 12.3.0'
  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'rubocop', '~> 0.59.0'
  s.add_development_dependency 'vcr', '~> 4.0.0' # SKIP WHEN COPYING TO TEMPLATE # rubocop:disable Metrics/LineLength
  s.add_development_dependency 'webmock', '~> 3.4.0' # SKIP WHEN COPYING TO TEMPLATE # rubocop:disable Metrics/LineLength
end
# rubocop:enable Metrics/BlockLength
