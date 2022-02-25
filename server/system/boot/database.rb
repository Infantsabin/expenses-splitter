# frozen_string_literal: true
curr_dir = Pathname.new(File.expand_path(__dir__))
Dir.chdir(curr_dir.join('../../..')) do
	DB = Sequel.connect(ENV.delete('DATABASE_URL'))
end