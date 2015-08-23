module Sagashi
  class Document
    attr_accessor :id,
                  :rank,
                  :text_fields

    def initialize(params={})
      @id = params.fetch :id, nil
      @rank = params.fetch :rank, nil
      @text_fields = params.fetch :text_fields, Array.new
    end

    def tokens
      set_tokens
    end

    def length
      if @tokenized_fields
        @tokenized_fields.collect {|k,v| v.join(' ').length}.reduce(&:+)
      else
        set_tokens.collect {|k,v| v.join(' ').length}.reduce(&:+)
      end
    end

    def include?(term)
      if @tokenized_fields
        @tokenized_fields.any? {|k,v| v.include?(term)}
      else
        set_tokens.any? {|k,v| v.include?(term)}
      end
    end

    def term_freq(term)
      if @tokenized_fields
        @tokenized_fields.collect {|k,v| v.count(term)}.reduce(&:+)
      else
        set_tokens.collect {|k,v| v.count(term)}.reduce(&:+)
      end
    end

    def uniq
      @uniqe = Hash.new
      if @tokenized_fields
        @tokenized_fields.each {|k,v| @uniqe[k] = v.uniq}
      else
        set_tokens.each {|k,v| @uniqe[k] = v.uniq}
      end
      @uniqe
    end
    
    private
    def set_tokens
      # Preserve the field for weighted zone scoring.
      @tokenized_fields = Hash.new
      @text_fields.each do |k, v|
        @tokenized_fields[k] = Sagashi::Tokenizer.new(v).tokenize
      end
      @tokenized_fields
    end
  end
end