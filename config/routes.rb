Rails.application.routes.draw do
  namespace :api do
    post 'send_message', to: 'messages#create'
  end
  namespace :api do
    get "healthcheck", to: "healthcheck#show"
  end
  
end

