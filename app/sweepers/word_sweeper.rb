class WordSweeper < ActiveRecord::Observer
  observe Word
  
  def before_save(w)
    if w.language_id_changed?
      expire_cache_language(w.language_id_was)
      expire_cache_language(w.language_id)
    end
  end
  
  def before_destroy(w)
    expire_cache_language(w.language_id)
  end
  
  def expire_cache_language(l)
    Rails.cache.delete("letters/by_language/#{l}")
    Rails.cache.delete('words/available_languages')
    Rails.cache.delete('words/head_term_languages')
  end
end