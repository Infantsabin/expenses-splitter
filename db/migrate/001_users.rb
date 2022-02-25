Sequel.migration do
	change do
		create_table(:users) do
			primary_key :id
			String   :name,       		 null: false
			String   :email,             null: false, unique: true
			String   :mobile,  			 null: false, unique: true
			String   :password_digest,   null: false
			String   :token,             default: nil
			DateTime :created_at,        default: Sequel::CURRENT_TIMESTAMP
			DateTime :updated_at,        default: Sequel::CURRENT_TIMESTAMP
			DateTime :deleted_at,        default: nil
		end
	end
end