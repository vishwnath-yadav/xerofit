class AddPinCodeAndDateOfBirthAndGenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pin_code, :integer
    add_column :users, :date_of_birth, :date
    add_column :users, :gender, :string
  end
end
