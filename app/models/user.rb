class User < ApplicationRecord
  has_many :expert_topics, dependent: :destroy
  has_many :request_senders, foreign_key: :request_sender_id,
    class_name: :Friendship, dependent: :delete_all
  has_many :request_receivers, foreign_key: :request_receiver_id,
    class_name: :Friendship, dependent: :delete_all

  validates :first_name, :web_url, presence: true

  after_create :generate_short_url
  after_create :extract_web_url_headings

  def generate_short_url
    WebUrlShortener.perform_async(self.id)
  end

  def extract_web_url_headings
    ScrapeWebHeadingsWorker.perform_async(self.id)
  end

  def self.all_with_friend_count
    User.select('users.*, COUNT(friendships.request_receiver_id) as friend_count')
      .joins("LEFT OUTER JOIN friendships on users.id = friendships.request_sender_id")
      .group("users.id")
  end
end
