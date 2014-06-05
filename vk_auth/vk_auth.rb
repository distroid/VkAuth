require 'net/http'

#
# Class for OAuth 2.0 on http://vk.com/
#
class VkAuth


	#
	# Class constructor
	#
	# auth_options - array aplication options
	#
	# return string
	#
	def initialize(auth_options)
		@options = {
			'auth_host'         => "oauth.vk.com",         # domain service
			'auth_page'         => "/authorize",           # auth page
			'api_host'          => "api.vk.com",           # domain API service
			'access_token_path' => "/access_token",        # page for getting access token
			'method_url_path'   => "/method/users.get"     # page for request api methods
		}
		@options = @options.merge(auth_options)
	end


	#
	# Getting user auth URL
	#
	# return string
	#
	def get_auth_url
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
	def get_user_data(code)
		access_uri  = URI::HTTPS.build(:host => @options['auth_host'], :path => @options['access_token_path'])
		params      = {
			'client_id'     => @options['client_id'],
			'client_secret' => @options['client_secret'],
			'redirect_uri'  => @options['redirect_uri'],
			'code'          => code
		}

		access_request = JSON.parse Net::HTTP.post_form(access_uri, params).body

		return nil if access_request['access_token'].nil? && access_request['user_id'].nil?

		current_user_uri = URI::HTTPS.build(:host  => @options['api_host'], :path  => @options["method_url_path"])

		response = JSON.parse Net::HTTP.post_form(current_user_uri, {'fields' => @options['user_fields'], 'uid' => access_request['user_id']}).body

		return nil if response.nil?
		response
	end


	public :get_auth_url, :get_user_data


end