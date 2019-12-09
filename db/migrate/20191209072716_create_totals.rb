class CreateTotals < ActiveRecord::Migration[6.0]
  def change
    create_table :totals do |t|
      t.integer :totalhour ,default: 0
      t.integer :totalminutes, default: 0
      t.string :who
      t.timestamps
    end
  end
end
