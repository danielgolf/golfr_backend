require 'test_helper'

# Class used to test the users controller
class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    Rails.application.load_seed

    @user = User.first
  end

  test 'scores limit' do
    sign_in @user

    get api_feed_url, as: :json
    assert_response :success

    feed = JSON.parse(response.body)
    assert feed['scores'].count <= 25
    @scores = @user.scores.order(played_at: :desc, id: :desc)
  end

  test 'should get show' do
    get api_golfers_url(@user.id)
    assert_response :success

    user = JSON.parse(response.body)

    assert_equal(@user.to_json, user['user'])
  end

  test 'should get scores' do
    get api_golfers_scores_url(@user.id)
    assert_response :success

    scores = JSON.parse(response.body)

    assert_equal(@scores.count, scores['user']['scores'].count)
  end
end
