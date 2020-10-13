class Friendship < ApplicationRecord
	belongs_to :request_sender, class_name: 'User'
	belongs_to :request_receiver, class_name: 'User'

	validates :request_sender, uniqueness: { scope: :request_receiver }

	after_save :create_reverse_friendship
	after_destroy :destroy_reverse_friendship

  def create_reverse_friendship
    self.class.where(
      request_sender: request_receiver_id, request_receiver: request_sender_id
    ).first_or_create
  end

  def destroy_reverse_friendship
    self.class.find(
      request_sender: request_receiver_id, request_receiver: request_sender_id
    )&.destroy
  end
end
