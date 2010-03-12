require 'test_helper'

class TranslatedTitleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: translated_titles
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  title_id    :integer(4)      not null
#  language_id :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

