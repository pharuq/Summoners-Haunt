Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  get  '/about',  to: 'static_pages#about'
  # get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout' , to: 'sessions#destroy'
  resources :users do
    member do
      get :edit_password
      get :leave
      get :diaries
      get :friends
      get :communities
      get :message
    end
    collection do
      get :messages
    end
    resources :messages,             only: [:create]
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :diaries
  resources :diary_comments,     only: [:create, :destroy]
  resources :friendships,              only: [:create, :update, :destroy]
  resources :communities do
    resources :community_topics do
      resources :community_comments,     only: [:create, :destroy]
    end
    member do
      get :members
    end
  end
  resources :communityships,      only: [:create, :destroy]


end
