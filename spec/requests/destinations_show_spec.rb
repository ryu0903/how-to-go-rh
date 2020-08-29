require 'rails_helper'

RSpec.describe "Destination詳細ページ", type: :request do
  let!(:user) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  
  context "ログイン済のユーザーの場合" do
    it "正常なレスポンス" do
      login_for_request(user)
      get destination_path(destination)
      expect(response).to have_http_status "200"
      expect(response).to render_template('destinations/show')
    end
  end
  
  context "ログインしていないユーザーの場合" do
    it "ログイン画面へリダイレクト" do
      get destination_path(destination)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
  
end
