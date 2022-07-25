module Api
  # Controller that handles authorization and user data fetching
  class UsersController < ApplicationController
    include Devise::Controllers::Helpers

    def name
      user = User.find(params[:id])

      response = {
        user: {
          name: user.name
        }
      }

      render json: response.to_json
    end

    def scores
      user = User.find(params[:id])
      scores = user.scores.order(played_at: :desc, id: :desc)
      serialized_scores = scores.map(&:serialize)

      response = {
        user: {
          scores: serialized_scores
        }
      }

      render json: response.to_json
    end

    def login
      user = User.find_by('lower(email) = ?', params[:email])

      if user.blank? || !user.valid_password?(params[:password])
        render json: {
          errors: [
            'Invalid email/password combination'
          ]
        }, status: :unauthorized
        return
      end

      sign_in(:user, user)

      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          token: current_token
        }
      }.to_json
    end
  end
end
