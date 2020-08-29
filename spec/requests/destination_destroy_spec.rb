require 'rails_helper'

RSpec.describe "Destination削除", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  
  describe "ログイン中に自分の投稿を削除する場合" do
    it "処理後、トップページへリダイレクト" do
      login_for_request(user)
      expect {
        delete destination_path(destination)
      }.to change(Destination, :count).by(-1)
      redirect_to user_path(user)
      follow_redirect!
      expect(response).to render_template('toppages/home')
    end
  end
  
  context "ログイン中、他人の投稿を削除する場合" do
    it "処理失敗後、トップページへリダイレクト" do
      login_for_request(other_user)
      expect {
          delete destination_path(destination)
        }.not_to change(Destination, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
    end
  end
      
  context "ログインしていない場合" do
    it "ログインページへリダイレクト" do
      expect {
          delete destination_path(destination)
        }.not_to change(Destination, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
