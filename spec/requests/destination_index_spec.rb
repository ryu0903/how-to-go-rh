require "rails_helper"

RSpec.describe "料理一覧ページ", type: :request do
  let!(:user) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  
  context "ログイン済ユーザーの場合" do
    it "トップページへリダイレクト（検索窓が空の場合はトップページへリダイレクトする設定）" do
      login_for_request(user)
      get destinations_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
  
  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクト" do
      get destinations_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
  
end
