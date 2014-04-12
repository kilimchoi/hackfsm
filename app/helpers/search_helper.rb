module SearchHelper
	def create_fsm_sources(fsm_sources)
		@item = Items.new
		@array = Array.new
		for source in fsm_sources
			@item.typeOfResource = source['fsmTypeOfResource']
			@item.relatedTitle = source['fsmRelatedTitle']
			@item.creator = source['fsmCreator']
			@item.dateCreated = source['fsmDateCreated']
			@item.identifier = source['fsmIdentifier']
			@item.url = source['fsmImageUrl'] # or TeiUrl
			@item.title = source['fsmTitle']
			@item.notes = source['fsmNote']
			@array.push(@item)
		end
		return @array
	 end

	 def create_audio_sources(audio_sources)
	 	@audio = Audio.new
	 	@array = Array.new
	 	for audio_source in audio_sources
	 		for source in audio_source['audio_files']
	 			@audio.url = source['url']
	 			@audio.filename = source['filename']
	 			@audio.audio_id = source['id']
	 			@array.push(@audio)
	 		end
	 	end
	 	return @array
	 end
end
