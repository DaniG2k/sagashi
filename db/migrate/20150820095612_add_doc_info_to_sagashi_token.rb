class AddDocInfoToSagashiToken < ActiveRecord::Migration
  def change
    add_column :sagashi_tokens, :doc_info, :text
  end
end
