require 'rails_helper'

describe Api::UsersController, type: :controller do
  describe 'POST login' do
    before :each do
      create(:user, email: 'user@email.com', password: 'userpass')
    end

    it 'should return the token if valid username/password' do
      post :login, params: { email: 'user@email.com', password: 'userpass' }

      expect(response).to have_http_status(:ok)
      response_hash = JSON.parse(response.body)
      user_data = response_hash['user']

      expect(user_data['token']).to be_present
    end

    it 'should return an error if invalid username/password' do
      post :login, params: { email: 'invalid', password: 'user' }

      expect(response).to have_http_status(401)
    end
  end

  describe 'GET user scores' do
    before :each do
      @user1 = create(:user, name: 'User1', email: 'user1@email.com', password: 'userpass')
      user2 = create(:user, name: 'User2', email: 'user2@email.com', password: 'userpass')
      @score1 = create(:score, user: @user1, total_score: 79, played_at: '2021-05-20')
      @score2 = create(:score, user: @user1, total_score: 99, played_at: '2021-06-20')
      @score3 = create(:score, user: user2, total_score: 68, played_at: '2021-06-13')
    end

    it 'should return an error if not logged in' do
      get :user_scores, params: { uid: 1 }
      expect(response).to have_http_status(401)
    end

    it 'should return user feed if logged in' do
      sign_in(@user1, scope: :user)
      get :user_scores, params: { uid: 5 }
      expect(response).to have_http_status(200)
      response_hash = JSON.parse(response.body)
      scores = response_hash['scores']

      expect(scores.size).to eq 2
      expect(scores[0]['user_name']).to eq 'User1'
      expect(scores[0]['total_score']).to eq 99
      expect(scores[0]['played_at']).to eq '2021-06-20'
      expect(scores[1]['total_score']).to eq 79
    end
  end
end
