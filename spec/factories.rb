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

  sequence :email do |n|
    "person-#{n}@example.com"
  end

  factory :micropost, class: Micropost do |micropost|
    micropost.content "Foo bar"
    micropost.association :user
  end

end
