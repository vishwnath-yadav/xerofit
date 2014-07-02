class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :address1
      t.string :address2
      t.string :state
      t.integer :pin_code
      t.integer :phone_number
      t.integer :user_id

      t.timestamps
    end
  end
end
