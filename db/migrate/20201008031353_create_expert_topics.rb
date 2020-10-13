class CreateExpertTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :expert_topics do |t|
      t.string :topic, null:false
      t.references :user, type: :integer, null: false, index: true

      t.timestamps
    end
  end
end
