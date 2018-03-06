RescueRails::Application.routes.draw do
  get "/adopters/check_email", to: "adopters#check_email"
  get "/dogs/switch_view", to: "dogs#switch_view"

  resources :adopters do
    resources :comments, except: %i[destroy edit update]
    resources :adoptions
  end

  resources :adoption_app

  resources :comments, except: %i[new]

  resources :users
  resources :dogs do
    resources :comments
    resources :photos do
      collection { post :sort }
    end
    resources :adoptions
  end

  resources :sessions, only: %i[new create destroy]
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

  get '5k',                    to: 'pages#5k'

  get '/signin',               to: 'sessions#new'
  get '/signout',              to: 'sessions#destroy'
  get '/adopt',                to: 'adopters#new'

  get '/contact',              to: 'pages#contact'

  get '/funding-partners',                  to: 'pages#funding_partners'
  get '/community-partners',                to: 'pages#community_partners'
  get '/non-profit-and-corporate-partners', to: 'pages#np_corp_partners'
  get '/shelter-partners',                  to: 'pages#shelters'

  get '/guide',                to: 'pages#guide'
  get '/aboutus',              to: 'pages#aboutus'

  get '/documentary',          to: 'pages#documentary'
  get '/insurance',           to: 'pages#insurance'
  get '/volunteer',           to: 'pages#volunteer'

  get '/foster',               to: 'pages#foster'
  get '/fosterfaq',            to: 'pages#fosterfaq'
  get '/donate',               to: 'pages#donate'
  get '/sponsor',              to: 'pages#sponsor'
  get '/special-funds',        to: 'pages#special_funds'
  get '/other-ways-to-give',   to: 'pages#other_ways_to_give'

  get '/terms',                       to: 'pages#terms'
  get '/resources',                   to: 'pages#resources'
  get '/tips-for-finding-lost-pets',  to: 'pages#tips_for_finding_lost_pets'
  get '/status_definitions',          to: 'pages#status_definitions'
  get '/dog-status-definitions',      to: 'pages#dog_status_definitions'
  get '/education-and-outreach',      to: 'pages#education_and_outreach'
end
