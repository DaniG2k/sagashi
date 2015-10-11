class AddSpellingSuggestionsToSagashiTokens < ActiveRecord::Migration
  def change
    add_column :sagashi_tokens, :spelling_suggestions, :text
  end
end
