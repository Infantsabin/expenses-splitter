# frozen_string_literal: true
require_relative '../helper/basic_helper'

class UserExpense < Sequel::Model
	many_to_one		:user,
					:key	=> :user_id,
					:class  => :User

	many_to_one		:expense,
					:key	=> :expense_id,
					:class  => :Expense

	def self.get_user_sharing_expenses cur_user
		self.where(:user_id => cur_user.id).collect do |user_expense|
			{
				name: user_expense.expense.name,
				description: user_expense.expense.description,
				date: user_expense.expense.date,
				total: user_expense.expense.total.to_f.round(2),
				created_by_id: user_expense.expense.created_by_id,
				paid_by_id: user_expense.expense.paid_by_id,
				created_by: user_expense.expense.creator.name,
				paid_by: user_expense.expense.paid_by.name,
				amount: user_expense[:amount].to_f.round(2),
				paid: user_expense[:paid],
			} if user_expense.expense.paid_by_id != user_expense[:user_id]
		end.compact	
	end
end