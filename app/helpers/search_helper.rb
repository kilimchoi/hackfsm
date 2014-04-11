module SearchHelper
	def create_item(item_attributes)
		item = Items.new
		array = Array.new
		for attribute in item_attributes
			item.typeOfResource = attribute['fsmTypeOfResource']
			item.relatedTitle = attribute['fsmRelatedTitle']
			item.creator = attribute['fsmCreator']
			item.dateCreated = attribute['fsmDateCreated']
			item.identifier = attribute['fsmIdentifier']
			item.url = attribute['fsmImageUrl'] # or TeiUrl
			item.title = attribute['fsmTitle']
			item.notes = attribute['fsmNote']
			array.push(item)
		end
		return array
	 end
end
