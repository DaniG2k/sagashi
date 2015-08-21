module ActiveRecordExtension
  extend ActiveSupport::Concern

  class_methods do
    def search(str)
      query = Rankrb::Tokenizer.new(str).tokenize
      # Load the inverted index if it's not aready in memory

      # Run .find to search for the keywords.
      # Use Rankrb::Collection's bm25 method to rank the results.
    end

    def import
      all.each_slice(1000) do |batch|
        # TODO:
        # Will need to import custom fields eventually
        coll = Rankrb::Collection.new
        batch.each do |obj|
          coll.docs << Rankrb::Document.new(id: obj.id, body: obj.body)
        end
        index = Rankrb::InvertedIndex.new(collection: coll)
        index.build
        # TODO: commit will need to take into account a db that already
        # exists, merging the json.
        index.commit!
      end
    end
  end

  included do
    after_save :add_to_inverted_index
  end

  def add_to_inverted_index
  end
end
# Include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)