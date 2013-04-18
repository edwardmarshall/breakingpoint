class PageController < ApplicationController

	def index
	end

	def show
	end

	def reminder
		@body_class = "reminder"
	end

	def congratulations
		@body_class = "congratulations"
	end

	def vip
		authenticate_user!

		@body_class = "vip"
		@user = current_user
	end
end