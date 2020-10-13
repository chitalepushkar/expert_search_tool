json.extract! friendship, :id, :request_sender_id, :request_receiver_id, :created_at, :updated_at
json.friend_profile_url user_url(friendship.request_receiver_id)
json.url friendship_url(friendship, format: :json)
