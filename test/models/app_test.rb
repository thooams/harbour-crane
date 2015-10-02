require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'create App' do
    @app             = App.new
    @app.name        = 'My App'
    @app.description = 'My first App'
    @app.author      = 'John Doe'

    @app.generate
  end
end
