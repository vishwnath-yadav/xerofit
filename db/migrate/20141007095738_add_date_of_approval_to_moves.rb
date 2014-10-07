class AddDateOfApprovalToMoves < ActiveRecord::Migration
  def change
    add_column :moves, :date_of_approval, :datetime
  end
end
