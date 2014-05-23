require 'test_helper'

class SurahsControllerTest < ActionController::TestCase
  setup do
    @surah = surahs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:surahs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create surah" do
    assert_difference('Surah.count') do
      post :create, surah: { memory: @surah.memory, name: @surah.name }
    end

    assert_redirected_to surah_path(assigns(:surah))
  end

  test "should show surah" do
    get :show, id: @surah
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @surah
    assert_response :success
  end

  test "should update surah" do
    patch :update, id: @surah, surah: { memory: @surah.memory, name: @surah.name }
    assert_redirected_to surah_path(assigns(:surah))
  end

  test "should destroy surah" do
    assert_difference('Surah.count', -1) do
      delete :destroy, id: @surah
    end

    assert_redirected_to surahs_path
  end
end
