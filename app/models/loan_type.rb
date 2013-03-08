# == Schema Information
#
# Table name: loan_types
#
#  id    :integer          not null, primary key
#  title :string(15)       not null
#

class LoanType < ActiveRecord::Base
  has_many :words
end