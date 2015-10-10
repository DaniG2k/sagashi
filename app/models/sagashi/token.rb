module Sagashi
  class Token < ActiveRecord::Base
    validates_presence_of :term
    serialize :doc_info

    class << self
      def spelling_suggestions(q)
        # TODO
        #query = Sagashi::Tokenizer.new(q)
        #query.tokenize
        #all.each do |token|
        #  query.tokens.each do |qt|
        #    suggester = Sagashi::SpellingSuggester.new(token.term, qt)
        #    distance = suggester.levenshtein_distance
        #  end
        #end
      end

    end
  end
end