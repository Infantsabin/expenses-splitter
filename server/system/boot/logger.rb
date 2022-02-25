require 'logger'

LOGGER = Logger.new(STDOUT)

case ENV['RACK_ENV'] ||= 'development'
when 'production'
	LOGGER.level = Logger::ERROR
else
	LOGGER.level = Logger::INFO
end
