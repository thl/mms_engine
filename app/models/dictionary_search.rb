class DictionarySearch
  attr_accessor :title, :language, :type
  
  def initialize(params)
    params.each{|key, value| send("#{key}=",value) }
  end
end