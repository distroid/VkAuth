VkAuth
======

Auth class for login vk.com

<h3>How to use</h3>

<ol>
	<li>First create aplication on vk.com</li>
	<li>Create action login by vk.com
<pre>def login_by_vk
	@options = {
		'client_id'         => [your_app_client_id],    # required
		'redirect_uri'      => [callback_action],       # required
	}
	redirect_to VkAuth.new(@options).get_auth_url
end</pre></li>
	<li>Create callback action
<pre>def login_by_vk_callback
	@options = {
		'client_id'         => [your_app_client_id],                      # required
		'redirect_uri'      => [callback_action],                         # required
		'client_secret'     => [your_app_client_secret],                  # required
		'user_fields'       => "uid,first_name,last_name,screen_name",    # optional
	}
	userdata = VkAuth.new(@options).get_user_data(request.GET["code"])
end</pre></li>
  <li>Save userdata in DB and login him</li>
</ol>
