# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = {
  'Category #1' => {
    'Category #11' => {},
    'Category #12' => {
      'Category #121' => {
        'Category #1211' => {}
      },
      'Category #122' =>{}
    },
    'Category #13' => {
      'Category #131' => {}
    }
  },
  'Category #2' => {
    'Category #21' => {}
  }
}

def create_category hash, parent = nil
  hash.each do |(title, children)|
    c = Category.create :title => title, :parent => parent
    create_category children, c
  end
end

create_category categories