require 'faker'


namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do

    Rake::Task['db:reset'].invoke
    User.create!(:name => "Example User", :email => "example@domain.com", :password => "123456", :password_confirmation => "123456")

    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@domain.com"
      password = "password"
      User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)

    end
  end
end