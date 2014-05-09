Gigsurfing::Application.routes.draw do
  resources :activities, only: [:index]

  get 'tags/:tag', to: 'homepage#index', as: :genres
  resources :bands
  resources :statuses
  resources :instruments

  resources :user_friendships do
    member do
      put :accept
      put :block
    end
  end

  scope ":profile_name" do
    resources :albums do
      resources :pictures
    end
  end
  
  root "homepage#index"

  as :user do
    get "/register", :to => "devise/registrations#new", :as => :register
    get "/login", :to => "devise/sessions#new", :as => :login
    get "/logout", :to => "devise/sessions#destroy", :as => :logout
  end

  devise_for :users, skip: [:sessions]

  as :user do
    get "/login" => 'devise/sessions#new', as: :new_user_session
    post "/login" => 'devise/sessions#create', as: :user_session
    delete "/logout" => 'devise/sessions#destroy', as: :destroy_user_session
  end
  
  get '/:id', to: 'profiles#show', as: 'profile'
  

end
