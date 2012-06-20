require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get project" do
    get :project
    assert_response :success
  end

  test "should get category" do
    get :category
    assert_response :success
  end

  test "should get branch" do
    get :branch
    assert_response :success
  end

end
