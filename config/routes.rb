Breakingpoint::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'services', :registrations => 'registrations' }
  devise_scope :users do
    get '/users/auth/:service/callback' => 'services#create'
  end

  root :to => "home#index"

  # Setup OmniAuth
  # match '/auth/:provider/callback', to: 'services#create'
  resources :services, :only => [:index]
end
