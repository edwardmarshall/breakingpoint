Breakingpoint::Application.routes.draw do
  root :to => "home#index"

  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :omniauth_callbacks => 'services', :registrations => 'registrations', :confirmations => 'confirmations' }, :path => '', :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'password_reset', :confirmation => 'confirmation', :unlock => 'unlock', :registration => 'register', :sign_up => 'signup' }
  # devise_for :users, :path => "auth", :path_names =>  { :sign_in => 'login', :sign_out => 'logout', :password => 'password_reset', :confirmation => 'confirmation', :unlock => 'unlock', :registration => 'register', :sign_up => 'signup' }
  
  devise_scope :users do
    get '/users/auth/:service/callback' => 'services#create'
    get '/reminder' => 'page#reminder', as: 'reminder'
    get '/congratulations' => 'page#congratulations', as: 'congratulations'
  end

  # Setup OmniAuth
  # match '/auth/:provider/callback', to: 'services#create'
  resources :services, :only => [:index]

  match "/vip" => "page#vip"
end
