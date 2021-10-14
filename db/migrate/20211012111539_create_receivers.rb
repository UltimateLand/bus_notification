class CreateReceivers < ActiveRecord::Migration[6.1]
  def change
    create_table :receivers do |t|
      t.string :email, null: false

      t.timestamps
    end
    add_index :receivers, :email, unique: true
  end
end
