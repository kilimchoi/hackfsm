# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Seed the Database with data from FSM API call.
file = File.read('db/fsmData.yaml')
file.gsub!("=>", ":")
hash = JSON[file]
for h in hash
	h.symbolize_keys! 
	Items.create!(creator: h[:fsmCreator].join(' '), dateCreated: h[:fsmDateCreated].join(' '), title: h[:fsmTitle].join(' '), 
		typeOfResource: h[:fsmTypeOfResource].join(' '), url: h[:fsmImageUrl].join(' '), relatedTitle: h[:fsmRelatedTitle].join(' '),
		identifier: h[:fsmIdentifier].join(' '), relatedIdentifier: h[:fsmRelatedTitle].join(' '), physicalLocation: h[:fsmPhysicalLocation].join(' '))
end



