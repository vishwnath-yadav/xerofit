class AddIsExemptToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_exempt, :boolean, default: false
  end
end
