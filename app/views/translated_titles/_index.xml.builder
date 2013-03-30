if !translated_titles.empty?
  for translated_title in translated_titles
    hash = {:id => translated_title.id}
    lang = translated_title.language
    hash['lang'] = lang.code if !lang.nil?
    xml.translation(hash) do
      xml.title(translated_title.title, :type => 'string')
    end
  end
end