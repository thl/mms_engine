class AddPhoneticLetters < ActiveRecord::Migration
  @@order = 1
  def self.add_letter(letter_title)
    letter = Letter.find(:first, :conditions => {:title => letter})
    if letter.nil?
      Letter.create :title => letter_title, :order => @@order
    else
      letter.order = @@order
      letter.save
    end
    @@order+=1
  end
  
  def self.up
    remove_index :letters, :title
    add_letter "\303\270" # LATIN SMALL LETTER O WITH STROKE
    add_letter "\312\214" # LATIN SMALL LETTER TURNED V
    add_letter "a"
    add_letter "\304\201" # LATIN SMALL LETTER A WITH MACRON
    add_letter "\303\243" # LATIN SMALL LETTER A WITH TILDE
    add_letter "b"
    add_letter "bh"
    add_letter "\311\223" # LATIN SMALL LETTER B WITH HOOK
    add_letter "c"
    add_letter "ch"
    add_letter "d"
    add_letter "dh"
    add_letter "\311\226" # LATIN SMALL LETTER D WITH TAIL
    add_letter "\341\270\215" # LATIN SMALL LETTER D WITH DOT BELOW
    add_letter "\341\270\215h" # LATIN SMALL LETTER D WITH DOT BELOW
    add_letter "\311\226h" # LATIN SMALL LETTER D WITH TAIL
    add_letter "\311\227" # LATIN SMALL LETTER D WITH HOOK
    add_letter "\311\233" # LATIN SMALL LETTER OPEN E
    add_letter "e"
    add_letter "f"
    add_letter "g"
    add_letter "gh"
    add_letter "h"
    add_letter "i"
    add_letter "j"
    add_letter "jh"
    add_letter "k"
    add_letter "kh"
    add_letter "l"
    add_letter "\316\273" # GREEK SMALL LETTER LAMDA
    add_letter "m"
    add_letter "n"
    add_letter "\305\213" # LATIN SMALL LETTER ENG
    add_letter "\341\271\205" # LATIN SMALL LETTER N WITH DOT ABOVE
    add_letter "\311\224" # LATIN SMALL LETTER OPEN O
    add_letter "o"
    add_letter "p"
    add_letter "ph"
    add_letter "q"
    add_letter "r"
    add_letter "\305\233" # LATIN SMALL LETTER S WITH ACUTE
    add_letter "s"
    add_letter "t"
    add_letter "th"
    add_letter "\312\210" # LATIN SMALL LETTER T WITH RETROFLEX HOOK
    add_letter "\341\271\255" # LATIN SMALL LETTER T WITH DOT BELOW
    add_letter "\341\271\255h" # LATIN SMALL LETTER T WITH DOT BELOW
    add_letter "\312\210h" # LATIN SMALL LETTER T WITH RETROFLEX HOOK
    add_letter "u"
    add_letter "v"
    add_letter "w"
    add_letter "x"
    add_letter "y"
    add_letter "z"    
    add_letter "\312\224" # LATIN LETTER GLOTTAL STOP
        
    # Devanagari letters
    add_letter "\340\244\205" # LETTER A
    add_letter "\340\244\206" # LETTER AA
    add_letter "\340\244\207" # LETTER I
    add_letter "\340\244\210" # LETTER II
    add_letter "\340\244\211" # LETTER U
    add_letter "\340\244\212" # LETTER UU
    add_letter "\340\244\217" # LETTER E
    add_letter "\340\244\220" # LETTER AI
    add_letter "\340\244\223" # LETTER O
    add_letter "\340\244\224" # LETTER AU
    add_letter "\340\244\225" # LETTER KA
    add_letter "\340\244\226" # LETTER KHA
    add_letter "\340\244\227" # LETTER GA
    add_letter "\340\244\230" # LETTER GHA
    add_letter "\340\244\231" # LETTER NGA
    add_letter "\340\244\232" # LETTER CA
    add_letter "\340\244\233" # LETTER CHA
    add_letter "\340\244\234" # LETTER JA
    add_letter "\340\244\235" # LETTER JHA
    add_letter "\340\244\237" # LETTER TTA
    add_letter "\340\244\240" # LETTER TTHA
    add_letter "\340\244\241" # LETTER DDA
    add_letter "\340\244\242" # LETTER DDHA
    add_letter "\340\244\243" # LETTER NNA
    add_letter "\340\244\244" # LETTER TA
    add_letter "\340\244\245" # LETTER THA
    add_letter "\340\244\246" # LETTER DA
    add_letter "\340\244\247" # LETTER DHA
    add_letter "\340\244\250" # LETTER NA
    add_letter "\340\244\252" # LETTER PA
    add_letter "\340\244\253" # LETTER PHA
    add_letter "\340\244\254" # LETTER BA
    add_letter "\340\244\255" # LETTER BA
    add_letter "\340\244\256" # LETTER MA
    add_letter "\340\244\257" # LETTER YA
    add_letter "\340\244\260" # LETTER RA
    add_letter "\340\244\262" # LETTER LA
    add_letter "\340\244\265" # LETTER VA
    add_letter "\340\244\266" # LETTER SHA
    add_letter "\340\244\267" # LETTER SSA
    add_letter "\340\244\270" # LETTER SA
    add_letter "\340\244\271" # LETTER HA    
  end

  def self.down
  end
end
