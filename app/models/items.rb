class Items < ActiveRecord::Base
	searchkick
	attr_accessible :creator, :dateCreated, :notes, :title, 
   :project_id, :typeOfResource, :url, :relatedTitle, :identifier, 
   :relatedIdentifier, :physicalLocation

   def to_string
    return ["Title: " + self.title, "Creator: " + self.creator, "Date Created: " + self.dateCreated,
      "Type of Resource: " + self.typeOfResource, "URL: " + self.url, "Related Title: " + self.relatedTitle,
      "Identifier: " + self.identifier]
   end

end
