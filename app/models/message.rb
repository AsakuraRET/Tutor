class Message < ApplicationRecord

  belongs_to :user
  belongs_to :chat

  validates :body, presence: true

end
