require 'test_helper'

class ExpertTopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expert_topic = expert_topics(:one)
  end

  test "should get index" do
    get expert_topics_url, as: :json
    assert_response :success
  end

  test "should create expert_topic" do
    assert_difference('ExpertTopic.count') do
      post expert_topics_url, params: { expert_topic: { topic: @expert_topic.topic, user_id: @expert_topic.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show expert_topic" do
    get expert_topic_url(@expert_topic), as: :json
    assert_response :success
  end

  test "should update expert_topic" do
    patch expert_topic_url(@expert_topic), params: { expert_topic: { topic: @expert_topic.topic, user_id: @expert_topic.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy expert_topic" do
    assert_difference('ExpertTopic.count', -1) do
      delete expert_topic_url(@expert_topic), as: :json
    end

    assert_response 204
  end
end
