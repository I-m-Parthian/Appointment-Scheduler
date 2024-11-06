# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
start_date = DateTime.now.beginning_of_day
# Create appointments for the next 7 days
end_date = start_date + 7.days

# Create sample appointments
(1..20).each do |i|
  date_time = rand(start_date..end_date)
  status = %w[available booked].sample
  details = "Appointment details for slot #{i}"

  Appointment.create!(
    date_time: date_time,
    status: status,
    details: details
  )
end