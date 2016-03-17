require 'spec_helper'

describe DeployNotifier do
  describe "#notify_deploy" do
    let :deploy_resource do
      OpenStruct.new(environment: {"RAILS_ENV" => "test"}, revision: @revision)
    end

    before :each do
      @revision = "ayylm40"
      # mock out the actual slack client
      @dummy_client = double
      allow(DeployNotifier).to receive(:slack) { @dummy_client }
    end

    context "when send messages config is disabled" do
      around :each do |example|
        temporarily_set_slack_config(false, example)
      end

      it "does not send messages" do
        expect(@dummy_client).not_to receive(:ping)
        DeployNotifier.notify_deploy(deploy_resource)
      end
    end

    context "when send messages config is enabled" do
      around :each do |example|
        temporarily_set_slack_config(true, example)
      end

      it "sends some kind of message" do
        expect(@dummy_client).to receive(:ping)
        DeployNotifier.notify_deploy(deploy_resource)
      end

      it "sends a message including the environment" do
        expect(@dummy_client).to receive(:ping).with(/#{Rails.env}/i)
        DeployNotifier.notify_deploy(deploy_resource)
      end

      it "sends a message including the revision" do
        expect(@dummy_client).to receive(:ping).with(/#{@revision}/)
        DeployNotifier.notify_deploy(deploy_resource)
      end
    end
  end

  def temporarily_set_slack_config(setting, example)
    prev_config, Rails.configuration.slack_send_messages = [Rails.configuration.slack_send_messages, setting]
    example.run
    Rails.configuration.slack_send_messages = prev_config
  end
end
