class ConfirmationsController < Devise::ConfirmationsController

	def confirm!
		super
		# Send email here
	end

	private

	def after_confirmation_path_for(resource_name, resource)
		congratulations_path
	end

end