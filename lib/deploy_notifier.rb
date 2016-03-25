class DeployNotifier
  class << self
    def notify_deploy(deploy_resource)
      env = deploy_resource.environment["RAILS_ENV"]
      revision = deploy_resource.revision

      slack.ping "#{env.capitalize} deploy complete on revision #{revision}."
    end

    private

    def slack
      @slack ||= Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'],
        channel: ENV['SLACK_CHANNEL']
    end
  end
end
