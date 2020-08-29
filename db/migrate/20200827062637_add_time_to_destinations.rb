class AddTimeToDestinations < ActiveRecord::Migration[5.2]
  def change
    add_column :destinations, :time, :string
  end
end
