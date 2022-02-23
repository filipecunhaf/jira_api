# frozen_string_literal: true

require_relative '../spec_helper'
include AuthenticationHelper

describe JiraAPI::Workflow do
  before(:each) do
    authenticate
  end
  context 'get_transition_id_by_name' do
    it 'respond to' do
      expect { jira_client.get_transition_id_by_name }.to_not raise_error(NoMethodError)
    end
  end
end
