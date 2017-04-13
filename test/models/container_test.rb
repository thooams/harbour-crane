require 'test_helper'

class ContainerTest < ActiveSupport::TestCase

  def setup
    Image.first_or_create(name: 'hello-world')
    Container.first_or_create(image: 'hello-world', name: 'hello-world-container')
  end

  test 'find by name' do
    actual   = Container.find_by_name('hello-world-container').name
    expected = 'hello-world-container'

    assert_equal expected, actual
  end

  test 'all' do
    actual   = Container.all.count
    expected = Docker::Container.all(all: true).count

    assert_equal expected, actual
  end

  test 'find by id' do
    container = Container.find_by_name('hello-world-container')
    actual    = Container.find(container.id).name
    expected  = 'hello-world-container'

    assert_equal expected, actual
  end

  test 'first_or_create' do
    container = Container.first_or_create(name: 'hello-world-container', image: 'hello-world')
    actual    = container.name
    expected  = 'hello-world-container'

    assert_equal expected, actual
  end

  test 'destroy' do
    container = Container.find_by_name('hello-world-container')
    container.destroy(true)
    expected = Container.find_by_name('hello-world-container')

    assert_nil expected
  end

  test 'run' do
    container = Container.find_by_name('hello-world-container')
    container.destroy(true)
    actual   = Container.run(image: 'hello-world', name: 'hello-world-container').name
    expected = 'hello-world-container'

    assert_equal expected, actual
  end

end
