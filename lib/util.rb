module Util
  MARGIN = "&nbsp;" * 5
  MAX_FONT_SIZE = 5
  MIN_FONT_SIZE = 1  

  def self.interrogation_set(length)
    "(?#{', ?' * (length - 1)})"
  end
  
  def self.search_condition_string(type, field_name, full_text_supported)
    case type
    when 'simple'
      if full_text_supported
        conditions_string = "MATCH(#{field_name}) AGAINST(?)"
      else
        conditions_string = "#{field_name} LIKE ?"
      end
    when 'boolean'
      if full_text_supported
        conditions_string = "MATCH(#{field_name}) AGAINST(? IN BOOLEAN MODE)"
      else
        conditions_string = "#{field_name} LIKE ?"
      end          
    else
      conditions_string = "#{field_name} = ?"
    end
  end
end