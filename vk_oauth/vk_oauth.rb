#
# Class for OAuth 2.0 on http://vk.com/
#
class VkAuth

	require 'net/http'

	@options           = nil                           # array aplication options
	@@auth_url_options = {
		'auth_host'         => "oauth.vk.com",         # domain service
		'auth_page'         => "/authorize",           # auth page
		'api_host'          => "api.vk.com",           # domain API service
		'access_token_path' => "/access_token",        # page for getting access token
		'method_url_path'   => "/method/users.get"     # page for request api methods
	}


	#
	# Class constructor
	#
	# auth_options - array aplication options
	#
	# return string
	#
	def initialize(auth_options)
		@options = VkAuth.getUrlOptions
		@options = @options.merge(auth_options)
	end


	#
	# Getting auth params
	#
	# return array
	#
	def VkAuth.getUrlOptions
		@@auth_url_options
	end


	#
	# Getting user auth URL
	#
	# return string
	#
	def getAuthUrl
		URI::HTTPS.build(
			:host  => @options['auth_host'],
			:path  => @options['auth_page'],
			:query => {
				:client_id     => @options['client_id'],
				:redirect_uri  => @options['redirect_uri'],
				:response_type => "code",
			}.to_query
		).to_s
	end


	#
	# Gettion user data
	#
	# code - string access code for getting user info
	#
	# return array
	#
	def getUserData(code)
		accessUri = URI::HTTPS.build(
			:host => @options['auth_host'],
			:path => @options['access_token_path']
		)

		params = {
			'client_id'     => @options['client_id'],
			'client_secret' => @options['client_secret'],
			'redirect_uri'  => @options['redirect_uri'],
			'code'          => code
		}

		accessRequest = JSON.parse Net::HTTP.post_form(accessUri, params).body

		if accessRequest['access_token'].nil? && accessRequest['user_id'].nil?
			return nil
		end

		getCurrentUserUri = URI::HTTPS.build(
			:host  => @options['api_host'],
			:path  => @options["method_url_path"]
		)

		response JSON.parse Net::HTTP.post_form(getCurrentUserUri, {'fields' => @options['user_fields'], 'uid' => accessRequest['user_id']}).body

		if response[0].nil?
			return nil
		else
			return response[0]
		end
	end


	public :getAuthUrl, :getUserData


end