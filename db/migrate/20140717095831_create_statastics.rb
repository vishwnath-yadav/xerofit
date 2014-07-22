class CreateStatastics < ActiveRecord::Migration
  def change
    create_table :statastics do |t|
      t.integer :visits, default: 0
      t.belongs_to :workout, index: true

      t.timestamps
    end
  end
end
