#encoding: utf-8
ActiveAdmin.register User do

menu :label => "Users", :priority => 1

index do
    selectable_column
    column "Role", :role
    column "Fullname", :fullname
    column "Email", :email
    column "Rejestracja", :created_at
    column "Enabled", :enabled
    actions
  end
  filter :fullname
  filter :email
  filter :role
  filter :created_at, :label => "Registers"

  form do |f|
    f.inputs "Update User" do
      f.input :role, :prompt => 'Choose Role', :required => true, :label => "Role", as: :select, collection: User::ROLESFORADMIN, :input_html => { :class => 'select_box'} 
      f.input :fullname
      f.input :email
      f.input :password
      f.input :enabled
    end
     f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end

