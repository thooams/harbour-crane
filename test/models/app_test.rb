require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'create App' do
    @app = App.new({
      name:          'My App',
      description:   'My first App',
      author:        'John Doe',
      ports:         '3001:3000',
      image:         'test/test',
      virtual_host:  'my-app.test.com'
    })

    @app.generate

    assert File.exists?(@app.compose_app_dir(@app.slug))
    assert File.exists?(@app.upstart_app_dir(@app.slug))
    assert File.exists?(@app.app_dir(@app.slug))
  end


  #test 'remove App' do
  #  @app = App.find 'my-app'
  #  @app.destroy

  #  assert !File.exists?(@app.compose_app_dir(@app.slug)), 'File exist'
  #  assert !File.exists?(@app.upstart_app_dir(@app.slug))
  #  assert !File.exists?(@app.app_dir(@app.slug))
  #end
end
