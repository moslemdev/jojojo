class CreateSurahs < ActiveRecord::Migration
  def change
    create_table :surahs do |t|
      t.string :name
      t.integer :memory

      t.timestamps
    end
  end
end
