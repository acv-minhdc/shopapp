FactoryBot.define do
  factory :user do
    email 'testaccount@gmail.com'
    password '123456'
    password_confirmation '123456'
    firstname 'Test'
    lastname 'Acc'
  end
end
