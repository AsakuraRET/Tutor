class Tutor < User
  has_many :help_requests
  has_many :offers
  has_many :chats
end
