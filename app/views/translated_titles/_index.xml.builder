if !translated_titles.empty?
  for translated_title in translated_titles
    xml.translation do
      lang = translated_title.language
      xml.lang_code(lang.code) if !lang.nil?
      xml.title(translated_title.title)
    end
  end
end