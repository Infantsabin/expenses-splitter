App.route('api/dashboard') do |r|
    @user = User.where(token: @token).first
    raise "Invalid Login Token.." unless @user

    r.get do
        ret = @user.dashboard_details

        {
            values: ret,
            success: true
        }
    end
end