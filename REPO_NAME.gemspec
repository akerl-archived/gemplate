Gem::Specification.new do |s|
  s.name        = 'REPO_NAME'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = ''
  s.description = ""
  s.authors     = ['LICENSE_NAME']
  s.email       = 'EMAIL_ADDRESS'
  s.homepage    = 'https://github.com/AUTHOR_NAME/REPO_NAME'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'travis-lint'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
end
