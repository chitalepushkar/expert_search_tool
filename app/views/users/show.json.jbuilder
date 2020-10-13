json.partial! "users/user", user: @user
json.set! :topics do
  json.array! @user.expert_topics, partial: "expert_topics/expert_topic", as: :expert_topic
end

json.set! :friends do
  json.array! @user.request_senders, partial: "friendships/friendship", as: :friendship
end
