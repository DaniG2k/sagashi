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
              # Tokenize the strings
              tokenizer = Sagashi::Tokenizer.new(obj.send(field))
              tokenizer.tokenize
              tokenizer.tokens.each do |t|
                # Make the token if it doesn't already exist
                token = Sagashi::Token.find_by_term(t)
                if token.nil?
                  token = Sagashi::Token.new(:term => t)
                end
                # Set the document info
                if token.doc_info.present?
                  if token.doc_info[field].present?
                    # Ensure we don't get the same doc id multiple
                    # times within the array.
                    unless token.doc_info[field].include?(obj.id)
                      token.doc_info[field] << obj.id
                    end
                  else
                    token.doc_info[field] = [obj.id]
                  end
                else
                  token.doc_info = Hash.new
                  token.doc_info[field] = [obj.id]
                end

                token.doc_freq += 1
                token.save
              end
            end
            
          end
          #index = Sagashi::InvertedIndex.new(:collection => coll)
          #index.build
          #index.commit
        end
      end
    end

    def search(str)
      query = Sagashi::Tokenizer.new(str)
      query.tokenize
      appears_in_docs = Array.new
      query.tokens.each do |token|
        retrieved_token = Sagashi::Token.find_by_term(token)
        unless retrieved_token.nil?
          retrieved_token.doc_info.each do |key, val|
            val.each {|id| appears_in_docs << id unless appears_in_docs.include?(id)}
          end
        end
      end
      # Return the matching model objects by looking for the ids.
      where(:id => appears_in_docs)
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