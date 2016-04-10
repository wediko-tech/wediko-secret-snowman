require 'spec_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET #index" do
    it "redirects to login" do
      get :index
      expect(response).to have_http_status(302)
    end
  end

end
