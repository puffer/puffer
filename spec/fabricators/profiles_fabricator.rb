Fabricator :profile do
  name { Forgery::Name.first_name }
  surname { Forgery::Name.last_name }
  birth_date { Date.current }
end

Fabricator :profile_with_tags, :from => :profile do
  tags!(:count => 3) { |profile, i| Fabricate :tag }
end
