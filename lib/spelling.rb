module Spelling
  require 'net/https'
  require 'uri'
  require 'rexml/document'
  
  ASPELL_WORD_DATA_REGEX = Regexp.new(/\&\s\w+\s\d+\s\d+(.*)$/)
  #ASPELL_PATH = "/opt/local/bin/aspell"
  ASPELL_PATH = "/usr/bin/aspell"
  
  def check_spelling(spell_check_text, command, lang)
    xml_response_values = Array.new
    spell_check_text = spell_check_text.join(' ') if command == 'checkWords'
    spell_check_response = `echo "#{spell_check_text}" | #{ASPELL_PATH} -a -l #{lang}`
    if (spell_check_response != '')
      spelling_errors = spell_check_response.split("\n").slice(1..-1)
      if (command == 'checkWords')
        for error in spelling_errors
          error.strip!
          if (match_data = error.match(ASPELL_WORD_DATA_REGEX))
            arr = match_data[0].split(' ')
            xml_response_values << arr[1]
          end 
        end 
      elsif (command == 'getSuggestions') 
        for error in spelling_errors 
          error.strip! 
          if (match_data = error.match(ASPELL_WORD_DATA_REGEX)) 
            xml_response_values << error.split(',')[1..-1].collect(&:strip!)
            xml_response_values = xml_response_values.first
          end
        end 
      end 
    end 
    return xml_response_values
  end 
end