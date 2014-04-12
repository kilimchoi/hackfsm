require 'net/http'
require 'open-uri'
require 'json'
require 'rsolr'
require 'nokogiri'

class SearchController < ApplicationController
	include SearchHelper
	def index
		# Uncomment the following the make the API requests.
		#@data = query_from_fsm("*")
		#@final = Array.new
		#for hash in @data
		#	@final << hash
		#end
		#File.open('fsmData.yaml', 'w').write(@final)

		#@popup_data = query_from_pop_up_archive_for_audios("*")
		#@arr = Array.new
		#for hash in @popup_data
		#	@arr << hash
		#end
		#File.open('popupData.yaml', 'w').write(@arr)
	end

	def query_from_fsm(query, fl='id')
		url = "http://apis.berkeley.edu/solr/fsm/select"
		uri = URI.parse(url)
		params = {:q => query, :wt => "json", :app_id => Rails.application.config.api_id, :app_key => Rails.application.config.api_key}
		# Add params to URI
		uri.query = URI.encode_www_form(params)
		response = Net::HTTP.get(uri)
		docs_parsed = JSON.parse(JSON.pretty_generate(JSON.parse(response)["response"]["docs"]))
		return docs_parsed
		#@item_arr = create_fsm_sources(docs_parsed)
		# Below returns the item from the API. 
		#return @item_arr
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
		return JSON.parse(response.body)
		
	end

	def result 
		# Handle the case when query statement is empty. 
		@query_statement = params[:q]
		sql = "Select * from Items i where i.title LIKE '%#{@query_statement}%'"
		@records_array = ActiveRecord::Base.connection.execute(sql)
		#@audios = query_from_pop_up_archive_for_audios(@query_statement)
		#@fsm_images_texts = query_from_fsm(@query_statement)
		# Handle the case when result is empty. 
		#@html_texts = get_texts_only()
		#retrieving images that are not TEI-type
		#@images_only = get_images_only()['response']['docs']
	end
    
	'''def search_handler 
		# Handling the Basic search
		text_query = ["article", "articles", "paper", "papers", "text", "texts"]
		photos_query = ["photos", "photo", "pictures", "picture"]
		@search_Arr = Array.new
		@query_statement = params[:q]
		#sql = "Select * from Items Where "
		records_array = ActiveRecord::Base.connection.execute(sql)
		if @query_statement
			search_Arr << @query_statement.split
			for word in search_Arr
				if word in text_query 

				end

				if word in photos_query

				end
			end

		end
	end'''
end
