require 'test_helper'

class ImagesControllerTest < ActionController::TestCase

  def setup
    ap Image.find_by_name('hello-world')
    #  .destroy
    Image.pull('hello-world')
    @image = Image.find('hello-world')
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image" do
    assert_difference('Image.count') do
      post :create, image: {
        name: @image.names.split(',')[0].split(':')[0],
        tag:  @image.names.split(',')[0].split(':')[1]
      }
    end

    assert_redirected_to images_path
  end

  #test "should get edit" do
    #get :edit
    #assert_response :success
  #end

end
