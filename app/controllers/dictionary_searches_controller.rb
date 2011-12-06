class DictionarySearchesController < AclController
  def initialize
    super
    @guest_perms += ['dictionary_searches/new', 'dictionary_searches/create']
  end
  
  # GET /dictionary_searches
  # GET /dictionary_searches.xml
  def index #for displaying results
    options = session[:search_options]
    if options.nil?
      redirect_to new_dictionary_search_url
    else
      if options[:type]=='browse'
        @language = ComplexScripts::Language.find(options[:language])
        @letters = Letter.letters_by_language(@language.id)
        respond_to do |format|
          format.html { render :partial => 'browse_panel' }
          format.xml  { render :xml => @letters.to_xml }
        end
      else
        options.delete(:type)
        @word_pages, @words = paginate(:words, options)
        #@words = Word.find(:all, :conditions => @conditions_array)    
        respond_to do |format|
          format.html { render :partial => 'index' }
          format.xml  { render :xml => @words.to_xml }
        end
      end
    end
  end

  # GET /dictionary_searches/1
  # GET /dictionary_searches/1.xml
  def show #for browsing letters
    letter_id = params[:id]
    @language = ComplexScripts::Language.find(params[:language_id])
    
    @word_pages, @words = paginate(:words, :conditions => {:letter_id => letter_id, :language_id => @language}, :order => '`order`')
    respond_to do |format|
      format.html { render :partial => 'index' if request.xhr? }
      format.xml  { render :xml => @words.to_xml }
    end
  end

  # GET /dictionary_searches/new
  def new #main dictionary search page
    @current_tab_id = :dictionary_search
    @available_languages = Word.available_languages
    @head_term_languages = Word.head_term_languages
    @onload = "document.getElementById('browse').disabled=true;"
    @dictionary_search = DictionarySearch.new({:title => '', :language => 0, :type => 'simple'})
  end

  # GET /dictionary_searches/1;edit
  def edit #NOT USED
    redirect_to new_dictionary_search_url
  end

  # POST /searches
  # POST /searches.xml
  def create # actually creates the new search query
    search = DictionarySearch.new(params[:dictionary_search])
    term = search.title
    search_language = search.language.to_i 
    if search_language != 0
      language = ComplexScripts::Language.find(search.language)
      full_text_supported = (language.code=='en')
    else
      full_text_supported = false
    end
    
    options = Hash.new
    options[:type] = search.type
    if search.type == 'browse'
      options[:language] = search.language
    else
      conditions_string = Util.search_condition_string(search.type, 'title', full_text_supported)
      term = "%#{term}%" if !full_text_supported
      if search_language == 0
        conditions_array = [conditions_string, term]
      else
        conditions_array = [conditions_string + " AND language_id = ?", term, search.language]
      end
      options[:conditions] = conditions_array
    end
    session[:search_options] = options
    redirect_to dictionary_searches_url
  end

  # PUT /dictionary_searches/1
  # PUT /dictionary_searches/1.xml
  def update #NOT USED
    redirect_to new_dictionary_search_url
  end

  # DELETE /dictionary_searches/1
  # DELETE /dictionary_searches/1.xml
  def destroy #NOT USED
    redirect_to new_dictionary_search_url
  end
end
