require "test_helper"

class StatsControllerTest < ActionDispatch::IntegrationTest
  test "should get week" do
    get stats_week_url
    assert_response :success
  end
end
