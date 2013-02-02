# DictionaryImportation
#require 'config/environment'

module DictionaryImportation
  COLUMN=0
  ROW=1
  CALCULATE=2
  
  def self.next_available(array)
    i=0
    i+=1 while array.include?(i)
    i
  end
  
  def self.clean_field(value)
    return nil if value.nil?
    value.strip!
    return nil if value.blank?
    return value
  end
  
  # order_options include :letter_order, :word_order. Neither is expected if sorting
  # is going to be handled by other means.
  # cols is hash whose key is field names (:word, :definition, :grammatical_class,
  # :letter expected) and values are col number. If non are set it is assumed that
  # the letter is found in the first row, and from all rows onwards :title is
  # assumed to on col 0 and :definition on col 1. If :letter is set, and non of
  # the others are set, it is assumed that the word is found first and the
  # definition later. 
  def self.add_dictionary(file_name, word_language_code, definition_language_code, order_options = {}, cols = {}, glossary_name = nil)
    letter_order = order_options[:letter_order]
    word_order = order_options[:word_order]
    first = true
    letter_title = String.new
    letter = nil
    if !cols[:letter].nil? && cols[:letter]!=cols[:word]
      letter_mode = COLUMN
      cols[:word] = next_available(cols.values) if cols[:word].nil?
      cols[:definition] = next_available(cols.values) if cols[:definition].nil?
    elsif letter_order == -1
      letter_mode = CALCULATE
      letter_order = 1
    else
      letter_mode = ROW
      cols[:letter] ||= 0
      cols[:word] ||= 0
      cols[:definition] ||= 1
    end
    if glossary_name.blank?
      glossary = nil
    else
      glossary = Glossary.find_by_title(glossary_name)
      glossary = Glossary.create(:title => glossary_name) if glossary.nil?
    end
    includes_grammatical_class = !cols[:grammatical_class].nil?
    includes_loan_type = !cols[:loan_type].nil?
    includes_dialect = !cols[:dialect].nil?
    includes_keywords = !cols[:keywords].nil?
    word_language = ComplexScripts::Language.find_by_code(word_language_code)
    definition_language = ComplexScripts::Language.find_by_code(definition_language_code)    
    CSV.open(file_name, "r", "\t") do |row|
      next if row.empty?
      if letter_mode==COLUMN || first && letter_mode==ROW
        letter_title = row[cols[:letter]].strip.downcase.chars.at(0)
      elsif letter_mode==CALCULATE
        letter_title = row[cols[:word]].base_letter(word_language_code)
      end
      if !letter_title.blank?
        letter = Letter.find_by_title(letter_title)
        if letter.nil?
          puts "#{row[cols[:word]]}: #{letter_title}"
          letter = Letter.create(:title => letter_title, :order => letter_order)
          letter_order+=1 if !letter_order.nil?
        end
      end
      if first && letter_mode==ROW
        first = false
        letter_title = nil
        next       
      end
      word_title = clean_field(row[cols[:word]])
      definition_title = clean_field(row[cols[:definition]])
      next if word_title.blank? || definition_title.blank?
      grammatical_class_title = clean_field(row[cols[:grammatical_class]]) if includes_grammatical_class
      loan_type_title = clean_field(row[cols[:loan_type]]) if includes_loan_type
      dialect_title = clean_field(row[cols[:dialect]]) if includes_dialect
      keywords_title = clean_field(row[cols[:keywords]]) if includes_keywords
      
      word = Word.find(:first, :conditions => { :title => word_title, :language_id => word_language })
      if word.nil?
        word = Word.create(:title => word_title, :language => word_language, :order => word_order, :letter => letter)
      else
        word.letter = letter
        word.order = word_order if !word_order.nil?
        word.save
      end
      if definition_title.chars.size>200
        word_definition = Word.find(:first, :conditions => ['LEFT(title, 200) = ? AND language_id = ?', definition_title.chars[0...200], definition_language])
      else      
        word_definition = Word.find(:first, :conditions => { :title => definition_title, :language_id => definition_language })
      end
      if word_definition.nil?
        word_definition = Word.create(:title => definition_title, :language => definition_language)
      else
        if definition_title.chars.size > word_definition.title.chars.size
          word_definition.title = definition_title
          word_definition.save
        end 
      end
      if includes_grammatical_class && !grammatical_class_title.blank?
        grammatical_class = GrammaticalClass.find_by_title(grammatical_class_title)
        grammatical_class = GrammaticalClass.create(:title => grammatical_class_title) if grammatical_class.nil?
      else
        grammatical_class = nil
      end
      if includes_loan_type && !loan_type_title.blank?
        loan_type = LoanType.find_by_title(loan_type_title)
        loan_type = LoanType.create(:title => loan_type_title) if loan_type.nil?
      else
        loan_type = nil
      end
      if includes_dialect && !dialect_title.blank?
        dialect = Dialect.find_by_title(dialect_title)
        dialect = Dialect.create(:title => dialect_title) if dialect.nil?
      else
        dialect = nil
      end
      definition = Definition.find(:first, :conditions => { :definiendum_id => word, :definition_id => word_definition, :glossary_id => glossary })
      if definition.nil? 
        definition = Definition.create(:definiendum => word, :definition => word_definition, :grammaticalClass => grammatical_class, :glossary => glossary, :loanType => loan_type, :dialect => dialect)
      else
        changed=false
        if !grammatical_class.nil?
          definition.grammatical_class = grammatical_class
          changed = true
        end
        if !loan_type.nil?
          definition.loan_type = loan_type
          changed = true
        end
        if !dialect.nil?
          definition.dialect = dialect
          changed = true
        end
        definition.save if changed
      end
      if includes_keywords && !keywords_title.blank?
        for keyword_title in keywords_title.split(',')
          keyword_title.strip!
          next if keyword_title.blank? || keyword_title=='-'
          keyword = Keyword.find_by_title(keyword_title)
          keyword = Keyword.create(:title => keyword_title) if keyword.nil?
          definition.keywords << keyword if !definition.keywords.include? keyword
        end
      end
      word_order += 1 if !word_order.nil?
    end
    return word_order
  end
  
  def self.add_dictionaries(files, word_language_code, definition_language_code, path, cols = {}, glossary_name = nil)
    word_order = 1
    letter_order = 1
    Dir.chdir(path) do
      for file in files
        puts "Processing #{file}.csv ..."
        word_order = DictionaryImportation.add_dictionary("#{file}.csv", word_language_code, definition_language_code, {:letter_order => letter_order, :word_order => word_order}, cols, glossary_name) 
        letter_order += 1
      end
    end
  end
  
  def self.sort_words(langs)
    Word.find(:all, :order => 'title', :conditions => ["language_id IN #{Util::interrogation_set(langs.size)}"] + langs.collect{ |l| ComplexScripts::Language.find_by_code(l).id}).each_with_index do |word, index|
      word.order = index
      word.save 
    end
    puts 
  end
end