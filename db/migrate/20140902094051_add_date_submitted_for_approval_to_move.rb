class AddDateSubmittedForApprovalToMove < ActiveRecord::Migration
  def change
    add_column :moves, :date_submitted_for_approval, :datetime
    add_column :workouts, :date_submitted_for_approval, :datetime
  end
end
