class ChangeDataDateToDestinations < ActiveRecord::Migration[5.2]
  def change
    change_column :destinations, :date, :string
  end
end
