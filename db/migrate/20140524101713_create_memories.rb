class CreateMemories < ActiveRecord::Migration
  def change
    create_table :memories do |t|
      t.integer :ayah_index
      t.integer :memory
      t.integer :user_id

      t.timestamps
    end
  end
end
