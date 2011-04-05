class Rotation < PassiveRecord::Base
  schema :title => String, :id => Integer, :order => Integer
  create :id => 270, :title => 'Counter-clockwise', :order => 1
  create :id => 0,   :title => 'Original', :order => 2
  create :id => 90,  :title => 'Clockwise', :order => 3
  create :id => 180, :title => 'Upside down', :order => 4
  
  def self.all
    Rotation.find(:all).sort{|a, b| a.order <=> b.order }
  end  
end