Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'golfer/:id', to: 'users#show', as: 'golfer'
    get 'golfer/:id/scores', to: 'users#scores', as: 'golfer_scores'
    get 'feed', to: 'scores#user_feed'
    resources :scores, only: %i[create destroy]
  end
end
