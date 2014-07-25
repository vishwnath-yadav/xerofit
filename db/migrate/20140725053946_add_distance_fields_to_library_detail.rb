class AddDistanceFieldsToLibraryDetail < ActiveRecord::Migration
  def change
    add_column :library_details, :dist_option, :string
    add_column :library_details, :dist_val, :integer, default: 1
    add_column :library_details, :weight_val, :integer, default: 1
  end
end
