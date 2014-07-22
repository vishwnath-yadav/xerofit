ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
       column do
         panel "Latest Registered" do
           table_for User.where("enabled = ?",true).order("created_at desc").limit(5) do
             column("Fullname")          {|user| user.fullname }
             column("Email")          {|user| user.email }
           end
         end
       end

       column do
        panel "Statistics" do
          ul do
            li "Trainers: "+User.where("enabled = ? and role =? ",true, "trainer").size.to_s
            li "Normal Users: "+User.where("enabled = ? and role =? ",true, "normaluser").size.to_s
            li "Libraries: "+Library.all.size.to_s
            li "Workouts: "+Workout.where(state: "completed").size.to_s
          end
        end
       end
    end
  end # content
end
