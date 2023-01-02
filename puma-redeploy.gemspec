# frozen_string_literal: true

require_relative 'lib/puma/redeploy/version'

Gem::Specification.new do |spec|
  spec.name          = 'puma-redeploy'
  spec.version       = Puma::Redeploy::VERSION
  spec.authors       = ['tbeauvais']
  spec.email         = ['tbeauvais1@gmail.com']

  spec.summary       = 'Puma plugin to redeploy and reload app from artifact.'
  spec.description   = 'Puma plugin to redeploy and reload app from a remote artifact. ' \
                       'This will detect app changes, once detected a new artifact ' \
                       'will be pulled and the app will be reloaded.'
  spec.homepage      = 'https://github.com/tbeauvais/puma-redeploy'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tbeauvais/puma-redeploy'
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'puma', '>= 5.6.0', '< 7'

  spec.add_development_dependency 'rake', '~> 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
  spec.add_development_dependency 'rubocop', '~> 1.42'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.16'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
