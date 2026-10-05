class CreateExerciseSets < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_sets do |t|
      t.decimal :weight, precision: 5, scale: 2
      t.integer :repetitions
      t.integer :position
      t.text :notes
      t.references :workout_exercise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
