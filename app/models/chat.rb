class Chat < ApplicationRecord

  belongs_to :student
  belongs_to :tutor

  has_many :messages

  def intercolutor user_type
    return tutor if user_type == 'Student'
    student
  end
end
