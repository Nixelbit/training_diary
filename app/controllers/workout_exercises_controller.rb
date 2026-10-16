class WorkoutExercisesController < ApplicationController
  def create
    @workout = current_user.workouts.find(params[:workout_id])

    @workout_exercise = WorkoutExercise.new(workout_exercise_params.merge(workout: @workout))

    if @workout_exercise.save
      redirect_to workout_path(@workout)
    else
      load_show_workout_data

      render "workouts/show"
    end
  end

  private

  def workout_exercise_params
    params.require(:workout_exercise).permit(:exercise_id, :position)
  end
end
