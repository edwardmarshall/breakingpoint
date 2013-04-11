class PageController < ApplicationController
	def index
	end

	def show
	end

	def reminder
	end

	def congratulations
	end

	def vip
		authenticate_user!
	end
end