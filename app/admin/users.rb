ActiveAdmin.register User do
	
	#config.batch_actions = true
	#actions :index, :show, :destroy

	filter :email
	filter :firstname, :label => "First Name"
	filter :lastname, :label => "Last Name"
	filter :location
	filter :created_at
	filter :updated_at

	scope :all, :default => true
	scope :confirmed
	scope :unconfirmed
	scope :male
	scope :female

	index :download_links => [:csv] do |users|
		selectable_column
		id_column
		column :email
		column "First Name", :firstname, :sortable => false
		column "Last Name", :lastname, :sortable => false
		column :gender
		column :location
		column :created_at
		column :updated_at
		column :confirmed_at
		column "Providers" do |user|
			user.services.map { |service| service.provider }
		end

		default_actions
	end

	show do |user|
		attributes_table do
			row :id
			row :email
			row :firstname
			row :lastname
			row :location
			row :gender
			row :haslocalpw
			row :created_at
			row :updated_at
			row :sign_in_count
			row :current_sign_in_at
			row :last_sign_in_at
			row :current_sign_in_ip
			row :last_sign_in_ip
			row :confirmed_at
			row :confirmation_sent_at
			row :unconfirmed_email
			row :reset_password_sent_at			
		end
		active_admin_comments
	end

	form do |f|
		f.inputs "User Details" do
			f.input :email
			f.input :firstname, :label => "First Name"
			f.input :lastname, :label => "Last Name"
			#f.input :haslocalpw, :label => "Has Local Password"
			f.input :password
			f.input :password_confirmation
		end
		f.inputs "Extra Info" do
			f.input :location
			f.input :gender, :as => :select, :collection => ["Male", "Female"]
		end
		f.buttons
	end

	csv do
		column :id
		column :email
		column("First Name") { |user| user.firstname }
		column("Last Name") { |user| user.lastname }
		column :gender
		column :location
		column :created_at
		column :confirmed_at
	end
end
