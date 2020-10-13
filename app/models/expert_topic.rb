class ExpertTopic < ApplicationRecord
  belongs_to :user

  validates :user_id, :topic, presence: true

  def self.expert_search(requester_id, query)
    # Query to search for experts by making a self join with friendships table.
    # The query returns a list containing 3 entities:
    # 1. Friend who is connected to the expert.
    # 2. Expert in the topic.
    # 3. Topic of expertise.
    search_records = ActiveRecord::Base.connection.execute(
      "select friend.id as friend_id, friend.first_name as friend_name,"\
      " expert.id as expert_id, expert.first_name as expert_name, et.topic"\
      " from friendships f1 inner join friendships f2 on f1.request_receiver_id = f2.request_sender_id"\
      " inner join expert_topics et on f2.request_receiver_id = et.user_id"\
      " inner join users friend on f2.request_sender_id = friend.id"\
      " inner join users expert on f2.request_receiver_id = expert.id"\
      " where f1.request_sender_id = #{requester_id}"\
      " and f2.request_sender_id <> #{requester_id} and f2.request_receiver_id <> #{requester_id}"\
      " and lower(et.topic) LIKE '%#{query.downcase}%'"
    )

    search_records.map do |search_result|
      search_result["friend_name"] + "->" + search_result["expert_name"] + "->" + search_result["topic"]
    end
  end
end
