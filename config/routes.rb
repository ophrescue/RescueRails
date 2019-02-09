STATIC_PAGES = ['5k', 'contact', 'funding-partners', 'community-partners', 'non-profit-and-corporate-partners',
                'shelter-partners', 'training-partners', 'guide', 'aboutus', 'documentary', 'insurance',
                'get-involved', 'volunteer', 'foster', 'fosterfaq', 'donate', 'sponsor',
                'special-funds', 'other-ways-to-give', 'terms', 'resources', 'tips-for-finding-lost-pets', 'status_definitions',
                'education-and-outreach'].freeze

RescueRails::Application.routes.draw do
  get "/adopters/check_email", to: "adopters#check_email"

  resources :adopters do
    resources :comments, except: %i[destroy edit update]
    resources :adoptions
  end

  resources :donations do
    collection do
      get 'history', to: 'donations#history'
    end
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

  resources :sessions, only: %i[new create destroy]

  get '/events/:scope', to: 'events#index', scope: /(past|upcoming)/, as: "scoped_events"

  get '/campaigns/:scope', to: 'campaigns#index', scope: /(inactive|active)/, as: "scoped_campaigns"

  resources :adoptions,
            :adoption_app,
            :campaigns,
            :events,
            :folders,
            :passwords,
            :password_resets,
            :shelters

  resources :attachments, only: %i[show destroy]
  resources :folder_attachments, only: %i[index update]

  resources :users do
    resource :password, controller: :passwords, only: %i[create edit update]
  end

  resources :banned_adopters do
    collection { post :import }
  end

  root to: 'pages#home'

  STATIC_PAGES.each do |page|
    get("/#{page}", to: "pages##{page.underscore}")
  end

  get 'sample_image/:type',    to: 'sample_images#show', constraints: { type: /map/ }, as: 'sample_image'

  get '/signin',               to: 'sessions#new'
  get '/signout',              to: 'sessions#destroy'

  get '/sign_in',              to: 'sessions#new', as: 'sign_in'
  get '/sign_out',             to: 'clearance/sessions#destroy', as: 'sign_out'

  get '/adopt',                to: 'adopters#new'

  get '/international',                                 to: 'pages#international'
  get '/international/kaw',                             to: 'pages#international-kaw'
  get '/international/tcspca',                          to: 'pages#international-tcspca'
  get '/international/volunteer-takes-oph-to-india',    to: 'pages#international-article'
  get '/international/7000-miles-home',                 to: 'pages#7000-miles-home'
end
