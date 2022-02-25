# frozen_string_literal: true
require_relative '../helper/basic_helper'

class User < Sequel::Model
	plugin :secure_password

	one_to_many		:expenses,
					:key	=> :created_by_id,
					:class  => :Expense

	one_to_many		:paid_expenses,
					:key	=> :paid_by_id,
					:class  => :Expense

	def validate
		super
		validates_unique(:email,:mobile, :message=>'already exists'){ |ds| ds.where(:deleted_at => nil) }
	end

	def self.verify data
		user = User.where(email: data[:email]).or(mobile: data[:email]).first
		raise "Invalid User" unless user

		decrypted_password = Helper.decrypt_password(user.password_digest)
		raise "Incorrect Password" unless decrypted_password == data[:password_digest]

		login_token = Helper.secure_token
		user.update(token: login_token)

		return user.values
	end

	def self.create_user data
		data[:password_digest] = Helper.secure_password data[:password_digest]
		User.create(data)
	end

	def self.get_users_query cur_user
		User.exclude(:id => cur_user.id).all.collect do |user|
			{
				id: user.id,
				name: user.name,
			}
		end 
	end

	def self.get_all_users
		User.all.collect do |user|
			{
				id: user.id,
				name: user.name,
			}
		end 
	end

	def dashboard_details

		cur_user_id = self.id
		owe_amount = total_balance = due_amount = nil
		
		recent_sharings = self.expenses_dataset.order(Sequel.desc(Sequel[:expenses][:created_at])).limit(5).collect do |expense|
			shared_with = expense.user_expenses_dataset.where{user_id !~ expense[:paid_by_id]}.collect do |user_expense|
				user_expense.user.name
			end.join(',')

			{
				id: expense[:id],
				name: expense[:name],
				description: expense[:description],
				date: expense[:date],
				total: expense[:total].to_f.round(2),
				created_by_id: expense[:created_by_id],
				paid_by_id: expense[:paid_by_id],
				created_by: expense.creator.name,
				paid_by: expense.paid_by.name,
				shared_with: shared_with
			}
		end 

		owe_amount = UserExpense.where(:user_id => cur_user_id, :paid => false).sum(:amount).to_f.round(2)
		due_amount = UserExpense.where{user_id !~ cur_user_id}.where(:paid => false).sum(:amount).to_f.round(2)

		# self.paid_expenses_dataset.sum(:total).to_f.round(2) 
		total_balance = (due_amount - owe_amount)
		{
			name: self.name,
			email: self.email,
			recent_sharings: recent_sharings,
			owe_amount: owe_amount || 0.00,
			due_amount: due_amount || 0.00,
			total_balance: total_balance || 0.00,
		}
	end
end