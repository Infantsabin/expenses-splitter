case ENV['RACK_ENV'] ||= 'development'
when 'test'
	ENV['DATABASE_URL'] ||= "mysql:///my_app_test?user=my_app"
when 'production'
	ENV['DATABASE_URL'] ||= "postgres:///my_app_production?user=my_app"
else
	ENV['DATABASE_URL'] ||= "sqlite://_database/expense_splitter.sqlite"
end
