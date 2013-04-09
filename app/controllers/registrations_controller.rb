class RegistrationsController < Devise::RegistrationsController
	def update
		@user = User.find(current_user.id)
		if @user.haslocalpw
			super
		else
			# this account has been created with a random pw / the user is signed in via an omniauth service
			# if the user does not want to set a password we remove the params to prevent a validation error
			if params[:user][:password].blank?
				params[:user].delete(:password)
				params[:user].delete(:password_confirmation)
			else
				# if the user wants to set a password we set haslocalpw for the future
				params[:user][:haslocalpw] = true
			end

			# this is copied over from the original devise controller, instead of update_with_password we use update_attributes
			if @user.update_attributes(params[:user])
				set_flash_message :notice, :updated
				# Sign in the user bypassing validation in case his password changed
				sign_in @user, :bypass => true
				redirect_to after_update_path_for(@user)
			else
				render :edit
			end
		end
	end
end