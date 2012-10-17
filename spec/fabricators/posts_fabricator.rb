Fabricator :post do
  title { Forgery::LoremIpsum.sentence }
  body { Forgery::LoremIpsum.paragraphs 3 }
  status 'hidden'
end

Fabricator :post_with_categories, :from => :post do
  categories(:count => 2) { |post, i| Fabricate(:category) }
end
