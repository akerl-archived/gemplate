Gem::Specification.new do |s|
  s.name        = 'gemplate'
  s.version     = '0.1.2'
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = 'Bootstrap tool for making gems'
  s.description = 'Creates a basic repository layout for a new gem'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/gemplate'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['gemplate']

  s.add_dependency 'travis', '~> 1.6.8'
  s.add_dependency 'rugged', '~> 0.19.0'
  s.add_dependency 'userinput', '~> 0.0.2'
  s.add_dependency 'curb', '~> 0.8.5'

  s.add_development_dependency 'rubocop', '~> 0.20.1'
  s.add_development_dependency 'rake', '~> 10.3.0'
  s.add_development_dependency 'coveralls', '~> 0.7.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'fuubar', '~> 1.3.2'
end
