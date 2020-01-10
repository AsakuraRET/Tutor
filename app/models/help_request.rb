class HelpRequest < ApplicationRecord
  has_one_attached :problem_picture
  belongs_to :subject
  belongs_to :student
  belongs_to :tutor, optional: true
  enum state: [:pending, :in_progress, :finished]
  has_many :offers

  validates :price, :numericality => { :greater_than => 0 }

  scope :ordered, -> (direction){
    order(created_at: direction == "1" ? :desc : :asc)
  }

  scope :searched, -> (subject_ids, direction){
    where("subject_id IN (#{subject_ids})").ordered(direction)
  }

  def in_progress?
    state == 'in_progress'
  end

  def help_request_price_or_offer_price
    return offers.where(state: 1)[0].new_price if offers.where(state: 1)[0].present?
    price
  end
end
