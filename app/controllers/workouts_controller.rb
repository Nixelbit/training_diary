class WorkoutsController < ApplicationController
  def index
    @workouts = current_user.workouts
  end

  def new
    @workout = Workout.new
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
    @workout = Workout.find(params[:id])
  end

  def edit
    @workout = Workout.find(params[:id])
  end

  def update
    @workout = Workout.find(params[:id])

    if @workout.update(workout_params)
      redirect_to workout_path(@workout)
    else
      render :edit
    end
  end

  def destroy
    @workout = Workout.find(params[:id])

    @workout.destroy

    redirect_to workouts_path, notice: "Тренировка удалена"
  end

  private

  def workout_params
    params.require(:workout).permit(:date, :name)
  end
end
