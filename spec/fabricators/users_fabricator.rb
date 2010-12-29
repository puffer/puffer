Fabricator :user do
  email {Forgery::Internet.email_address}
  password '123456'
end

Fabricator :user_with_profile, :from => :user do
  profile! { Fabricate :profile }
end

Fabricator :user_with_profile_and_tags, :from => :user do
  profile! { Fabricate :profile_with_tags }
end
