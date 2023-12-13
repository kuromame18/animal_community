Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    resources :users, only: [:show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update]
    root to: 'homes#top'
  end

  scope module: :public do
    get 'users/mypage', to: 'users#mypage'
    get 'users/mypage/edit', to: 'users#edit'
    patch 'users/mypage', to: 'users#update'
    resources :users, only: [:index, :show]
    resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create]
    end
    root to: 'homes#top'
    get 'about' => 'homes#about', as: 'about'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
