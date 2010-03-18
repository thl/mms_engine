require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: statuses
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  description :text
#  order       :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

