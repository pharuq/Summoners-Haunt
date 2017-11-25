Rails.application.routes.draw do
  # get 'community_topics/new'
  # get 'community_topics/edit'
  # get 'community_topics/show'
  # get 'community_topics/index'
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout' , to: 'sessions#destroy'
  resources :users do
    member do
      get :diaries
      get :friends
      get :communities
    end
    collection do
      get :feed
    end
    resources :messages,             only: [:new, :create, :index]
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
