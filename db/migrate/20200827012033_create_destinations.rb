class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|
      t.string :to
      t.string :from
      t.date :date
      t.text :outline
      t.text :detail
      t.text :notice
      t.text :reference
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
