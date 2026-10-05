Rails.application.routes.draw do
  resources :workouts do
    resources :workout_exercises, only: [ :index, :new, :create ] do
      resources :exercise_sets, only: [ :index, :new, :create ]
    end
  end

  resources :workout_exercises, only: [ :show, :edit, :update, :destroy ]
  resources :exercise_sets, only: [ :show, :edit, :update, :destroy ]
end
