require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get filter_by" do
    get :filter_by
    assert_response :success
  end

end
