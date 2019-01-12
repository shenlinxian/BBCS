SampleApp::Application.routes.draw do
  # resources :articals

  get "/users/search", to: 'users#search'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  get "/articals/search", to: 'articals#search'
  
  resources :articals do
    member do
      get :following, :followers
    end
  end



  resources :sessions,      only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
  root to: 'articals#index'



  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'


  #get '/' => 'passages#index'
  
  resources :articals do
    resources :replies
  end
  
  resources :replies
    

end
