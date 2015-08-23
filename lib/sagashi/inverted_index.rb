module Sagashi
  class InvertedIndex
    attr_accessor :collection
    attr_reader :iidx

    def initialize(params={})
      @collection = params.fetch(:collection, Sagashi::Collection.new)
      @iidx = Hash.new
    end

    def build
      # The response has the following format:
      # {:term1=>
      #   {:doc_freq => 21,
      #    :ids => {
      #      "1" => {:field1 => 3, :field2 => 3},
      #      "2" => {:field1 => 2, :field2 => 3},
      #      "4" => {:field1 => 3, :field2 => 2},
      #      "5" => {:field2 => 2},
      #      "7" => {:field1 => 3}
      #     }
      #   }
      # }
      @collection.docs.each do |doc|
        doc.tokens.each do |field, tokens_array|
          tokens_array.each do |token|
            tf = tokens_array.count(token)
            if @iidx[token].present?
              @iidx[token][:doc_freq] += tf
              @iidx[token][:ids] = Hash.new unless @iidx[token][:ids]
              # Record the frequency of the term in doc
              @iidx[token][:ids][doc.id] = Hash.new unless @iidx[token][:ids][doc.id]
              @iidx[token][:ids][doc.id][field] = tf
            else
              @iidx[token] = {
                :doc_freq => tf,
                :ids => {
                  doc.id => {field =>tf}
                }
              }
            end
          end
        end
      end
      @iidx
    end

    # Commit each entry in the inverted index object
    # to a Sagashi::Token in the db.
    def commit
      begin
        @iidx.each do |t|
          db_token = Sagashi::Token.new(
            :term => t[0],
            :doc_freq => t[1][:doc_freq],
            :doc_info => t[1][:ids]
            )
          db_token.save
        end
        return true
      rescue Exception => e
        # Do some logging
        raise e
      end
    end

    def find(str)
      tokens = Sagashi::Tokenizer.new(str).tokenize
      @collection.query = str
      #@collection.bm25
    end

    def remove_doc(doc)
      doc.tokens.each do |token|
        # Remove the document id
        @iidx[token].delete(doc.id)
        # Remove the key from the hash if there are no docs
        @iidx.delete(token) if @iidx[token].empty?
      end
      # Once all tokens have been removed,
      # temove the document from the collection.
      @collection.remove_doc(doc)
      @iidx
    end

    # Define query_or and query_and methods.
    %w(and or).each do |op|
      define_method("query_#{op}") do |word_ary|
        doc_ids = Array.new
        word_ary.each {|word| doc_ids << find(word) }
        case op
        when 'and'
          symbol = :&
        when 'or'
          symbol = :|
        end
        doc_ids.inject(symbol)
      end
    end
    
  end
end
