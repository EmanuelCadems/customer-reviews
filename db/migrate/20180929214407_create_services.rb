class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.text :curl_cmd
      t.integer :execute_after, default: 0

      t.timestamps
    end
  end
end
