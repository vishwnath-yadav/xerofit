class ChangeColumndefaultvalue < ActiveRecord::Migration
  def change
  	change_column :blocks, :minutes, :integer, default: 1
  end
end
