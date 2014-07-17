#encoding: utf-8
ActiveAdmin.register User do
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
    f.inputs "Dane użytkownika" do
      f.input :role
      f.input :fullname
      f.input :email
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

