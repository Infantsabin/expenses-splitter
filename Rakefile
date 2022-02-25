# frozen_string_literal: true

require_relative 'server/system/migrate'

migrate = lambda do |version|
	Sequel.extension :migration
	DB.loggers << Logger.new($stdout) if DB.loggers.empty?
	Sequel::Migrator.apply(DB, 'db/migrate', version)
end

namespace :db do
	desc 'Migrate the database.'
	task :migrate do
		migrate.call(nil)
	end

	desc 'Rolling back latest migration.'
	task :rollback do |_, _args|
		current_version = DB.fetch('SELECT * FROM schema_info').first[:version]
		migrate.call(current_version - 1)
	end

	desc 'Seed database with test data.'
	task :seed do
		sh %(bundle exec ruby db/seeds.rb)
	end
end