# frozen_string_literal: true
require_relative '../helper/basic_helper'

class Expense < Sequel::Model
	many_to_one		:creator,
					:key	=> :created_by_id,
					:class  => :User

	many_to_one		:paid_by,
					:key	=> :paid_by_id,
					:class  => :User

	one_to_many		:user_expenses,
					:key	=> :expense_id,
					:class  => :UserExpense

	def self.create_expense data
		expense = self.create(
			name: data[:name],
			description: data[:description],
			date: data[:date],
			total: data[:total].to_f.round(2),
			created_by_id: data[:created_by_id].to_i,
			paid_by_id: data[:paid_by_id].to_i
		)

		if data[:users] and !data[:users].empty?
			amount = data[:total].to_f.round(2) / (data[:users].count + 1)
			User.where(id: data[:users]).each do |user|
				expense.add_user_expense({
					amount: amount.to_f.round(2),
					user_id: user.id,
					paid: false,
					})
			end
		end

		payer_amount = data[:total].to_f.round(2) - expense.user_expenses_dataset.sum(:amount).to_f.round(2)
		expense.add_user_expense(amount: payer_amount,
					user_id: data[:created_by_id],
					paid: true)
	end

	def self.get_user_expenses cur_user
		cur_user_id = cur_user.id

		Expense.where(:created_by_id => cur_user_id).collect do |expense|
			owe_amount = 0.00
			owe_amount = expense.user_expenses_dataset.where{user_id !~ cur_user_id}.sum(:amount).to_f.round(2) if expense[:paid_by_id] == cur_user_id
			user_expense = expense.user_expenses_dataset.where(:user_id => cur_user_id).first
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
				amount: user_expense[:amount].to_f.round(2),
				owe_amount: owe_amount,
				paid: user_expense[:paid],
			}
		end		
	end
end