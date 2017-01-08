# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')
meetup_attributes = [
  { creator_id: 1, name: 'Space Drinking Nerds', description: 'Nerds drinking in space', location: 'Dark side of the moon' },
  { creator_id: 1, name: 'Space Explorers', description: 'We explore shit', location: 'Starship Enterprise' }
]

meetup_attributes.each do |attributes|
  Meetup.create(attributes)
end
