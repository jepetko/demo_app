=begin
FactoryGirl.define :user do |user|
  user.name                   "K. Golbang"
  user.email                  "golbang@gmx.at"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end
=end

FactoryGirl.define do
  factory :user, class: User do |user|
    user.name                   "K. Golbang"
    user.email                  "golbang@gmx.at"
    user.password               "foobar"
    user.password_confirmation  "foobar"
  end
end
