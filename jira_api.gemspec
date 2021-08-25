require_relative 'lib/jira_api/version'
Gem::Specification.new do |spec|
  spec.name           = %q{jira_api}
  spec.author         = %q{Filipe Cunha}
  spec.version        = JiraAPI::VERSION
  spec.date           = %q{2018-11-28}
  spec.summary        = %q{Ruby wrapper to Jira API}
  spec.licenses       = ['MIT']  
  spec.description    = "Ruby wrapper to Jira API (all verions)"
  spec.email          = 'filipecunhaf@gmail.com'
  spec.homepage       = 'https://rubygemspec.org/gems/jira_api'
  spec.metadata       = { "source_code_uri" => "https://github.com/filipecunhaf/jira_api" }
  spec.files          = Dir['lib/**/*.rb'] + Dir['assets/*'] + Dir['bin/*']
  spec.require_paths  = ["lib"]
  spec.required_ruby_version = '>= 2.5.1'
<<<<<<< HEAD
<<<<<<< HEAD
  spec.add_runtime_dependency( 'excon', '~> 0.71.0' )
=======
  spec.add_runtime_dependency( 'excon', '>= 0.62', '~> 0.62' )
>>>>>>> c009b2c (accept excon gem greater than 0.62)
=======
  spec.add_runtime_dependency( 'excon', '>= 0.62', '~> 0.62' )
=======
  spec.add_runtime_dependency( 'excon', '~> 0.71.0' )
>>>>>>> c3ee9e0 (Update jira_api.gemspec)
>>>>>>> 5da9e97 (Update jira_api.gemspec)
  spec.add_runtime_dependency( 'oj', '~> 3.7' )
  spec.add_runtime_dependency( 'json', '~> 2.1' )
  spec.add_runtime_dependency( 'curb', '~> 0.9.8' )
  spec.add_development_dependency( 'rspec', '~> 3.2' )
end
