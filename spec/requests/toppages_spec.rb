require 'rails_helper'

RSpec.describe "Toppages", type: :request do
  describe "トップページ" do
    it "正常なレスポンス" do
      get root_path
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end
