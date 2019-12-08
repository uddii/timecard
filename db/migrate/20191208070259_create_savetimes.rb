class CreateSavetimes < ActiveRecord::Migration[6.0]
  def change
    create_table :savetimes do |t|
      t.string :who
      t.time :start
      t.time :end
      t.date :day
      t.timestamps
    end
  end
end
