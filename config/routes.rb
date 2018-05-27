RescueRails::Application.routes.draw do
  get "/adopters/check_email", to: "adopters#check_email"
  get "/dogs/switch_view", to: "dogs#switch_view"

  resources :adopters do
    resources :comments, except: %i[destroy edit update]
    resources :adoptions
  end

  resources :adoption_app

  resources :comments, except: %i[new]

  resources :users do
    resource :password, controller: :passwords, only: %i[create edit update]
  end

  resources :dogs do
    resources :comments
    resources :photos do
      collection { post :sort }
    end
    resources :adoptions
  end
  get '/dogs_manager', to: 'dogs#manager_index', as: 'dogs_manager'

  resources :sessions, only: %i[new create destroy]
  resources :password_resets
  resources :passwords

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

  get '/sign_in',              to: 'sessions#new', as: 'sign_in'
  delete '/sign_out',          to: 'clearance/sessions#destroy', as: 'sign_out'

  get '/adopt',                to: 'adopters#new'

  get '/contact',              to: 'pages#contact'

  get '/funding-partners',                  to: 'pages#funding_partners'
  get '/community-partners',                to: 'pages#community_partners'
  get '/non-profit-and-corporate-partners', to: 'pages#np_corp_partners'
  get '/shelter-partners',                  to: 'pages#shelters'
  get '/training-partners',                 to: 'pages#training_partners'

  get '/international',                                 to: 'pages#international'
  get '/international/kaw',                             to: 'pages#international-kaw'
  get '/international/tcspca',                          to: 'pages#international-tcspca'
  get '/international/volunteer-takes-oph-to-india',    to: 'pages#international-article'

  get '/guide',                to: 'pages#guide'
  get '/aboutus',              to: 'pages#aboutus'

  get '/documentary',          to: 'pages#documentary'
  get '/insurance',            to: 'pages#insurance'

  get '/get-involved',         to: 'pages#get_involved'
  get '/volunteer',            to: 'pages#volunteer'
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
