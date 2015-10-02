require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'create App' do
    @app = App.new name: 'My App', description: 'My first App', author: 'John Doe'
    @app.generate
  end
end
