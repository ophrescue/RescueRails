STATIC_PAGES = ['5k', 'contact', 'funding-partners', 'community-partners', 'non-profit-and-corporate-partners',
                'shelter-partners', 'training-partners', 'guide', 'aboutus', 'documentary', 'insurance',
                'get-involved', 'volunteer', 'foster', 'fosterfaq', 'donate', 'sponsor',
                'special-funds', 'other-ways-to-give', 'terms', 'resources', 'tips-for-finding-lost-pets', 'status_definitions',
                'education-and-outreach']

RescueRails::Application.routes.draw do
  get "/adopters/check_email", to: "adopters#check_email"

  resources :adopters do
    resources :comments, except: %i[destroy edit update]
    resources :adoptions
  end

  resources :comments, except: %i[new]

  resources :dogs, controller: 'dogs/gallery', only: %i[index show]

  resources :photos do
    collection { post :sort }
  end

  resources :dogs_manager, controller: 'dogs/manager' do
    resources :comments
    resources :adoptions
  end

  resources :users do
    resource :password, controller: :passwords, only: %i[create edit update]
  end

  resources :sessions, only: %i[new create destroy]
  resources :password_resets
  resources :passwords

  get '/events/past', to: 'events#past'

  resources :adoption_app, :users, :password_resets, :events, :adoptions, :folders, :attachments, :shelters

  resources :banned_adopters do
    collection { post :import }
  end

  root to: 'pages#home'

  STATIC_PAGES.each do |page|
    get("/#{page}", to: "pages##{page.underscore}")
  end

  get '/signin',               to: 'sessions#new'
  get '/signout',              to: 'sessions#destroy'

  get '/sign_in',              to: 'sessions#new', as: 'sign_in'
  delete '/sign_out',          to: 'clearance/sessions#destroy', as: 'sign_out'

  get '/adopt',                to: 'adopters#new'

  get '/international',                                 to: 'pages#international'
  get '/international/kaw',                             to: 'pages#international-kaw'
  get '/international/tcspca',                          to: 'pages#international-tcspca'
  get '/international/volunteer-takes-oph-to-india',    to: 'pages#international-article'
end
