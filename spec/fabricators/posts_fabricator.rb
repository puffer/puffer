Fabricator :post do
  title { Forgery::LoremIpsum.sentence }
  body { Forgery::LoremIpsum.paragraphs 3 }
end

Fabricator :post_with_categories, :from => :post do
  categories!(:count => 2) { |post, i| Fabricate(:category, :posts => [post]) }
end
