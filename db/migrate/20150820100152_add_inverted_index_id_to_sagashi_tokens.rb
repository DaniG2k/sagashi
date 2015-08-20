class AddInvertedIndexIdToSagashiTokens < ActiveRecord::Migration
  def change
    add_column :sagashi_tokens, :inverted_index_id, :integer
  end
end
