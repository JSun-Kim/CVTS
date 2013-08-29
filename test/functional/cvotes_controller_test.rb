require 'test_helper'

class CvotesControllerTest < ActionController::TestCase
  setup do
    @cvote = cvotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cvotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cvote" do
    assert_difference('Cvote.count') do
      post :create, cvote: { approval: @cvote.approval, ballot_id: @cvote.ballot_id, user_id: @cvote.user_id }
    end

    assert_redirected_to cvote_path(assigns(:cvote))
  end

  test "should show cvote" do
    get :show, id: @cvote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cvote
    assert_response :success
  end

  test "should update cvote" do
    put :update, id: @cvote, cvote: { approval: @cvote.approval, ballot_id: @cvote.ballot_id, user_id: @cvote.user_id }
    assert_redirected_to cvote_path(assigns(:cvote))
  end

  test "should destroy cvote" do
    assert_difference('Cvote.count', -1) do
      delete :destroy, id: @cvote
    end

    assert_redirected_to cvotes_path
  end
end
