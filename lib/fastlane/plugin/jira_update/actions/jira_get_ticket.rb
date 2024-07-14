module Fastlane
  module Actions
    class JiraGetTicketAction < Action
      def self.run(params)
        Actions.verify_gem!('jira-ruby')
        require 'jira-ruby'

        client = JIRA::Client.new(
          username:     params[:username],
          password:     params[:password],
          site:         params[:url],
          context_path: '',
          auth_type:    :basic
        )

        ticket = params[:ticket]
        UI.message("JIRA ticket id: '#{ticket}'")

        begin
          issue = client.Issue.find(ticket)
          
        rescue StandardError => e
          UI.important("Failed to fetch issue #{ticket}: #{e.message}")
          UI.error!("Failed to fetch issue #{ticket}: #{e.message}") if fail_if_not_found
          result = "Ticket not found"
        end

        # Convert the issue to a hash only with the fields we need
        issue_hash = {
          id: issue.id,
          key: issue.key,
          summary: issue.summary,
          description: issue.description,
          status: issue.status.name,
          assignee: issue.assignee.displayName,
          reporter: issue.reporter.displayName,
          created: issue.created,
          updated: issue.updated
        }

        UI.message("JIRA ticket found: '#{issue_hash[:key]}'")
        return issue_hash
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Jira ticket comment replace action"
      end

      def self.details
        "Replace Jira ticket comment"
      end

      def self.return_value
        "Hash where keys are Jira ticket IDs and values results of the action"
      end

      def self.return_type
        :hash
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "FL_JIRA_SITE",
                                       description: "URL for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No url for Jira given") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_JIRA_USERNAME",
                                       description: "Username for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No username") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FL_JIRA_PASSWORD",
                                       description: "Password or api token for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No password") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :ticket,
                                       env_name: "FL_JIRA_TICKET",
                                       description: "Jira ticket id",
                                       type: String,
                                       optional: true,
                                       default_value: nil)
        ]
      end

      def self.authors
        ["Flop Butylkin"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          '
          jira_get_ticket(
            ticket: "APP-132",
          )
          '
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
