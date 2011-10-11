Fabricator :mongoid_orm_primal, :class_name => 'mongoid_orm/primal' do
  string_field { Forgery::LoremIpsum.sentence }
  symbol_filed { Forgery::LoremIpsum.word.to_sym }
  select_field { sequence(:select_field) {|i| "option #{i}" } }
  integer_field { sequence :integer_field }
  float_field { sequence :float_field }
  decimal_field { sequence :decimal_field }
  datetime_field { sequence(:datetime_field) {|i| DateTime.now + i.days } }
  time_field { sequence(:time_field) {|i| DateTime.now + i.hours } }
  date_field { sequence(:date_field) {|i| DateTime.now + i.days } }
  boolean_field { rand 2 }
end