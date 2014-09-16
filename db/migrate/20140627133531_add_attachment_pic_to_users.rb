class AddAttachmentPicToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :pic
    end
  end

  def self.down
    drop_attached_file :users, :pic
  end
end
