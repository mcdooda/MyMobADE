require 'test_helper'

class AgendaControllerTest < ActionController::TestCase
  test "should get day" do
    get :day
    assert_response :success
  end

  test "should get week" do
    get :week
    assert_response :success
  end

  test "should get month" do
    get :month
    assert_response :success
  end

  test "should get all" do
    get :all
    assert_response :success
  end

end
