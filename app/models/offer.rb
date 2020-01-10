class Offer < ApplicationRecord
  belongs_to :tutor
  belongs_to :help_request
  enum state: [:pending, :accepted, :declined]

  def accepted?
    state == 'accepted'
  end
end
