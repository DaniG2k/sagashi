class CreateSagashiInvertedIndices < ActiveRecord::Migration
  def change
    create_table :sagashi_inverted_indices do |t|

      t.timestamps null: false
    end
  end
end
