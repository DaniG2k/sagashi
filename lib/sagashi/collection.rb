module Sagashi
  class Collection
    attr_accessor :query, :docs

    def initialize(params={})
      @docs = params.fetch(:docs, [])
      @query = params.fetch(:query, nil)

      def @docs.<<(arg)
        self.push(arg)
      end
    end

    def containing_term(term)
      @docs.count {|doc| doc.include?(term)}
    end
    
    def avg_dl
      @docs.map(&:length).inject(:+) / total_docs
    end

    def total_docs
      @docs.size
    end
  end
end