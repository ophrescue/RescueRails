RescueRails::Application.routes.draw do
  get "/adopters/check_email", to: "adopters#check_email"
  get "/dogs/switch_view", to: "dogs#switch_view"

  resources :adopters do
    resources :comments, except: %i(destroy edit update)
    resources :adoptions
  end

  resources :adoption_app

  resources :comments

  resources :users
  resources :dogs do
    resources :comments
    resources :photos do
      collection { post :sort }
    end
    resources :adoptions
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets

  get '/events/past', to: 'events#past'
  resources :events

  resources :adoptions

  resources :folders
  resources :attachments

  resources :banned_adopters do
    collection { post :import }
  end

  resources :shelters

  root                         to: 'pages#home'

  get '/signin',               to: 'sessions#new'
  get '/signout',              to: 'sessions#destroy'
  get '/adopt',                to: 'adopters#new'

  get '/contact',              to: 'pages#contact'

  get '/guide',                to: 'pages#guide'
  get '/aboutus',              to: 'pages#aboutus'
  get '/contributors',         to: 'pages#contributors'
  get '/partnerships',         to: 'pages#partnerships'
  get '/partner-shelters',     to: 'pages#shelters'

  get'/documentary',          to: 'pages#documentary'
  get '/insurance',           to: 'pages#insurance'
  get '/volunteer',           to: 'pages#volunteer'

  get '/foster',               to: 'pages#foster'
  get '/fosterfaq',            to: 'pages#fosterfaq'
  get '/contribute',           to: 'pages#donate'
  get '/donate',               to: 'pages#donate'
  get '/sponsor',              to: 'pages#sponsor'
  get '/special-funds',        to: 'pages#special_funds'
  get '/other-ways-to-give',   to: 'pages#other_ways_to_give'

  get '/terms',                     to: 'pages#terms'
  get '/resources',                 to: 'pages#resources'
  get '/puppyguide',                to: 'pages#puppyguide'
  get '/shopping',                  to: 'pages#shopping'
  get '/status_definitions',        to: 'pages#status_definitions'
  get '/dog-status-definitions',    to: 'pages#dog_status_definitions'
  get '/education-and-outreach',    to: 'pages#education_and_outreach'
end
