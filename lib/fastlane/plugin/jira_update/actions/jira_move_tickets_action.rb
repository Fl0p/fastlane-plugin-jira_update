module Fastlane
  module Actions
    class JiraMoveTicketsAction < Action
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

        issues = {}
        issues[params[:ticket]] = "" if params[:ticket]
        params[:tickets].each { |ticket| issues[ticket] = "" } if params[:tickets]
        target = params[:target]

        UI.message("JIRA tickets to move: '#{issues.keys}' to '#{target}'")


        issues.each_key do |ticket|
          # puts "Moving ticket #{ticket}"
          result = ""
          begin
            issue = client.Issue.find(ticket)
            
            transition = issue.transitions.build
            available_transitions = issue.transitions.all.map { |t| { id: t.id, name: t.name } }
            # puts "Available transitions: #{available_transitions}"
            target_transition = available_transitions.find { |t| t[:name].casecmp(target).zero? }
            if target_transition
              transition.save!("transition" => { "id" => target_transition[:id] })
              result = "Success '#{target}'"
            else
              result = "Can't move to '#{target}'"
            end
        
          rescue StandardError => e
            UI.important("Failed to fetch issue #{ticket}: #{e.message}")
            result = "Ticket not found"
          end
          issues[ticket] = result
        end

        
        UI.message("JIRA tickets updated: '#{issues}'")

        return issues
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Jira update actions"
      end

      def self.details
        "Update Jira tickets"
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
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :tickets,
                                       env_name: "FL_JIRA_TICKETS",
                                       description: "Jira tickets ids array",
                                       type: Array,
                                       optional: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :target,
                                       env_name: "FL_JIRA_TARGET",
                                       description: "Target status for Jira tickets",
                                       type: String,
                                       default_value: "Closed")
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
          gym
          slack(message: "Done")
          jira_move_tickets(
            url: "https://jira.yourdomain.com",
            username: "Username",
            password: "Password",
            ticket: "ABC-123",
            target: "Done"
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
