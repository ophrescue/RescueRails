STATIC_PAGES = ['contact', 'funding-partners', 'community-partners', 'non-profit-and-corporate-partners',
  'training-partners', 'guide', 'aboutus', 'documentary', 'insurance', 'home','pup-tastic-parties',
  'get-involved', 'volunteer', 'faq', 'foster', 'fosterfaq', 'donate', 'sponsor', 'newsletters', 'calendar',
  'other-ways-to-give', 'terms', 'resources', 'tips-for-finding-lost-pets', 'status_definitions', 'shop',
  'education-and-outreach','adoption-fee-payments','microchip-registration', 'shelterlove-cat-gallery', 'shelterlove-dog-gallery'].freeze

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/adopters/check_email", to: "adopters#check_email"

  get "/adopters/complete", to: "adopters#complete"

  resources :adopters do
    resources :comments, except: %i[destroy edit update]
    resources :adoptions
    resources :cat_adoptions
  end

  resources :donations do
    collection do
      get 'history', to: 'donations#history'
    end
  end

  get '/dogs',                                    to: 'pages#shelterlove-dog-gallery'
  get '/cats',                                    to: 'pages#shelterlove-cat-gallery'

  resources :comments, except: %i[new]

  resources :cats, controller: 'cats/gallery', only: %i[index show] do
    resources :treatment_records
  end

  resources :dogs, controller: 'dogs/gallery', only: %i[index show] do
    resources :treatment_records
  end

  resources :photos do
    collection { post :sort }
  end

  resources :dogs_manager, controller: 'dogs/manager' do
    resources :comments
    resources :adoptions
    resources :treatment_records
  end

  resources :cats_manager, controller: 'cats/manager' do
    resources :comments
    resources :cat_adoptions
    resources :treatment_records
  end

  resources :volunteer_apps do
    resources :comments, except: %i[destroy edit update]
  end

  resources :bulletins, controller: :posts, type: 'Bulletin'
  resources :opportunities, controller: :posts, type: 'Opportunity'
  resources :infos, controller: :posts, type: 'Info'

  resources :sessions, only: %i[new create destroy]

  get '/events/:scope', to: 'events#index', scope: /(past|upcoming)/, as: "scoped_events"

#  get '/campaigns/:scope', to: 'campaigns#index', scope: /(inactive|active)/, as: "scoped_campaigns"

  resources :adoption_app,
#            :campaigns,
            :dashboards,
            :events,
            :folders,
            :passwords,
            :password_resets,
            :shelters,
            :treatments,
            :invoices,
            :users_badges

  post '/invoices/stripe_webhook', to: 'invoices#stripe_webhook'
  get "/invoice_thank_you",        to: 'invoices#thank_you'

  resources :invoices do
    member do
      post :record_contract
      post :begin_checkout
    end
  end

  resources :adoptions do
    resources :invoices
  end

  resources :cat_adoptions do
    resources :invoices
  end

  resources :party_contact_form, only: %i[new create]

  resources :badges
  resources :attachments, only: %i[show destroy]
  resources :folder_attachments, only: %i[index update]

  resources :users do
    member do
      patch :create_release_contract
    end
    resource :password, controller: :passwords, only: %i[create edit update]
  end

  resources :banned_adopters do
    collection { post :import }
  end

  #root to: 'pages#home'

  constraints Clearance::Constraints::SignedIn.new do
    root to: "dashboards#index", as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "pages#home"
  end

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
  get '/international/7000-miles-home',                 to: 'pages#7000-miles-home'
  get '/international/hope-for-hope',                   to: 'pages#hope-for-hope'
end
