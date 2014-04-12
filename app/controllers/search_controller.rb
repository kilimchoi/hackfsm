require 'net/http'
require 'open-uri'
require 'json'
require 'rsolr'
require 'nokogiri'

class SearchController < ApplicationController
	include SearchHelper
	def index
		#article = OTS.parse("I lived in North Korea for the first 15 years of my life, believing Kim Jong-il was a god. I never doubted it because I didn't know anything else. I could not even imagine life outside of the regime.")
		#puts article.summarize(percent:50)
		# Following receives a response from popuparchive. 
		#puts JSON.pretty_generate(JSON.parse(response.body))
		#puts get_texts_only()['response']['docs']
		#get_images_only()
		#document = Nokogiri::XML(open('input.xml'))
		#template   = Nokogiri::XML(open('http://content.cdlib.org/xml/ark:/13030/kt5m3nb0sh/'))  	
		#@text = template.css("text body")
		#@html_text = @text.to_html
		#transformed_document = template.transform(document)
		#File.open('output.html', 'w').write(template)
		#get_texts_only()['response']['docs'].each do |xml_doc| 
		#	puts xml_doc["fsmTeiUrl"]
		#end
	end

	def query_from_fsm(query, fl='id')
		url = "http://apis.berkeley.edu/solr/fsm/select"
		uri = URI.parse(url)
		params = {:q => query, :wt => "json", :app_id => Rails.application.config.api_id, :app_key => Rails.application.config.api_key}
		# Add params to URI
		uri.query = URI.encode_www_form(params)
		response = Net::HTTP.get(uri)
		docs_parsed = JSON.parse(JSON.pretty_generate(JSON.parse(response)["response"]["docs"]))
		@item_arr = create_fsm_sources(docs_parsed)
		# Below returns the item from the API. 
		return @item_arr
	end

	def get_texts_only()
		@query = "-fsmImageUrl:[* TO *]"
		uri = URI.parse("https://apis.berkeley.edu/solr/fsm/select")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		params = {:q => @query, :wt => "json", :app_id => Rails.application.config.api_id, :app_key => Rails.application.config.api_key}
		uri.query = URI.encode_www_form(params)
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		@result = JSON.parse(response.body)
		# Following handles getting the body element from xml document and adding it to the array.
		@xml_file_arr = Array.new
		@xml_files = @result['response']['docs']
		@xml_files.each do |file| 
			file['fsmTeiUrl'].each do |file_url| 
				template = Nokogiri::XML(open(file_url))
				@text = template.css("text body")
				@html_text = @text.to_html
				puts @html_text
				@xml_file_arr.push(@html_text)
			end
		end
		return @xml_file_arr
	end

	def get_images_only()
		@query = "-fsmTeiUrl:[* TO *]"
		uri = URI.parse("https://apis.berkeley.edu/solr/fsm/select")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		params = {:q => @query, :fl => "id,fsmImageUrl", :wt => "json", :app_id => Rails.application.config.api_id, :app_key => Rails.application.config.api_key}
		uri.query = URI.encode_www_form(params)
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		@result = JSON.parse(response.body)
		return @result
	end

	def query_from_pop_up_archive_for_audios(query)
		uri = URI.parse("https://www.popuparchive.com:443/api/search?query=")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		params = {:q => query}
		uri.query = URI.encode_www_form(params)
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		puts JSON.pretty_generate(JSON.parse(response.body))
		create_audio_sources(JSON.parse(response.body)["results"])
	end

	def result 
		@query_statement = params[:q]
		# Handle the case when query statement is empty. 
		@audios = query_from_pop_up_archive_for_audios(@query_statement)
		@fsm_images_texts = query_from_fsm(@query_statement)
		# Handle the case when result is empty. 
		@html_texts = get_texts_only()
		#retrieving images that are not TEI-type
		@images_only = get_images_only()['response']['docs']
	end
    
	'''def search_handler 
		# Handling the search for texts
		text_query = ["article", "articles", "paper", "papers", "text", "texts"]
		@search_Arr = Array.new
		@query_statement = params[:q]
		if @query_statement
			search_Arr << @query_statement.split
		end

		for word in search_Arr
			if word in text_query 

			end
		end
	end'''
end
