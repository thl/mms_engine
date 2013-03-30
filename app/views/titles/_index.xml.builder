if !titles.empty?
  for title in titles
    lang = title.language
    hash = {:id => title.id}
    hash['lang'] = lang.code if !lang.nil?
    xml.title(hash) do
      xml.title(title.title, :type => 'string')
      xml << render(:partial => 'translated_titles/index', :locals => {:translated_titles => title.translated_titles})        
    end
  end
end