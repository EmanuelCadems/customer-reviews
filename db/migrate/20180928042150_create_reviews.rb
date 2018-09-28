class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :store_id
      t.integer :order_id
      t.integer :user_id
      t.string :opinion
      t.integer :score, default: 5

      t.timestamps
    end
    add_index :reviews, :store_id
    add_index :reviews, :order_id
    add_index :reviews, :user_id
  end
end
