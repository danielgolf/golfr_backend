require 'test_helper'

# Class used to test the users controller
class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.load_seed

    @user = User.first
    @scores = @user.scores.order(played_at: :desc, id: :desc)
  end

  test 'should get show' do
    get api_golfer_url(@user.id)
    assert_response :success

    user = JSON.parse(response.body)

    assert_equal(@user.to_json, user['user'])
  end

  test 'should get scores' do
    get api_golfer_scores_url(@user.id)
    assert_response :success

    scores = JSON.parse(response.body)

    assert_equal(@scores.count, scores['user']['scores'].count)
  end
end
