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
		query('Halloran')
		#puts Rails.application.config.api_key
	end

	def query(query, fl='id')
		url = "http://apis.berkeley.edu/solr/fsm/select"
		uri = URI.parse(url)
		params = {:q => query, :wt => "json", :app_id => Rails.application.config.api_id, :app_key => Rails.application.config.api_key}
		# Add params to URI
		uri.query = URI.encode_www_form(params)
			response = Net::HTTP.get(uri)
		docs_parsed = JSON.parse(JSON.pretty_generate(JSON.parse(response)["response"]["docs"]))
		create_item(docs_parsed)
		# Below grabs the information from the document array. 
		docs_parsed.each do |ele| 
			puts ele["fsmTypeOfResource"]
			puts ele["fsmRelatedTitle"]
			puts ele["fsmRelatedIdentifier"]
		end
	end

	def show 

	end
end
