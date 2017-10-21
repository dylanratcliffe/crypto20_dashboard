require 'dashing'

configure do
  set :auth_token, 'hunter2'

  helpers do
    def protected!
      false
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
