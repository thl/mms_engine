require 'test_helper'

class CitationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: citations
#
#  id             :integer(4)      not null, primary key
#  reference_id   :integer(4)      not null
#  reference_type :string(255)     not null
#  medium_id      :integer(4)
#  page_number    :integer(4)
#  page_side      :string(5)
#  line_number    :integer(4)
#  note           :text
#  created_at     :datetime
#  updated_at     :datetime
#

