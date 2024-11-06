class Appointment < ApplicationRecord
  validates :date_time, presence: true
  validates :status, inclusion: { in: %w(available booked canceled),
                                message: "%{value} is not a valid status" }

  def formatted_date_time
    date_time.strftime("%d/%m/%Y %I:%M%p")
  end
end
