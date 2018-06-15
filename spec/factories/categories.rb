FactoryBot.define do
  factory :category do
    name { random_name }
  end
end

def random_name
  ('a'..'z').to_a.shuffle.join
end
