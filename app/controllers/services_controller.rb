class ServicesController < Devise::OmniauthCallbacksController
	skip_before_filter :verify_authenticity_token, :only => [:steam]

	def index
		@services = current_user.services.all
	end

	def destroy
		@service = current_user.services.find(params[:id])
		@service.destroy

		redirect_to services_path
	end

	def service_login(provider, uid, email, name, firstname, lastname, location, gender)
		# continue only if the provider and uid exist
		if uid != '' and provider != ''

			# Do not allow a double sign in and no sign ups can happen if signed in
			if !user_signed_in?
				# user is NOT signed in
				# check if this user is already registered with this email address; get out if no email
				if email != ''
					# search for existing service
					existingservice = Service.find_by_provider_and_uid(provider, uid)
					if existingservice
						# If service exists, find the User who owns the service and log them in
						existinguser = User.find_by_id(existingservice.user_id)

						flash[:notice] = 'Signed in successfully via ' + provider.capitalize
						sign_in_and_redirect(:user, existinguser)
					else
						# No matching service found
						# See if a User exists with the same email address
						existinguser = User.find_by_email(email)
						if existinguser
							# Add service to existing User
							existinguser.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)

							# Update record with info
							existinguser.firstname = firstname
							existinguser.lastname = lastname
							existinguser.gender = gender
							existinguser.location = location
							existinguser.save!

							flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinguser.email + '. Signed in successfully!'
							sign_in_and_redirect(:user, existinguser)
						else
							# Create a new User and add Service to User
							# Shorten name if needed for validation
							name = name[0,39] if name.length > 39	# otherwise our user validation will hit us
							firstname = firstname[0,39] if firstname.length > 39	# otherwise our user validation will hit us
							lastname = lastname[0,39] if lastname.length > 39	# otherwise our user validation will hit us

							# new user, set email, a random password and take the name from the authentication service
							user = User.new :email => email, :password => SecureRandom.hex(10), :firstname => firstname, :lastname => lastname, :location => location, :gender => gender, :haslocalpw => false

							# add this authentication service to our new user
							user.services.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)

							# do not send confirmation email, we directly save and confirm the new record
							user.skip_confirmation!
							user.save!
							# 	user.confirm!

							# Send the user a second email          
            				UserMailer.congratulations_email(user).deliver

							# flash and sign in
							flash[:notice] = 'Your account has been created via ' + provider.capitalize + '.'
							sign_in_and_redirect(:user, user)
						end
					end
				else
					existingservice = Service.find_by_provider_and_uid(provider, uid)
					if existingservice
						existinguser = User.find_by_id(existingservice.user_id)
						flash[:notice] = 'Signed in successfully via ' + provider.capitalize
						sign_in_and_redirect(:user, existinguser)
					else
						# Service not yet added, and can not be added because no email is returned via service
						flash[:error] = provider.capitalize + ' can not be used to sign-up as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + provider.capitalize + ' from your profile.'
						redirect_to new_user_session_path
					end
				end
			else
				# the user is currently signed in
				# check if the service is already linked to his/her account, if not, add it
				auth = Service.find_by_provider_and_uid(provider, uid)

				if !auth
					current_user.firstname = firstname
					current_user.lastname = lastname
					current_user.gender = gender
					current_user.location = location
					current_user.save!

					current_user.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
					flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
					redirect_to root_path
				else
					if current_user.id == auth.user_id
						flash[:alert] = provider.capitalize + ' is already linked to your account.'
					else
						flash[:alert] = provider.capitalize + ' is already linked to another account. Please sign out and login via' + provider.capitalize + '.'
					end
					redirect_to root_path
				end
			end
		else
			# UID or Provider was blank in return.
			flash[:error] = provider.capitalize + ' returned invalid data for the user id.'
			redirect_to new_user_session_path
		end
	end

	def facebook
		# RENDER FOR TESTING JSON REQUEST
		# render :text => request.env["omniauth.auth"].to_json

		params[:action] ? service_route = params[:action] : service_route = 'no service (invalid callback)'

		omniauth = request.env['omniauth.auth']
		if omniauth and params[:action]

			# Get facebook params.
			# Provider, UID, Name (full), Email
			omniauth['provider'] ? provider = omniauth['provider'] : provider = ''
			omniauth['uid'] ? uid = omniauth['uid'] : uid = ''
			omniauth['info']['email'] ? email = omniauth['info']['email'] : email = ''
			omniauth['info']['name'] ? name = omniauth['info']['name'] : name = ''
			omniauth['info']['first_name'] ? firstname = omniauth['info']['first_name'].capitalize : firstname = ''
			omniauth['info']['last_name'] ? lastname = omniauth['info']['last_name'].capitalize : lastname = ''

			omniauth['info']['location'] ? location = omniauth['info']['location'] : location = ''
			omniauth['extra']['raw_info']['gender'] ? gender = omniauth['extra']['raw_info']['gender'].capitalize : gender = ''

			service_login(provider, uid, email, name, firstname, lastname, location, gender)

		else
			# Error if for some reason we didn't get omniauth or params[:service]
			flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '.'
			redirect_to new_user_session_path
		end
	end

	# def twitter
	# 	params[:action] ? service_route = params[:action] : service_route = 'no service (invalid callback)'

	# 	omniauth = request.env['omniauth.auth']
	# 	if omniauth and params[:action]

	# 		# Get facebook params.
	# 		# Provider, UID, Name (full), Email
	# 		omniauth['provider'] ? provider = omniauth['provider'] : provider = ''
	# 		omniauth['uid'] ? uid = omniauth['uid'] : uid = ''
	# 		omniauth['info']['email'] ? email = omniauth['info']['email'] : email = ''
	# 		omniauth['info']['name'] ? name = omniauth['info']['name'] : name = ''

	# 		service_login(provider, uid, email, name)

	# 	else
	# 		# Error if for some reason we didn't get omniauth or params[:service]
	# 		flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '.'
	# 		redirect_to new_user_session_path
	# 	end
	# end

	# def browser_id
	# 	#render :text => request.env["omniauth.auth"].to_json

	# 	params[:action] ? service_route = params[:action] : service_route = 'no service (invalid callback)'

	# 	omniauth = request.env['omniauth.auth']
	# 	if omniauth and params[:action]

	# 		# Get facebook params.
	# 		# Provider, UID, Name (full), Email
	# 		omniauth['provider'] ? provider = omniauth['provider'] : provider = ''
	# 		omniauth['uid'] ? uid = omniauth['uid'] : uid = ''
	# 		omniauth['info']['email'] ? email = omniauth['info']['email'] : email = ''
	# 		omniauth['info']['name'] ? name = omniauth['info']['name'] : name = ''

	# 		service_login(provider, uid, email, name)

	# 	else
	# 		# Error if for some reason we didn't get omniauth or params[:service]
	# 		flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '.'
	# 		redirect_to new_user_session_path
	# 	end
	# end

end