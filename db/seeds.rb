# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

subject = [
  {
    name: "Maths"
  },
  {
    name: "Physics"
  },
  {
    name: "History"
  },
  {
    name: "Chemistry"
  },
  {
    name: "Philosophy"
  },
  {
    name: "Biology"
  },
  {
    name: "Computer science"
  },
  {
    name: "Astronomy"
  }
]

subject.each do |subject|
  Subject.create(subject)
end
