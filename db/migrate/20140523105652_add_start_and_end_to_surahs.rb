class AddStartAndEndToSurahs < ActiveRecord::Migration
  def change
  	add_column :surahs, :start, :integer
  	add_column :surahs, :end, :integer
  end
end
