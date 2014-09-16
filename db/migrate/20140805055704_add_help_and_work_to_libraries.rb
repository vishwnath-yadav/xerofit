class AddHelpAndWorkToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :help, :string
    add_column :libraries, :work, :string
  end
end
