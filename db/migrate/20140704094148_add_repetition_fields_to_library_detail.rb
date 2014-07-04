class AddRepetitionFieldsToLibraryDetail < ActiveRecord::Migration
  def change
  	add_column :library_details, :rep_min, :string
  	add_column :library_details, :rep_max, :string
  	add_column :library_details, :rep_each_side, :boolean
  	add_column :library_details, :rep_option, :string
  end
end
