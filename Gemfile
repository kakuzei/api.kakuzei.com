source 'https://rubygems.org'

ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Rails
gem 'rails', '~> 5.1'
gem 'rack-cors'
gem 'active_model_serializers', '~> 0.10'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Database
gem 'sqlite3'

# Server
gem 'puma', '~> 3.8'
