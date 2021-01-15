class AddQuestionAccesses < ActiveRecord::Migration[6.1]
  def change
    create_table :question_accesses do |t|
      t.references :question, foreign_key: true, index: true

      t.integer :times_accessed
      t.datetime :date

      t.timestamps null: false
    end
  end
end
