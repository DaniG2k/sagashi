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
      if @tokenized_fields.present?
        @tokenized_fields
      else
        set_tokens
      end
    end

    def length
      tokens.map {|k,v| v.join(' ').length}.reduce(&:+)
    end

    def include?(term)
      tokens.any? {|k,v| v.include?(term)}
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