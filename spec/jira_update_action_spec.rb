describe Fastlane::Actions::JiraUpdateAction do
  before(:each) do
    @username = 'user_name'
    @password = 'pass123'
    @url = 'http://mydomain.atlassian.net:443'
    @ticket = 'ABC-123'
    @target = 'Done'
  end

  describe 'Plugin run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The jira_update plugin is working!")
      Fastlane::Actions::JiraUpdateAction.run(nil)
    end
  end

  describe 'Invalid Parameters' do
    it 'raises an error if no username was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_update({
            password: '#{@password}',
            url:      '#{@url}',
            ticket:  '#{@ticket}',
            target:  '#{@target}'
          })
        end").runner.execute(:test)
      end.to raise_error "No username"
    end

    it 'raises an error if no password was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_update({
            username: '#{@username}',
            url:      '#{@url}',
            ticket:  '#{@ticket}',
            target:  '#{@target}'
          })
        end").runner.execute(:test)
      end.to raise_error "No password"
    end

    it 'raises an error if no url was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_update({
            username: '#{@username}',
            password: '#{@password}',
            ticket:  '#{@ticket}',
            target:  '#{@target}'
          })
        end").runner.execute(:test)
      end.to raise_error "No url for Jira given"
    end

    it 'raises an error if no target was given' do
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          jira_update({
            username: '#{@username}',
            password: '#{@password}',
            url:      '#{@url}',
            ticket:  '#{@ticket}'
          })
        end").runner.execute(:test)
      end.to raise_error "No Jira target status"
    end

  end
end
