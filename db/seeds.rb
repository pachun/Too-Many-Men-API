def create_an_admin_user_for_local_development_environments
  if Rails.env.development? && AdminUser.count == 0
    AdminUser.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end
end

DUMMY_PHONE_NUMBER_FOR_IOS_APP_TESTERS_AT_APPLE = "0000000000"
def create_a_dummy_user_for_ios_app_testers_at_Apple
  if Player.find_by(
      phone_number: DUMMY_PHONE_NUMBER_FOR_IOS_APP_TESTERS_AT_APPLE,
    ).blank?

    Player.create(
      phone_number: DUMMY_PHONE_NUMBER_FOR_IOS_APP_TESTERS_AT_APPLE,
      first_name: "Johnny",
      last_name: "Appleseed",
    )
  end
end

create_an_admin_user_for_local_development_environments
create_a_dummy_user_for_ios_app_testers_at_Apple
