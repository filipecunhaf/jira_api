# require_relative 'jira_api/version'

Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require file }

class JiraAPI
  # REQUIRED_ARGS = %w(jira_uri)
  JiraAPI::API_PREFIX = '/rest/api/latest'

  include JiraAPI::Issue
  include JiraAPI::Workflow
  include JiraAPI::User

  autoload :Request, 'jira_api/request'
  autoload :Session, 'jira_api/session'

  def initialize(args = {})
    @has_session = false

    @@args = args

    @@args = args.merge(auth_method: 'user_pass') unless args.has_key?(:auth_method) # default authentication method

    JiraAPI::Request.url = URI.parse(@@args[:uri]).to_s
  end

  def login
    api_session = JiraAPI::Session.create(@@args)

    if api_session.token
      @has_session = true
      self.session = api_session.token
      true
    else
      false
    end
  end

  def session=(token)
    JiraAPI::Request.headers.update('Cookie' => "JSESSIONID=#{token}")
  end

  def logout
    JiraAPI::Session.destroy
  end

  def myself
    JiraAPI::Request.get("#{JiraAPI::API_PREFIX}/myself")
  end

  def has_session?
    @has_session = JiraAPI::Session.valid?
    @has_session
  end
end
