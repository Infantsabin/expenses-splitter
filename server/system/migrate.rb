# frozen_string_literal: true

begin
	require_relative '../../.env.rb'
rescue LoadError => e
	puts e.message
end

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

boot_path = Pathname.new(File.expand_path(__dir__)).join('boot')
Dir[boot_path.join('logger.rb'), boot_path.join('database.rb')].each { |f| require f }