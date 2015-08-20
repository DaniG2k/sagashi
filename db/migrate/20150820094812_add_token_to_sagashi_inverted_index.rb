class AddTokenToSagashiInvertedIndex < ActiveRecord::Migration
  def change
    add_column :sagashi_inverted_indices, :token, :string
  end
end
