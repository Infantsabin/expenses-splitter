Sequel.migration do
	change do
		create_table(:expenses) do
			primary_key :id
			String   :name,       		 null: false
			String   :description,       null: false
			Date     :date,              default: Sequel::CURRENT_TIMESTAMP
            BigDecimal :total
            foreign_key :created_by_id,  :users, :key => :id, :on_delete	=> :cascade
            foreign_key :paid_by_id,     :users, :key => :id, :on_delete	=> :cascade
			DateTime :created_at,        default: Sequel::CURRENT_TIMESTAMP
			DateTime :updated_at,        default: Sequel::CURRENT_TIMESTAMP
			DateTime :deleted_at,        default: nil
		end
	end
end