class ChangeColumnInLibraryDetail < ActiveRecord::Migration
  def change
  	rename_column :library_details, :repetition, :repetitions
  	rename_column :library_details, :is_duration, :duration
  	rename_column :library_details, :is_tempo, :tempo
  end
end
