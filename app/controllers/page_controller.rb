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
		authenticate_user!

		@body_class = "vip"

		# Meet 'n' Greet
		event1 = Time.new(2013, 04, 23, 12, 30, 0, "-06:00") # Time in MDT

		# Pre-Show
		event2 = Time.new(2013, 04, 25, 11, 30, 0, "-06:00") # Time in MDT

		# Breaking Point 2
		event3 = Time.new(2013, 04, 25, 13, 0, 0, "-06:00") # Time in MDT

		if Time.now >= event3
			@event = "bp2"
		elsif Time.now >= event2
			@event = "pre-show"
		elsif Time.now >= event1
			@event = "meet-n-greet"
		else
			@event = "default"
		end
	end
end