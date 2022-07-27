Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'golfers/:id', to: 'users#show', as: 'golfers'
    get 'golfers/:id/scores', to: 'users#scores', as: 'golfers_scores'
    get 'feed', to: 'scores#user_feed'
    resources :scores, only: %i[create destroy]
  end
end
