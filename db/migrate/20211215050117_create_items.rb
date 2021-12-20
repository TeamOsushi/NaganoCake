class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :image_id
      t.integer :genre_id
      t.text :introduction
      t.boolean :is_sales_status, null: false, default: 0
      t.integer :price_without_tax
      t.timestamps
    end
  end
end
