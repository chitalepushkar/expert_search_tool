class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :web_url
      t.string :short_url

      t.timestamps
    end
  end
end
