SampleApp::Application.routes.draw do
  # resources :articals

  get "/articals/manage", to: 'articals#manage'
  get "/users/search", to: 'users#search'

  post "/upload_thumb_up_num", to: 'articals#upload_thumb_up_num'
  
    # 关注
  resources :relationships,       only: [:create, :destroy]
  
  resources :users do
    member do
      # /users/1/following
      # /users/1/followers
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
