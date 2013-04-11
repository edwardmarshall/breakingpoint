ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do

        column do
            panel "Recent Signups" do
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

        column do
            panel "Last Logins" do
                table_for User.where('current_sign_in_at is not null').order('current_sign_in_at desc').limit(30).each do |user|
                    column(:current_sign_in_at)
                    column(:last_sign_in_at)
                    column("First Name", :firstname)
                    column("Last Name", :lastname)
                    column(:email)
                end
            end
        end

    end
  end # content
end
