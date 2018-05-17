STATIC_PAGES = [ '5k', 'contact', 'funding-partners', 'community-partners', 'non-profit-and-corporate-partners',
                 'shelter-partners', 'training-partners', 'guide', 'aboutus', 'documentary', 'insurance',
                 'get-involved', 'volunteer', 'foster', 'fosterfaq', 'donate', 'sponsor',
                 'special-funds', 'other-ways-to-give', 'terms', 'resources', 'tips-for-finding-lost-pets', 'status_definitions',
                 'dog-status-definitions', 'education-and-outreach' ]

RescueRails::Application.routes.draw do
  get "/adopters/check_email", to: "adopters#check_email"

  resources :adopters do
    resources :comments, except: %i[destroy edit update]
    resources :adoptions
  end

  resources :comments, except: %i[new]

  resources :dogs do
    resources :comments
    resources :photos do
      collection { post :sort }
    end
    resources :adoptions
  end
  get '/dogs_manager', to: 'dogs#manager_index', as: 'dogs_manager'

  resources :sessions, only: %i[new create destroy]

  get '/events/past', to: 'events#past'

  resources :adoption_app, :users, :password_resets, :events, :adoptions, :folders, :attachments, :shelters

  resources :banned_adopters do
    collection { post :import }
  end

  root  to: 'pages#home'

  STATIC_PAGES.each do |page|
    get("/#{page}", to: "pages##{page.underscore}")
  end


  get '/signin',               to: 'sessions#new'
  get '/signout',              to: 'sessions#destroy'
  get '/adopt',                to: 'adopters#new'

end
