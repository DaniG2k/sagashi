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
          coll = Sagashi::Collection.new
          batch.each do |obj|
            h = Hash.new
            Sagashi.configuration.index_text_fields.each {|field| h[field] = obj[field]}
            coll.docs << Sagashi::Document.new(:id => obj.id, :text_fields => h)
          end
          index = Sagashi::InvertedIndex.new(collection: coll)
          index.build
          index.commit!
        end
      end
    end
  end

  included do
    after_save :save_to_inverted_index
    after_destroy :destroy_from_inverted_index
  end

  private
  def save_to_inverted_index
  end

  def destroy_from_inverted_index
  end
end
# Include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)