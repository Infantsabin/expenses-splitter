# frozen_string_literal: true

require_relative 'system/boot'
require 'json'

class App < Roda
	plugin :multi_route
	plugin :json
	plugin :indifferent_params
	plugin :all_verbs
	plugin :hooks
	plugin :environments
	plugin :render, escape: true, layout: './layout'
	plugin :public, root: Pathname.new(__dir__).join('../public')

	configure :development, :production do
		plugin :enhanced_logger
	end

	plugin :not_found do
		'not found'
	end

	app_root = Pathname.new(__dir__).join('..')

	plugin :error_handler do |e|
		e.backtrace.each_with_index do |trace_path, i|
			@first_error_line = trace_path.gsub(app_root.to_s, '') if i == 0
			break if (i > 5)
			if trace_path.include?(app_root.to_s)
				LOGGER.error { e.message }
			end
		end

		if request.xhr?
			{ success: false, error: e.message }.to_json
		else
			@page_title = "Internal Server Error"
			@error_message = e.message if ENV['RACK_ENV'] == 'development'
			# view :error
		end
	end

	Dir[app_root.join('server/routes/*.rb')].each { |f| require f }


	before do
		body = request.body.read
		request.body.rewind
		@data = JSON.parse(body, symbolize_names: true) rescue {}

		@token =  params["token"] || @data[:token] || nil
	end

	route do |r|
		r.public
		r.multi_route

		r.get 'favicon.ico' do
			r.halt 204
		end

		r.root do
			@users = User.first_fifty

			# p @data
			# p @token

			# view :index
		end

		r.get 'error' do
			raise 'error raised from here'
		end
    end

end