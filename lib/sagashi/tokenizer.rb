module Sagashi
  # The same tokenizer should be used for document
  # tokenization and query tokenization
  class Tokenizer
    attr_accessor :str
    attr_reader :tokens

    def initialize(str='')
      @str = str
      @tokens = Array.new
      @stopwords = Sagashi.configuration.stopwords
      # Change this to support multiple languages eventually:
      @lang = Sagashi.configuration.language
    end

    def tokenize
      #unicode_scripts = /[^\p{Alnum}\p{Arabic}\p{Armenian}\p{Balinese}\p{Bengali}\p{Bopomofo}\p{Braille}\p{Buginese}\p{Buhid}\p{Canadian_Aboriginal}\p{Carian}\p{Cham}\p{Cherokee}\p{Common}\p{Coptic}\p{Cuneiform}\p{Cypriot}\p{Cyrillic}\p{Deseret}\p{Devanagari}\p{Ethiopic}\p{Georgian}\p{Glagolitic}\p{Gothic}\p{Greek}\p{Gujarati}\p{Gurmukhi}\p{Han}\p{Hangul}\p{Hanunoo}\p{Hebrew}\p{Hiragana}\p{Inherited}\p{Kannada}\p{Katakana}\p{Kayah_Li}\p{Kharoshthi}\p{Khmer}\p{Lao}\p{Latin}\p{Lepcha}\p{Limbu}\p{Linear_B}\p{Lycian}\p{Lydian}\p{Malayalam}\p{Mongolian}\p{Myanmar}\p{New_Tai_Lue}\p{Nko}\p{Ogham}\p{Ol_Chiki}\p{Old_Italic}\p{Old_Persian}\p{Oriya}\p{Osmanya}\p{Phags_Pa}\p{Phoenician}\p{Rejang}\p{Runic}\p{Saurashtra}\p{Shavian}\p{Sinhala}\p{Sundanese}\p{Syloti_Nagri}\p{Syriac}\p{Tagalog}\p{Tagbanwa}\p{Tai_Le}\p{Tamil}\p{Telugu}\p{Thaana}\p{Thai}\p{Tibetan}\p{Tifinagh}\p{Ugaritic}\p{Vai}\p{Yi}]/
      regex = /[^\s\p{Alnum}\p{Han}\p{Katakana}\p{Hiragana}\p{Hangul}]/
      jap_punctuation = /[？！：。、]/
      
      @tokens = @str.gsub(jap_punctuation, ' ')
                    .gsub(regex,'')
                    .downcase
                    .split
                    .delete_if {|token| @stopwords.include?(token)}
                    .map {|w| Lingua.stemmer(w, :language => @lang)}
      @tokens
    end
  end
end
