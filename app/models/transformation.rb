class Transformation < ActiveRecord::Base
  belongs_to :renderer, :class_name => 'FileRenderer'
  has_many :typescripts
  
  def full_path
    renderer.path.sub(/:transformation/, path)
  end
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: transformations
#
#  id          :integer(4)      not null, primary key
#  renderer_id :integer(4)      not null
#  path        :string(100)     not null
#  title       :string(20)      not null