# jira_update plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-jira_update)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-jira_update`, add it to your project by running:

```bash
fastlane add_plugin jira_update
```

## About jira_update

Update JIRA tickets status


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```ruby
lane :notes do
  result = jira_move_tickets(
    username: "me",
    password: "123", # password or api token
    url:      "https://jira.example.com",
    ticket: "APP-123",
    target: "ready"
  )
  puts result
end
```

## Options

```
fastlane action jira_move_tickets
```

[How to generate an API Access Token](https://confluence.atlassian.com/cloud/api-tokens-938839638.html)

Key | Description | Env Var | Default
----|-------------|---------|--------
url | URL for Jira instance | FL_JIRA_SITE |
username | Username for Jira instance | FL_JIRA_USERNAME |
password | Password for Jira or api token | FL_JIRA_PASSWORD |
ticket | Jira ticket to move String | FL_JIRA_TICKET |
tickets | Jira tickets to move Array of Strings | FL_JIRA_TICKETS |
target | Jira status move to | FL_JIRA_TARGET |


## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
