Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :projects do
    resources :tasks
  end
  
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "projects#index"
  namespace :api do
    namespace :v1 do 
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        post 'forgot_password', to: 'passwords#forgot_password'
        post 'reset_password', to: 'passwords#reset_password'
        delete "logout", to: "sessions#logout"
      end
       # Projects
       resources :projects, only: [:index, :create, :destroy, :update, :show]
    end
  end
end
