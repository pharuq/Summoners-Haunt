Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',  to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout' , to: 'sessions#destroy'
  resources :users do
    member do
      get :diaries
      get :friends
    end
    collection do
      get :feed
    end
    resources :messages,            only: [:new, :create, :index]
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :diaries
  resources :diary_comments,  only: [:create, :destroy]
  resources :friendships,           only: [:create, :update, :destroy]

end
