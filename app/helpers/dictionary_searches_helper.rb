module DictionarySearchesHelper
  def javascript_searching(div)
    javascript_load(div, 'Searching...')
  end
  
  def javascript_load(div, message)
    "document.getElementById(\'#{div}\').innerHTML = \'<p><em>#{message}</em></p>\';"
  end  
end
