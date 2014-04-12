require 'ots'
require 'net/http'
require 'open-uri'
require 'json'
require 'rsolr'

class SearchController < ApplicationController
	include SearchHelper
	def index
		#article = OTS.parse("I lived in North Korea for the first 15 years of my life, believing Kim Jong-il was a god. I never doubted it because I didn't know anything else. I could not even imagine life outside of the regime.")
		#puts article.summarize(percent:50)

		# Following receives a response from popuparchive. 
		#puts JSON.pretty_generate(JSON.parse(response.body))
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

	def query_from_pop_up_archive_for_audios(query)
		uri = URI.parse("https://www.popuparchive.com:443/api/search?query=")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
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
	end
end
