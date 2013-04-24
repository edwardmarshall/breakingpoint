class PageController < ApplicationController

	def index
	end

	def show
	end

	def reminder
		@body_class = "reminder"
	end

	def congratulations
		authenticate_user!
		
		@body_class = "congratulations"
	end

	def vip
		redirect_to root_url
	end
end