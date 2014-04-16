Gem::Specification.new do |s|
  s.name        = 'REPO_NAME'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = ''
  s.description = ""
  s.authors     = ['FULL_NAME']
  s.email       = 'EMAIL_ADDRESS'
  s.homepage    = 'https://github.com/AUTHOR_NAME/REPO_NAME'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_development_dependency 'rubocop', '~> 0.20.0'
  s.add_development_dependency 'rake', '~> 10.3.0'
  s.add_development_dependency 'coveralls', '~> 0.7.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'fuubar', '~> 1.3.2'
end
