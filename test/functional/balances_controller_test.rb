require 'test_helper'

class BalancesControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
