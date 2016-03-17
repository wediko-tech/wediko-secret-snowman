class DeployNotifier
  class << self
    def notify_deploy(deploy_resource)
      return unless Rails.configuration.slack_send_messages

      env = deploy_resource.environment["RAILS_ENV"]
      revision = deploy_resource.revision

      slack.ping "#{env.capitalize} deploy complete on revision #{revision}."
    end

    private

    def slack
      @slack ||= Slack::Notifier.new Rails.configuration.slack_deploy_webhook_url,
        channel: Rails.configuration.slack_channel
    end
  end
end
