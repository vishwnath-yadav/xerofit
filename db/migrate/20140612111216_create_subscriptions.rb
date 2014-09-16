class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :stripe_card_token
      t.string :customer_id
      t.integer :user_id

      t.timestamps
    end
  end
end
