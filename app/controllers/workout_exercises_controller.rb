class WorkoutExercisesController < ApplicationController
  def create
    @workout = current_user.workouts.find(params[:workout_id])

    @workout_exercise = WorkoutExercise.new(workout_exercise_params.merge(workout: @workout))

    if @workout_exercise.save
      redirect_to workout_path(@workout)
    else
      load_show_workout_data

      render "workouts/show", status: :unprocessable_content
    end
  end

  def update
    workout_exercise = WorkoutExercise.find(params[:id])

    if workout_exercise.update(workout_exercise_params)
      redirect_to workout_path(workout_exercise.workout)
    else
      @workout = workout_exercise.workout

      @editing_workout_exercise = workout_exercise

      @workout_exercise = WorkoutExercise.new(workout: @workout)

      load_show_workout_data

      render "workouts/show", status: :unprocessable_content
    end
  end

  private

  def workout_exercise_params
    params.require(:workout_exercise).permit(:exercise_id, :position)
  end
end
