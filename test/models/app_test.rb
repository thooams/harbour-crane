require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'create App' do
    @app              = App.new
    @app.name         = 'My App'
    @app.description  = 'My first App'
    @app.author       = 'John Doe'
    @app.ports        = '3001:3000'
    @app.image        = 'test/test'
    @app.virtual_host = 'my-app.test.com'

    @app.generate
  end
end
