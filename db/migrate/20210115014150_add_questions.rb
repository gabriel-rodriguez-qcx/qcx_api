class AddQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :statement, limit: 255
      t.string :text, limit: 255
      t.string :answer, limit: 1
      t.string :discipline, limit: 255

      t.timestamps null: false
    end
  end
end
