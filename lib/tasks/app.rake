namespace :app do
  desc 'Returns the version of the application'
  task version: %i[environment] do
    puts APIKakuzeiCom::Application::VERSION
  end
end
