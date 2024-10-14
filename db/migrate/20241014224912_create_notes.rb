class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.string :filename

      t.timestamps
    end
  end
end
