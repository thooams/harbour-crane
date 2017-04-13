require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    Image.first_or_create(name: 'hello-world')
  end

  test 'pull' do
    actual   = Image.pull(name: 'hello-world').name
    expected = 'hello-world'

    assert_equal expected, actual
  end

  test 'create' do
    actual   = Image.create(name: 'hello-world').name
    expected = 'hello-world'

    assert_equal expected, actual
  end

  test 'find by name' do
    actual   = Image.find_by_name('hello-world').name
    actual2  = Image.find_by_name('hello-world:latest').name
    expected = 'hello-world'

    assert_equal expected, actual
    assert_equal expected, actual2
  end

  test 'all' do
    actual   = Image.all.count
    expected = Docker::Image.all.count

    assert_equal expected, actual
  end

  test 'find by id' do
    image    = Image.find_by_name('hello-world')
    actual   = Image.find(image.id).name
    expected = 'hello-world'

    assert_equal expected, actual
  end

  test 'destroy' do
    Image.find_by_name('hello-world').destroy
    expected = Image.find_by_name('hello-world')

    assert_nil expected
  end

  test 'destroy_all' do
    hw_tutum    = Image.first_or_create(name: 'tutum/hello-world')
    hw          = Image.find_by_name('hello-world')
    image_count = Image.count

    Image.destroy_all(hw_tutum.id, hw.id)
    assert_equal Image.count, image_count - 2
  end

end
