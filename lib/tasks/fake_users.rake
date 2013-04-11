namespace :db do
	namespace :development do
		desc "Create user records in the development database."

		task :fake_user_data => :environment do
			require 'faker'

			@genders = ["Male", "Female"]

			def randomDate(params={})
				years_back = params[:year_range] || 5
				latest_year = params[:year_latest] || 0
				year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
				month = (rand * 12).ceil
				day = (rand * 31).ceil
				series = [date = Time.local(year, month, day)]
				if params[:series]
					params[:series].each do |some_time_after|
						series << series.last + (rand * some_time_after).ceil
					end
					return series
				end
				date
			end

			100.times do

				randomDate = randomDate(:year_range => 2, :year_latest => 0)

				gender = @genders.sample
				location = Faker::Address.city + ", " + Faker::Address.state

				u = User.new(
					:firstname => Faker::Name.first_name,
					:lastname => Faker::Name.last_name,
					:email => Faker::Internet.email,
					:password => "greatpasswordyeah",
					:password_confirmation => "greatpasswordyeah",
					:gender => gender,
					:location => location
				)

				u.skip_confirmation!
				u.save!

				if rand(2) == 1
					u.confirm!
				end

			end

		end
	end
end