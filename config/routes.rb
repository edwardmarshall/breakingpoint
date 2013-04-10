Breakingpoint::Application.routes.draw do
  root :to => "home#index"

  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => 'services', :registrations => 'registrations' }
  #ActiveAdmin.routes(self)
  devise_scope :users do
    get '/users/auth/:service/callback' => 'services#create'
  end

  # Setup OmniAuth
  # match '/auth/:provider/callback', to: 'services#create'
  resources :services, :only => [:index]
end
