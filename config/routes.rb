Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :posts do
    resources :comments, except: [:index, :show, :new]
    resources :likes, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show] do
    resources :friendships, except: [:show, :edit, :update], shallow: true
  end

  get 'users/:user_id/friendships/pending', to: 'friendships#pending', as: :pending_friendships
  post 'users/:user_id/friendships/pending', to: 'friendships#accept', as: :accept_friendship

  devise_scope :user do
    authenticated :user do
      root to: "posts#index", as: :authenticated_root
    end

    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

end
