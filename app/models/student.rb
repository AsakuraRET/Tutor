class Student < User
  has_many :help_requests
  has_many :chats
  has_many :payment_sources
end
