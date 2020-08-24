Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :posts do
    resources :comments, except: [:index, :show, :new]
  end

  resources :users, only: [:index, :show]

  authenticated :user do
    root to: "posts#index", as: :authenticated_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end

end
