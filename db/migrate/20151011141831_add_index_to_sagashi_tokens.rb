class AddIndexToSagashiTokens < ActiveRecord::Migration
  def change
    add_column :sagashi_tokens, :term, :string
    add_index :sagashi_tokens, :term, unique: true
  end
end
