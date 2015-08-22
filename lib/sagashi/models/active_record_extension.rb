module ActiveRecordExtension
  extend ActiveSupport::Concern

  class_methods do
    def search(str)
      query = Sagashi::Tokenizer.new(str).tokenize
      # Load the inverted index if it's not aready in memory

      # Run .find to search for the keywords.
      # Use Sagashi::Collection's bm25 method to rank the results.
    end

    def import
      if all.present?
        all.each_slice(1000) do |batch|
          # TODO:
          # Will need to import custom fields eventually
          coll = Sagashi::Collection.new
          batch.each do |obj|
            coll.docs << Sagashi::Document.new(id: obj.id, body: obj.body)
          end
          index = Sagashi::InvertedIndex.new(collection: coll)
          index.build
          index.commit!
        end
      else
        puts "Nothing to import"
      end
    end
  end

  included do
    after_save :save_to_inverted_index
    after_destroy :destroy_from_inverted_index
  end

  def save_to_inverted_index
  end
  
  def destroy_from_inverted_index
  end
end
# Include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)