FactoryBot.define do
  factory :product do
    name { random_name }
    description { random_name }
    price "9.99"
  end
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
