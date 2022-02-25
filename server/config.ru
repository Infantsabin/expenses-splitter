# frozen_string_literal: true

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

builder = Rack::Builder.new do
	use Rack::Attack
	use Rack::Cors do
		allow do
			origins '*', 'localhost'
			resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
		end
	end

	AutoReloader.activate reloadable_paths: [ '.' ]

	run lambda { |env|
		AutoReloader.reload! do
			require_relative 'system/boot'
			require_relative 'app'
			App.call env
		end
	}
end

run builder.to_app