# == Schema Information
#
# Table name: transformations
#
#  id          :integer          not null, primary key
#  renderer_id :integer          not null
#  title       :string(20)       not null
#  path        :string(100)      not null
#

class Transformation < ActiveRecord::Base
  belongs_to :renderer, :class_name => 'FileRenderer'
  has_many :typescripts, dependent: :nullify
  
  def full_path
    renderer.path.sub(/:transformation/, path)
  end
end