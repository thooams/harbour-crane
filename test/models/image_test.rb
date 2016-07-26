require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    Image.pull(name: 'hello-world') if Image.find_by_name('hello-world').nil?
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
    expected = 'hello-world'

    assert_equal expected, actual
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
    image = Image.find_by_name('hello-world')
    image.destroy
    actual   = Image.find_by_name('hello-world')
    expected = nil

    assert_equal expected, actual
  end

end
