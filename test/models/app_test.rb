require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    @app = App.where({
      name:          'My App',
      slug:          'my-app',
      description:   'My first App',
      author:        'John Doe',
      ports:         '3001:3000',
      image:         'hello-world',
      virtual_host:  'my-app.test.com'
    }).first_or_create!
    @compose_file = @app.compose_app_file(@app.slug)
  end

  test 'Create app' do
    actual   = @app.attributes.except(*%w(id created_at updated_at))
    expected = {
      "name"         => "My App",
      "ports"        => "3001:3000",
      "volumes"      => nil,
      "slug"         => "my-app",
      "state"        => App.states[:stopped],
      "author"       => "John Doe",
      "description"  => "My first App",
      "image"        => "hello-world",
      "category"     => App.categories[:web],
      "virtual_host" => "my-app.test.com"
    }
    assert_equal expected, actual
  end

  test 'Create compose file' do
    actual   = File.read(@compose_file)
    expected = "web:
  image: hello-world
  container_name: #{ @app.slug }
  ports:
    - 3001:3000
  volumes:
    - /srv/docker/#{ @app.slug }/vol:/usr/src/app/public/system
    - /srv/docker/#{ @app.slug }/log:/usr/src/app/log
  environment:
    RAILS_ENV: production
    VIRTUAL_HOST: my-app.test.com
    SECRET_KEY_BASE: 53f5f599e08171a3c8959d7b7caecf1fec5b5e14
"
    assert File.exists?(@compose_file)
    assert_equal expected, actual
  end

  test 'Start App' do
    @app.start
    container = Container.find(@app.slug)

    assert_equal 'running', @app.state
    assert_equal 'running', container.state.status
  end

  test 'Stop App' do
    @app.state_run!
    @app.stop
    container = Container.find(@app.slug)

    assert_equal 'stopped', @app.state
    assert_equal 'exited', container.state.status
  end

  test 'Remove App' do
    @app.destroy
    container = Container.find(@app.slug)

    assert_equal 'exited', container.state.status
    assert !File.exists?(@compose_file), 'File exist'
  end
end
