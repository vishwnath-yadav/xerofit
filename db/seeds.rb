# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:first_name=>"Admin", :email=>"Admin@xerofit.com", :password=>"admin123", :role=>"admin",:enabled=>true)
User.create(:first_name=>"Trainer User", :email=>"Trainer@xerofit.com", :password=>"trainer123", :role=>"trainer", :enabled=>true)
User.create(:first_name=>"Normal User", :email=>"User@xerofit.com", :password=>"normaluser123", :role=>"normaluser", :enabled=>true)
