module Sagashi
  # The same tokenizer should be used for document
  # tokenization and query tokenization
  class Tokenizer
    attr_accessor :str
    attr_reader :tokens

    def initialize(str='')
      @str = str
      @stopwords = Sagashi.configuration.stopwords
      # Change this to support multiple languages eventually:
      @lang = Sagashi.configuration.language

      # TODO
      # tokenize better based on language.
      #unicode_scripts = /[^\p{Alnum}\p{Arabic}\p{Armenian}\p{Balinese}\p{Bengali}\p{Bopomofo}\p{Braille}\p{Buginese}\p{Buhid}\p{Canadian_Aboriginal}\p{Carian}\p{Cham}\p{Cherokee}\p{Common}\p{Coptic}\p{Cuneiform}\p{Cypriot}\p{Cyrillic}\p{Deseret}\p{Devanagari}\p{Ethiopic}\p{Georgian}\p{Glagolitic}\p{Gothic}\p{Greek}\p{Gujarati}\p{Gurmukhi}\p{Han}\p{Hangul}\p{Hanunoo}\p{Hebrew}\p{Hiragana}\p{Inherited}\p{Kannada}\p{Katakana}\p{Kayah_Li}\p{Kharoshthi}\p{Khmer}\p{Lao}\p{Latin}\p{Lepcha}\p{Limbu}\p{Linear_B}\p{Lycian}\p{Lydian}\p{Malayalam}\p{Mongolian}\p{Myanmar}\p{New_Tai_Lue}\p{Nko}\p{Ogham}\p{Ol_Chiki}\p{Old_Italic}\p{Old_Persian}\p{Oriya}\p{Osmanya}\p{Phags_Pa}\p{Phoenician}\p{Rejang}\p{Runic}\p{Saurashtra}\p{Shavian}\p{Sinhala}\p{Sundanese}\p{Syloti_Nagri}\p{Syriac}\p{Tagalog}\p{Tagbanwa}\p{Tai_Le}\p{Tamil}\p{Telugu}\p{Thaana}\p{Thai}\p{Tibetan}\p{Tifinagh}\p{Ugaritic}\p{Vai}\p{Yi}]/
      @regex = /[^\s\p{Alnum}\p{Han}\p{Katakana}\p{Hiragana}\p{Hangul}]/
      @jap_punctuation = /[？！：。、]/
    end

    def tokenize_query
      # Tokens are an array
      @tokens = Array.new(basic_tokenization)
      @tokens
    end

    def tokenize
      # Tokens are a hash, where the key is the stem
      # and the val is the original word. This is useful for
      # spelling suggestions.
      @tokens = Hash.new
      basic_tokenization.each do |word|
        key = Lingua.stemmer(word, :language => @lang)
        if @tokens[key].present?
          @tokens[key] << word unless @tokens[key].include?(word)
        else
          @tokens[key] = [word]
        end
      end
      @tokens
    end

    private
    def basic_tokenization
      @str.gsub(@jap_punctuation, ' ')
          .gsub(@regex,'')
          .downcase
          .split
          .delete_if {|token| @stopwords.include?(token)}
    end
  end
end
