class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.datetime :date_time
      t.string :status
      t.text :details

      t.timestamps
    end
  end
end
