require 'test_helper'

class LemmasControllerTest < ActionController::TestCase
  setup do
    @lemma = lemmas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lemmas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lemma" do
    assert_difference('Lemma.count') do
      post :create, lemma: { entry_id: @lemma.entry_id, text: @lemma.text }
    end

    assert_redirected_to lemma_path(assigns(:lemma))
  end

  test "should show lemma" do
    get :show, id: @lemma
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lemma
    assert_response :success
  end

  test "should update lemma" do
    patch :update, id: @lemma, lemma: { entry_id: @lemma.entry_id, text: @lemma.text }
    assert_redirected_to lemma_path(assigns(:lemma))
  end

  test "should destroy lemma" do
    assert_difference('Lemma.count', -1) do
      delete :destroy, id: @lemma
    end

    assert_redirected_to lemmas_path
  end
end
