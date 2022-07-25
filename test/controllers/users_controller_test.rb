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
  end
end
