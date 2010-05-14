class MediaSearch
  attr_accessor :title
  attr_accessor :type
  
  def initialize(params)
    params.each{|key, value| send("#{key}=",value) }
  end
  
  def to_hash
    {:title => self.title, :type => self.type}
  end
end
