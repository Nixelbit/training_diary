require "test_helper"

class ExerciseSetTest < ActiveSupport::TestCase
  test "is valid with factory defaults" do
    assert build(:exercise_set).valid?
  end

  test "is invalid without workout_exercise" do
    exercise_set = build(:exercise_set, workout_exercise: nil)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:workout_exercise, :blank)
  end

  test "is valid with lower boundary position" do
    assert build(:exercise_set, position: 1).valid?
  end

  test "is valid with upper boundary position" do
    assert build(:exercise_set, position: 9_999).valid?
  end

  test "is invalid without position" do
    exercise_set = build(:exercise_set, position: nil)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:position, :not_a_number)
  end

  test "is invalid with zero or negative position" do
    [ 0, -1 ].each do |value|
      exercise_set = build(:exercise_set, position: value)

      refute exercise_set.valid?
      assert exercise_set.errors.of_kind?(:position, :greater_than)
    end
  end

  test "is invalid with integer-valued float position" do
    exercise_set = build(:exercise_set, position: 1.0)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:position, :not_an_integer)
  end

  test "is invalid with non-integer position" do
    exercise_set = build(:exercise_set, position: 1.5)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:position, :not_an_integer)
  end

  test "is invalid with position above upper boundary" do
    exercise_set = build(:exercise_set, position: 10_000)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:position, :less_than)
  end

  test "is invalid with duplicate position in same workout_exercise" do
    workout_exercise = create(:workout_exercise)
    create(:exercise_set, workout_exercise: workout_exercise, position: 1)
    duplicate = build(:exercise_set, workout_exercise: workout_exercise, position: 1)

    refute duplicate.valid?
    assert duplicate.errors.of_kind?(:position, :taken)
  end

  test "allows same position in different workout_exercise" do
    create(:exercise_set, workout_exercise: create(:workout_exercise), position: 1)
    other = build(:exercise_set, workout_exercise: create(:workout_exercise), position: 1)

    assert other.valid?
  end

  test "is valid with zero weight" do
    assert build(:exercise_set, weight: 0).valid?
  end

  test "is valid with nil weight" do
    assert build(:exercise_set, weight: nil).valid?
  end

  test "is valid with decimal weight" do
    assert build(:exercise_set, weight: 0.01).valid?
  end

  test "is valid with upper boundary weight" do
    assert build(:exercise_set, weight: 999.99).valid?
  end

  test "is valid with numeric string weight" do
    assert build(:exercise_set, weight: "999.99").valid?
  end

  test "normalizes blank weight to nil" do
    exercise_set = build(:exercise_set, weight: "")

    assert exercise_set.valid?
    assert_nil exercise_set.weight
  end

  test "rounds weight to column scale (2 decimals) on assignment" do
    assert_equal BigDecimal("999.99"), build(:exercise_set, weight: 999.994).weight
    assert_equal BigDecimal("0.00"), build(:exercise_set, weight: -0.001).weight
    assert_equal BigDecimal("1000.00"), build(:exercise_set, weight: 999.995).weight
  end

  test "is invalid with weight above upper boundary" do
    exercise_set = build(:exercise_set, weight: 1_000)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:weight, :less_than_or_equal_to)
  end

  test "is invalid with negative decimal weight" do
    exercise_set = build(:exercise_set, weight: -0.01)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:weight, :greater_than_or_equal_to)
  end

  test "is invalid with non-numeric weight" do
    exercise_set = build(:exercise_set, weight: "abc")

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:weight, :not_a_number)
  end

  test "is valid with lower boundary repetitions" do
    assert build(:exercise_set, repetitions: 1).valid?
  end

  test "is valid with upper boundary repetitions" do
    assert build(:exercise_set, repetitions: 9_999).valid?
  end

  test "is valid with numeric string repetitions" do
    assert build(:exercise_set, repetitions: "5").valid?
  end

  test "is invalid with repetitions above upper boundary" do
    exercise_set = build(:exercise_set, repetitions: 10_000)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:repetitions, :less_than)
  end

  test "is invalid with zero or negative repetitions" do
    [ 0, -1 ].each do |value|
      exercise_set = build(:exercise_set, repetitions: value)

      refute exercise_set.valid?
      assert exercise_set.errors.of_kind?(:repetitions, :greater_than)
    end
  end

  test "is invalid with nil repetitions" do
    exercise_set = build(:exercise_set, repetitions: nil)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:repetitions, :not_a_number)
  end

  test "is invalid with integer-valued float repetitions" do
    exercise_set = build(:exercise_set, repetitions: 1.0)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:repetitions, :not_an_integer)
  end

  test "is invalid with non-integer repetitions" do
    exercise_set = build(:exercise_set, repetitions: 1.5)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:repetitions, :not_an_integer)
  end

  test "is invalid with non-numeric string repetitions" do
    exercise_set = build(:exercise_set, repetitions: "abc")

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:repetitions, :not_a_number)
  end

  test "is valid with nil notes" do
    assert build(:exercise_set, notes: nil).valid?
  end

  test "normalizes empty notes to nil" do
    exercise_set = build(:exercise_set, notes: "")

    assert exercise_set.valid?
    assert_nil exercise_set.notes
  end

  test "is valid with notes at maximum length" do
    assert build(:exercise_set, notes: "a" * 2000).valid?
  end

  test "is invalid with notes over maximum length" do
    exercise_set = build(:exercise_set, notes: "a" * 2001)

    refute exercise_set.valid?
    assert exercise_set.errors.of_kind?(:notes, :too_long)
  end

  test "normalizes whitespace-only notes to nil" do
    exercise_set = build(:exercise_set, notes: " " * 2001)

    assert exercise_set.valid?
    assert_nil exercise_set.notes
  end

  test "strips surrounding whitespace from notes" do
    exercise_set = build(:exercise_set, notes: " Заметка ")

    assert_equal "Заметка", exercise_set.notes
  end
end
