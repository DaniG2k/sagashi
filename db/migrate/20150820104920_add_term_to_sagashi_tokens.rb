class AddTermToSagashiTokens < ActiveRecord::Migration
  def change
    add_column :sagashi_tokens, :term, :string
  end
end
