# == Schema Info
# Schema version: 20100310060934
#
# Table name: loan_types
#
#  id    :integer(4)      not null, primary key
#  title :string(15)      not null

class LoanType < ActiveRecord::Base
  has_many :words
end
