require 'test_helper'

class RootControllerTest < ActionController::TestCase
  test "should get splash" do
    get :splash
    assert_response :success
  end

end
