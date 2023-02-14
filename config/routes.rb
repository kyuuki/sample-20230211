Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "tasks#index"
  resources :tasks

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  # 管理画面
  namespace :admin do
    resources :users
  end
end
