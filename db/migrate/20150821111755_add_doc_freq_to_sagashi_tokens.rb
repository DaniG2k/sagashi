class AddDocFreqToSagashiTokens < ActiveRecord::Migration
  def change
    add_column :sagashi_tokens, :doc_freq, :integer, :default => 0
  end
end
