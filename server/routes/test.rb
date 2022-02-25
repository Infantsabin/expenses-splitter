# frozen_string_literal: true
App.route do |r|
	r.root do
		"this is from route <code>/api</code>. <br> Try <a href='/api/user'>/api/user</a>"
	end
end