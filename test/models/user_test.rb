require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with factory defaults" do
    assert build(:user).valid?
  end

  test "is invalid without email_address" do
    user = build(:user, email_address: "")

    refute user.valid?
    assert user.errors.of_kind?(:email_address, :blank)
  end

  test "is invalid with duplicate email_address" do
    create(:user, email_address: "dup@example.com")
    dup_user = build(:user, email_address: "dup@example.com")

    refute dup_user.valid?
    assert dup_user.errors.of_kind?(:email_address, :taken)
  end

  test "normalizes email_address by stripping and downcasing" do
    user = create(:user, email_address: " MixedCase@Example.COM ")

    assert_equal "mixedcase@example.com", user.reload.email_address
  end

  test "uniqueness catches email_addresses that differ only in case" do
    create(:user, email_address: "test@example.com")
    dup_user = build(:user, email_address: "TEST@EXAMPLE.COM")

    refute dup_user.valid?
    assert dup_user.errors.of_kind?(:email_address, :taken)
  end

  test "is invalid without password on create" do
    user = User.new(email_address: "test@example.com")

    refute user.valid?
    assert user.errors.of_kind?(:password, :blank)
  end

  test "is invalid with password shorter than 8 characters" do
    user = build(:user, password: "short", password_confirmation: "short")

    refute user.valid?
    assert user.errors.of_kind?(:password, :too_short)
  end

  test "is invalid with mismatched password_confirmation" do
    user = build(:user, password: "password", password_confirmation: "differentpassword")

    refute user.valid?
    assert user.errors.of_kind?(:password_confirmation, :confirmation)
  end

  test "is valid when updating without a password" do
    user = create(:user)

    assert user.update(email_address: "new@example.com")
    assert_equal "new@example.com", user.reload.email_address
  end

  test "destroys associated sessions on destroy" do
    user = create(:user)
    user.sessions.create!

    assert_difference("Session.count", -1) do
      user.destroy
    end
  end
end
