# frozen_string_literal: true

require_relative '../spec_helper'
include AuthenticationHelper

describe JiraAPI::Issue do
  before(:each) do
    authenticate
  end

  context 'share_issue' do
    it 'respond to share_issue' do
      expect { @jira_client.share_issue }.to_not raise_error(NoMethodError)
    end
    it 'must pass two arguments' do
      expect { @jira_client.share_issue }.to raise_error(ArgumentError)
    end
    it 'successful shared a issue' do
      allow_any_instance_of(Excon::Connection).to receive(
        :request
      ).and_return(
        Excon::Response.new(
          {
            body: 'RESPONSE_BODY',
            status: 200
          }
        )
      )

      expect(
        @jira_client.share_issue(
          'MOCK-1234',
          {
            usernames: ['user'], emails: ['user@mail.com'], message: 'Issue shared'
          }
        ).body
      ).to eq('RESPONSE_BODY')
    end
  end
end
