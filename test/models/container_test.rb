require 'test_helper'

class ContainerTest < ActiveSupport::TestCase

  def setup
    Container.run('hello-world', name: 'hello-world-container') if Container.find_by_name('hello-world-container').nil?
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

  test 'destroy' do
    container = Container.find_by_name('hello-world-container')
    container.destroy(true)
    actual   = Container.find_by_name('hello-world-container')
    expected = nil

    assert_equal expected, actual
  end

end
