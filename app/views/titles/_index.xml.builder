if !titles.empty?
  for title in titles
    lang = title.language
    xml.title do
      xml.lang_code(lang.code) if !lang.nil?
      xml.title(title.title)
      xml << render(:partial => 'translated_titles/index', :locals => {:translated_titles => title.translated_titles})        
    end
  end
end