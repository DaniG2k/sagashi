module Sagashi
  class Document
    attr_accessor :id, :body, :rank

    def initialize(params={})
      @id = params.fetch :id, nil
      @body = params.fetch :body, ''
      @rank = params.fetch :rank, nil
    end

    def tokens
      set_tokens
    end

    def length
      if @tknz
        @tknz.join(' ').length
      else
        set_tokens.join(' ').length
      end
    end

    def include?(term)
      if @tknz
        @tknz.include?(term)
      else
        set_tokens.include?(term)
      end
    end

    def term_freq(term)
      if @tknz
        @tknz.count(term)
      else
        set_tokens.count(term)
      end
    end

    def uniq
      if @tknz
        @tknz.uniq
      else
        set_tokens.uniq
      end
    end
    
    private
    def set_tokens
      @tknz ||= Sagashi::Tokenizer.new(@body).tokenize
    end

    #def term_to_token(term)
    #  Sagashi::Tokenizer.new(term).tokenize.shift
    #end
  end
end
