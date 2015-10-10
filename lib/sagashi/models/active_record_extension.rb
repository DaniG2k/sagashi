module ActiveRecordExtension
  extend ActiveSupport::Concern

  class_methods do
    def import
      if all.present?
        all.each_slice(1000) do |batch|
          #coll = Sagashi::Collection.new
          batch.each do |obj|
            # The text fields that the user wants indexed:
            Sagashi.configuration.index_text_fields.each do |field|
              tokenizer = Sagashi::Tokenizer.new(obj.send(field))
              tokenizer.tokenize
              tokenizer.tokens.each do |t|
                # Make the token if it doesn't already exist
                tmp = Sagashi::Token.find_by_term(t)
                if tmp.nil?
                  token = Sagashi::Token.new(:term => t)
                else
                  token = tmp
                end
                # Set the document info
                if token.doc_info.present?
                  if token.doc_info[field].present?
                    token.doc_info[field] << obj.id
                  else
                    token.doc_info[field] = [obj.id]
                  end
                else
                  token.doc_info = Hash.new
                  token.doc_info[field] = [obj.id]
                end
                token.save
              end
            end
            #h = Hash.new
            # TODO
            # Implement addition of specific fields to tokens.
            #Sagashi.configuration.index_text_fields.each {|field| h[field] = obj[field]}
            #coll.docs << Sagashi::Document.new(:id => obj.id, :text_fields => h)
          end
          #index = Sagashi::InvertedIndex.new(:collection => coll)
          #index.build
          #index.commit
        end
      end
    end

    def search(str)
      query_tokens = Sagashi::Tokenizer.new(str).tokenize
      #query_tokens.each do |token|
      #  db_token = Sagashi::Token.find_by_term(token)
      #end
      # Use Sagashi::Ranker's bm25 method to rank the results.
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