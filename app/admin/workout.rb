ActiveAdmin.register Workout do

  menu :label => "Uncut Workouts", :priority => 3

  actions :all, :except => [:new, :delete]

  config.clear_action_items!

   action_item :only => :show do
      link_to('Edit Workout', :controller => "workouts", :action => "edit")
  end

  index do
    selectable_column
    column "Name", :title
    column "Subtitle", :subtitle
    #column "Category", :category
    column "Description", :description
    column "Status", :status
    column "Updated At", :updated_at
    actions
  end
  filter :title
  filter :status
  filter :subtitle
  filter :created_at, :label => "Created"

  form :partial => "form"

  controller do
    def update
      if !params[:reason].blank? && workout.status != params[:workout][:status]
        workout = Workout.find(params[:id]) 
        Emailer.send_lib_status_change_mail(workout.user.email, params[:reason], workout.title, params[:workout][:status], "Workout").deliver
      end
      super
    end 

    def permitted_params
      params.permit!
    end
  end
  
end
