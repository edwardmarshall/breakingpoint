ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do

        column do
            panel "Recent Users" do
                table_for User.order('id desc').limit(30).each do |user|
                    column("Confirmed Email")     {|user| status_tag(user.state) }
                    column(:email)      {|user| link_to(user.email, admin_user_path(user)) }
                    column("First Name", :firstname)
                    column("Last Name", :lastname)
                    column(:gender)
                    column(:location)
                end
            end
        end

    end
  end # content
end
