require 'test_helper'

class AppTest < ActiveSupport::TestCase
  include Rails.application.helpers
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    @app = App.where({
      name:          'My App',
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
      "state"        => 'stopped',
      "author"       => "John Doe",
      "description"  => "My first App",
      "image"        => "hello-world",
      "category"     => 'web',
      "environment"  => nil,
      "virtual_host" => "my-app.test.com"
    }
    assert_equal expected, actual
  end

  test 'Create compose file' do
    actual   = File.read(@compose_file)
    expected = "version: '2'
services:
  web:
    image: hello-world
    container_name: #{ @app.slug }
    ports:
      - 3001:3000
    volumes:
      - #{ volumes_app_dir(@app.slug) }:/usr/src/app/public/system
      - #{ log_app_dir(@app.slug) }:/usr/src/app/log
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
    container = Container.find_by_name(@app.slug)

    assert_equal 'running', @app.state
    assert_equal 'running', container.status
  end

  test 'Stop App' do
    @app.start if @app.stopped?
    @app.stop
    container = Container.find_by_name(@app.slug)
    ap container

    assert_equal 'stopped', @app.state
    assert_equal 'exited', container.status
  end

  test 'Remove App' do
    slug = @app.slug
    @app.destroy
    container = Container.find_by_name(slug)

    assert_equal nil, container
    assert !File.exists?(@compose_file), 'File exist'
  end
end
