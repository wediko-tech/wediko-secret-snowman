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
