# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:first_name=>"Kyle", :last_name=>"Bollinger", :email=>"kyle@xerofit.com", :password=>"xerofit515", :role=>"admin",:enabled=>true)
User.create(:first_name=>"Kyle", :last_name=> "Bollinger", :email=>"kbollinger32@gmail.com", :password=>"xerofit515", :role=>"trainer", :enabled=>true)
User.create(:first_name=>"Dorian", :last_name=>"Chase", :email=>"dorian@xerofit.com", :password=>"xerofit515", :role=>"admin",:enabled=>true)
User.create(:first_name=>"Dorian", :last_name=> "Chase", :email=>"dorian73@gmail.com", :password=>"xerofit515", :role=>"trainer", :enabled=>true)

User.create(:first_name=>"Xero", :last_name=>"Admin", :email=>"admin@xerofit.com", :password=>"xerofit515", :role=>"admin",:enabled=>true)
User.create(:first_name=>"Xero", :last_name=> "Trainer", :email=>"trainer@xerofit.com", :password=>"xerofit515", :role=>"trainer", :enabled=>true)
User.create(:first_name=>"Xero", :last_name=> "User", :email=>"user@xerofit.com", :password=>"xerofit515", :role=>"normaluser", :enabled=>true)
