require 'test_helper'

class ImagesControllerTest <  ActionDispatch::IntegrationTest

  def setup
  end

  test "should get index" do
    get images_url
    assert_response :success
  end

  test "should get new" do
    get new_image_url
    assert_response :success
  end

  test "should create image" do
    image = Image.find_by_name('hello-world')
    image.destroy unless image.nil?
    assert_difference('Image.count') do
      post images_url, params: {
        image: {
          name: 'hello-world',
          tag:  'latest'
        }
      }
    end

    assert_redirected_to images_url
  end

  test "should destroy image" do
    image = Image.find_by_name('hello-world')
    image = image.nil? ? Image.pull(name: 'hello-world') : image

    assert_difference('Image.count', -1) do
      delete image_url(id: image.id)
    end

    assert_redirected_to images_url
  end

  #test "should get edit" do
    #get :edit
    #assert_response :success
  #end

end
