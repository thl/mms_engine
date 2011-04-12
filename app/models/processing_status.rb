class ProcessingStatus < PassiveRecord::Base
  schema :title => String
  create :title => 'Thumb Regeneration' # id = 1
end