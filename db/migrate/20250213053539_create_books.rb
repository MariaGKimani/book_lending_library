class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn, null: false
      t.boolean :available

      t.timestamps

      t.index :isbn, unique: true

    end
  end
end
