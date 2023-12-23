Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post "public/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
    end
    root to: 'homes#top'
    get 'tagsearches/search', to: 'tagsearches#search'
  end

  scope module: :public do
    get 'users/mypage', to: 'users#mypage'
    get 'users/mypage/edit', to: 'users#edit'
    get 'users/inactive', to: 'users#inactive'
    get 'users/draft', to: 'users#draft'
    patch 'users/mypage', to: 'users#update'
    get 'users/confirm' => 'users#confirm'
    patch 'users/withdrawal' => 'users#withdrawal'
    resources :users, only: [:index, :show] do
      member do
        get :favorites_posts
      end
    end
    resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    root to: 'homes#top'
    get 'about' => 'homes#about', as: 'about'
    get 'tagsearches/search', to: 'tagsearches#search'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
