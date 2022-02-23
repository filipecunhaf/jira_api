require_relative '../jira_api/request'
require 'oj'

module JiraAPI::Issue
  def create_issue(issue_fields)
    JiraAPI::Request.post("#{JiraAPI::API_PREFIX}/issue", issue_fields)
  end

  def get_issue(issue_key)
    JiraAPI::Request.get("#{JiraAPI::API_PREFIX}/issue/#{issue_key}").body
  end

  def add_comment(issue_key, comment)
    params = { body: comment }
    JiraAPI::Request.post("#{JiraAPI::API_PREFIX}/issue/#{issue_key}/comment", params)
  end

  def update_issue(issue_key, fields = {})
    JiraAPI::Request.put("#{JiraAPI::API_PREFIX}/issue/#{issue_key}", fields)
  end

  def set_assignee(issue_key, assignee_id)
    params = { name: assignee_id }
    JiraAPI::Request.put("#{JiraAPI::API_PREFIX}/issue/#{issue_key}/assignee", params)
  end

  def assignee_to_me(issue_key)
    # raise JiraAPI::Error if resp.status != 200
    # me = Oj.load( resp.body )
    # self.set_assignee( issue_key, me["key"] )
    set_assignee(issue_key, JiraAPI::Session.user)
  end


  def search(jql, _maxResults = 5000, startAt = 0, fields = [])
    query = { jql: jql, startAt: startAt, fields: fields }
    JiraAPI::Request.get("#{JiraAPI::API_PREFIX}/search", payload = nil, query = query).body # FIX - validation
  end

  def get_custom_fields_id
    JiraAPI::Request.get("#{JiraAPI::API_PREFIX}/field").body
  end

  def get_custom_field_id_by_name(all_fields, field_name)
    found = false
    all_fields.each do |custom_field|
      if custom_field['name'] == field_name
        found = true
        return custom_field['id']
      end
    end
    return nil unless found
  end

  def add_attach_raw(issue_key, raw, filename)
    c = Curl::Easy.new("#{JiraAPI::Request.url}#{JiraAPI::API_PREFIX}/issue/#{issue_key}/attachments")
    c.ssl_verify_peer = false
    c.ssl_verify_host = 0
    c.headers = JiraAPI::Request.headers.clone
    c.headers.update({ 'X-Atlassian-Token' => 'nocheck', 'Content-Type' => 'multipart/form-data' })
    c.multipart_form_post = true
    post_field = Curl::PostField.content('file', raw)
    post_field.remote_file = filename
    c.http_post(post_field)
  end

  def add_link(inwardIssue, link_type, outwardIssue)
    link = {
      type: {
        name: link_type.to_s
      },
      inwardIssue: {
        key: inwardIssue.to_s
      },
      outwardIssue: {
        key: outwardIssue.to_s
      }
    }
    JiraAPI::Request.post("#{JiraAPI::API_PREFIX}/issueLink", link)
  end

  def share_issue(issue_key, params = { usernames: [], emails: [], message: '' })
    JiraAPI::Request.post("/rest/share/1.0/issue/#{issue_key}", params)
  end

  # Doesnt works
  # The donwnload URL isnt related with /rest/api/latest
  # def download_attachments( issue_key )
  #   issue = Oj.load( self.get_issue( issue_key ) )
  #   #puts issue['fields']['attachment']
  #   filenames = []
  #   issue['fields']['attachment'].each do |attachment|
  #     filename = "#{issue_key}_#{attachment["filename"]}"
  #     filenames.push( filename )
  #     open(filename, "wb") do |file|
  #       file.write( JiraAPI::Request.get( attachment["content"], nil, nil ) )
  #     end
  #   end
  #   return filenames
  # end
end
