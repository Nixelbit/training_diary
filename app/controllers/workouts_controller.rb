class WorkoutsController < ApplicationController
  def index
    @workouts = current_user.workouts
  end

  def new
    @workout = current_user.workouts.new
  end

  def create
    @workout = current_user.workouts.build(workout_params)

    if @workout.save
      redirect_to workouts_path
    else
      render :new
    end
  end

  def show
    find_workout

    @workout_exercise = WorkoutExercise.new(workout: @workout)

    load_show_workout_data
  end

  def edit
    find_workout
  end

  def update
    find_workout

    if @workout.update(workout_params)
      redirect_to workout_path(@workout)
    else
      render :edit
    end
  end

  def destroy
    find_workout

    @workout.destroy

    redirect_to workouts_path, notice: "Тренировка удалена"
  end

  private

  def find_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:date, :name)
  end
end
