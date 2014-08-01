ActiveAdmin.register Library do
  actions :all, :except => [:new, :delete]

  config.clear_action_items!

   action_item :only => :show do
      link_to('Edit Library', :controller => "libraries", :action => "edit")
  end

  index do
    selectable_column
    column "Title", :title
    column "Directions", :directions
    column "Category", :category
    column "Difficulty", :difficulty
    column "Status", :status
    column "Updated At", :updated_at
    actions
  end
  filter :title
  filter :status
  filter :difficulty
  filter :created_at, :label => "Created"

  form :partial => "form"

  controller do
    def update
      lib = Library.find(params[:id])
      if !params[:reason].blank? && lib.status != params[:library][:status] 
        Emailer.send_lib_status_change_mail(lib.user.email, params[:reason], lib.title, params[:library][:status], "Library").deliver
      end
      super
    end 

    def permitted_params
      params.permit!
    end
  end
  
end
