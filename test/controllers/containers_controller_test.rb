require 'test_helper'

class ContainersControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get containers_url
    assert_response :success
  end

  test "should destroy container" do
    container = Container.first_or_create('hello-world-container')

    assert_difference('Container.count', -1) do
      delete container_url(id: container.id)
    end

    assert_redirected_to containers_url
  end

end
