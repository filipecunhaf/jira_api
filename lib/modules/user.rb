require_relative '../jira_api/request'
require 'oj'

module JiraAPI::User
  def get_user_details(user)
    resp = JiraAPI::Request.get("#{JiraAPI::API_PREFIX}/user?key=#{user}")
    raise JiraAPI::Error, "Unable to find user. #{resp.class}" if resp.status != 200

    user = Oj.load(resp.body)
  rescue JiraAPI::Error => e
    raise e.message
  else
    user
  end
end
