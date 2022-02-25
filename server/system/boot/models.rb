# frozen_string_literal: true

# * DB is set in 'database.rb' which has to be loaded before this file

# Whether association metadata should be cached in the association reflection.
# If not cached, it will be computed on demand.
# In general you only want to set this to false when using code reloading.
# When using code reloading, setting this will make sure that if an associated class is removed or modified,
# this class will not have a reference to the previous class.
Sequel::Model.cache_associations = false

# The validation_helpers plugin contains validate_* methods designed to be called inside Model#validate to perform validations.
Sequel::Model.plugin(:auto_validations)

# The validation_helpers plugin contains validate_* methods designed to be called inside Model#validate to perform validations.
Sequel::Model.plugin(:validation_helpers)

# Creates hooks for automatically setting create and update timestamps.
Sequel::Model.plugin(:timestamps)

# Use UTC time zone for saving time inside database.
Sequel.default_timezone = :utc

# Freeze all descendent classes. This also finalizes the associations for those classes before freezing.
unless ENV['RACK_ENV'] == 'development'
	Sequel::Model.freeze_descendents
	DB.freeze
end


app_path = Pathname.new(File.expand_path(__dir__)).join('../..')
Dir[app_path.join('models/*.rb')].each { |f| require f }