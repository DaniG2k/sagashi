module Sagashi
  class InvertedIndex
    attr_accessor :collection
    attr_reader :iidx

    def initialize(params={})
      @collection = params.fetch(:collection, Sagashi::Collection.new)
      @index_file = Sagashi.configuration.index_file
      @iidx = Hash.new
    end

    def build
      # The response has the following format:
      # {:term1=>
      #   {:doc_freq => 21,
      #    :ids => {
      #      :"1"=>6,
      #      :"2"=>5,
      #      :"4"=>5,
      #      :"5"=>2,
      #      :"7"=>3}
      #   }
      # }
      @collection.docs.each do |doc|
        doc.tokens.uniq.each do |token|
          tf = doc.term_freq(token)
          if @iidx[token]
            @iidx[token][:ids] = Hash.new unless @iidx[token][:ids]
            # Record the frequency of the term in doc
            @iidx[token][:ids][doc.id] = tf
            @iidx[token][:doc_freq] += tf
          else
            @iidx[token] = {
              :doc_freq => tf,
              :ids => { doc.id => tf }
            }
          end
        end
      end
      @iidx
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

    def find(str)
      tokens = Sagashi::Tokenizer.new(str).tokenize
      @collection.query = str
      #@collection.bm25
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

    # def commit!
    #   if File.exist?(@index_file)
    #     file = File.read @index_file
    #     # Merge the new tokens
    #     index = JSON.parse(file).merge(@iidx)
    #     File.open(@index_file, 'w+') { |f| f.write(index.to_json) }
    #   else
    #     # Create & write to file for the first time
    #     File.open(@index_file, 'w') { |f| f.write(@iidx) }
    #   end
    # end

  end
end
