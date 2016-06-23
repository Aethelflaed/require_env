$:.push File.expand_path('../lib', __FILE__)

require 'require_env/version'

Gem::Specification.new do |s|
  s.name        = 'require_env'
  s.version     = RequireEnv::VERSION
  s.authors     = ['Geoffroy Planquart']
  s.email       = ['geoffroy@planquart.fr']
  s.homepage    = 'https://github.com/Aethelflaed/require_env'
  s.summary     = 'Simple environment variable check'
  s.description = 'Check environment variable presence with minimal YAML file'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'safe_yaml', '~> 1.0'
end
