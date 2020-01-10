class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages

  def student?
    type == "Student"
  end

  def tutor?
    type == "Tutor"
  end

  def admin?
    role == 'admin'
  end

  def self.to_csv(options = {})
    send_atributes = [
      "id",
      "first_name",
      "last_name",
      "user_name",
      "age",
      "major",
      "school",
      "address"
    ]

    CSV.generate(options) do |csv|
      csv << send_atributes + ["pending", "in progress", "finished"]
      all.each do |user|
        status_of_help_requests = [
          user.help_requests.pending.count,
          user.help_requests.in_progress.count,
          user.help_requests.finished.count
        ]
        csv << user.attributes.values_at(*send_atributes) + status_of_help_requests
      end
    end
  end

end
