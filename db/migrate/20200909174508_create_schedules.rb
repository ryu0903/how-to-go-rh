class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :to
      t.string :from
      t.string :date
      t.string :time
      t.text :detail
      t.text :notice
      t.string :picture
      t.references :destination, foreign_key: true

      t.timestamps
    end
  end
end
