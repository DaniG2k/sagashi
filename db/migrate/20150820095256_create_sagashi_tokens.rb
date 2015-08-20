class CreateSagashiTokens < ActiveRecord::Migration
  def change
    create_table :sagashi_tokens do |t|

      t.timestamps null: false
    end
  end
end
