Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'golfer/:id/name', to: 'users#name'
    get 'golfer/:id/scores', to: 'users#scores'
    get 'feed', to: 'scores#user_feed'
    resources :scores, only: %i[create destroy]
  end
end
