Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'analytics#index', as: 'index'

  get '/load-embed-config', to: 'analytics#load_embed_config'
end
