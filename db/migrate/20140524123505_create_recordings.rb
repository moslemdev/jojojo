class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.integer :surah_id

      t.timestamps
    end
  end
end
