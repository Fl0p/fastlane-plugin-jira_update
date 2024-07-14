module Fastlane
  module Actions
    class JiraCommentUpdateAction < Action
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
        search = params[:comment_search]
        username = params[:username]
        comment = params[:comment_text]
        update_comment = params[:update_comment] || false
        fail_if_not_found = params[:fail_if_not_found] || false


        UI.message("JIRA ticket to update: '#{ticket}'")


        begin
          issue = client.Issue.find(ticket)
          
          UI.message("JIRA ticket: '#{issue.id}'")

          if search
            # search comment
            UI.message("Searching for comment: '#{search}'")
            comment_obj = issue.comments.find { |comment| 
              comment.body.include?(search) && comment.author['displayName'] == username
            }

            UI.error!("Comment not found") if fail_if_not_found && !comment_obj
            UI.message("Comment found: '#{comment_obj.body}'") if comment_obj

            if comment_obj && update_comment
              comment_obj.save({ 'body' => comment })
              UI.message("Comment updated: '#{comment_obj.body}'")
            elsif comment_obj
              comment_obj.delete
              UI.message("Comment deleted: '#{comment_obj.body}'")
            end
            
            if !update_comment
              new_comment = issue.comments.build
              new_comment.save({ 'body' => comment })
              UI.message("Comment added: '#{new_comment.body}'")
            end

          else 
            UI.message("No search provided, will add new comment")
            new_comment = issue.comments.build
            new_comment.save({ 'body' => comment })
            UI.message("Comment added: '#{new_comment.body}'")
          end

        rescue StandardError => e
          UI.important("Failed to fetch issue #{ticket}: #{e.message}")
          UI.error!("Failed to fetch issue #{ticket}: #{e.message}") if fail_if_not_found
          result = "Ticket not found"
        end

        UI.success("JIRA ticket updated: '#{issue.id}'")

        return issue
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
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :comment_search,
                                       description: "Jira comment text to find",
                                       type: String,
                                       optional: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :comment_text,
                                       description: "Jira comment text to add",
                                       type: String,
                                       default_value: "comment"),
          FastlaneCore::ConfigItem.new(key: :fail_if_not_found,
                                       description: "Fail if Issue or comment not found",
                                       type: Boolean,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :update_comment,
                                       description: "Update comment if found otherwise will delete and add new comment",
                                       type: Boolean,
                                       default_value: false)
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
          jira_comment_update(
            ticket: "APP-132",
            search: "Test comment",
            comment: "Test comment updated",
            update_comment: true
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
