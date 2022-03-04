require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  test "should get posts" do
    get rooms_posts_url
    assert_response :success
  end
end
