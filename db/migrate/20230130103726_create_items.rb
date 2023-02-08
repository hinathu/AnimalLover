class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer :customer_id, null: false
      t.integer :genre_id, null: false
      t.string :name, null: false
      t.string :category, null: false
      t.text :body, null: false
      t.boolean :is_draft, default: false, null: false
      t.timestamps
    end
  end
end