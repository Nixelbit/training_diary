class ExerciseSetsController < ApplicationController
  def create
    @workout_exercise = WorkoutExercise.find(params[:workout_exercise_id])

    @exercise_set = @workout_exercise.exercise_sets.build(exercise_set_params)

    if @exercise_set.save
      redirect_to workout_path(@workout_exercise.workout)
    else
      @workout = @workout_exercise.workout

      @workout_exercise = WorkoutExercise.new(workout: @workout)

      load_show_workout_data

      render "workouts/show", status: :unprocessable_content
    end
  end

  def update
    exercise_set = ExerciseSet.find(params[:id])

    if exercise_set.update(exercise_set_params)
      redirect_to workout_path(exercise_set.workout_exercise.workout)
    else
      @workout = exercise_set.workout_exercise.workout

      @editing_exercise_set = exercise_set

      @workout_exercise = WorkoutExercise.new(workout: @workout)

      load_show_workout_data

      render "workouts/show", status: :unprocessable_content
    end
  end

  private

  def exercise_set_params
    params.require(:exercise_set).permit(:weight, :repetitions, :position, :notes)
  end
end
