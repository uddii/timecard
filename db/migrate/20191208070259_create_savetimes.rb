class CreateSavetimes < ActiveRecord::Migration[6.0]
  def change
    create_table :savetimes do |t|
      t.string :who
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
