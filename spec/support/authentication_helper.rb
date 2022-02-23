module AuthenticationHelper
  def authenticate
    params = {
      uri: 'http://jira.us',
      username: 'username',
      password: 'password'
    }

    allow_any_instance_of(Excon::Connection).to receive(
      :request
    ).with(
      {
        body: '{"username":"username","password":"password"}',
        expects: [200, 201],
        method: :post,
        path: '/rest/auth/1/session',
        query: nil
      }
    ).and_return(
      Excon::Response.new({ body: 'mock_auth_token' })
    )

    allow_any_instance_of(JiraAPI::Session).to receive(
      :set_session
    ).with('username', 'password').and_return('mock_auth_cookie')

    allow_any_instance_of(JiraAPI).to receive(
      :new
    ).and_return(
      JiraAPI.new(params)
    )

    @jira_client = JiraAPI.new(params)
  end
end
