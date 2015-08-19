module Sagashi
  class Ranker < Collection

    def initialize(params={})
      super
    end

    def idf(term)
      numerator = total_docs - containing_term(term) + 0.5
      denominator = containing_term(term) + 0.5
      Math.log(numerator / denominator)
    end

    def bm25(params={:k => 1.2, :b => 0.75, :delta => 1.0})
      @k = params[:k]
      @b = params[:b]
      @delta = params[:delta]

      @docs.each do |doc|
        score = 0
        dl = doc.length
        tokens = Sagashi::Tokenizer.new(@query).tokenize

        tokens.each do |token|
          dtf = doc.term_freq(token)
          numerator = dtf * (@k + 1)
          denominator = dtf + @k * (1 - @b + @b * (doc.length / avg_dl))
          score += idf(token) * (numerator/denominator) + @delta
        end
        doc.rank = score
      end
      @docs
    end
  end
end
