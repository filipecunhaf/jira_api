require_relative '../jira_api/request'
require 'oj'

module JiraAPI::Workflow
  def get_transition_id_by_name(issue_key, transition_name)
    resp = JiraAPI::Request.get("#{JiraAPI::API_PREFIX}/issue/#{issue_key}/transitions")
    raise JiraAPI::Error, "Unable to find transactions. #{resp.class}" if resp.status != 200

    valid_transitions = Oj.load(resp.body)
    # binding.pry
    # puts valid_transitions
    id = nil
    valid_transitions['transitions'].each do |status|
      # puts "#{status["id"]}\t-\t#{status["name"]}\t-\t#{transition_name}"
      id = status['id'] if status['name'] == transition_name
    end
  rescue JiraAPI::Error => e
    raise e.message
  else
  ensure
    return id
  end

  def set_transition(issue_key, transition_name)
    transition_id = get_transition_id_by_name(issue_key, transition_name)
    if transition_id.nil?
      raise JiraAPI::Error,
            "Unable to find transition with name #{transition_name}"
    end

    fields = { transition: transition_id }
    resp = JiraAPI::Request.post("#{JiraAPI::API_PREFIX}/issue/#{issue_key}/transitions", fields)
    raise JiraAPI::Error, resp.body.to_s if resp.status != 204
  rescue JiraAPI::Error => e
    raise e.message
  else
    true
  end
end
