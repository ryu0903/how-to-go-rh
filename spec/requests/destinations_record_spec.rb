require 'rails_helper'

RSpec.describe "新規投稿", type: :request do
  let!(:user) { create(:user) }
  let!(:destination) {create(:destination, user: user) }
  
  context "ログインしているユーザーの場合" do
    before do
      get new_destination_path
      login_for_request(user)
    end
    
    it "正常なレスポンス" do
      expect(response).to redirect_to new_destination_url
    end
    
    it "有効なデータで登録" do
      expect {
        post destinations_path, params: { destination: { to: "Tokyo",
                                                         from: "Hiroshima",
                                                         time: "4 hours",
                                                         date: "2020/8/1",
                                                         outline: "very far",
                                                         detail: "Take 'Nozomi' bullet train",
                                                         notice: "Get off Shinagawa station",
                                                         reference: "https://jr-central.co.jp/" } }
      }.to change(Destination, :count).by(1)
      follow_redirect!
      expect(response).to render_template ('destinations/show')
    end
    
    it "無効なデータで登録" do
      expect {
        post destinations_path, params: { destination: { to: "",
                                                         from: "Hiroshima",
                                                         time: "4 hours",
                                                         date: "2020/8/1",
                                                         outline: "very far",
                                                         detail: "Take 'Nozomi' bullet train",
                                                         notice: "Get off Shinagawa station",
                                                         reference: "https://jr-central.co.jp/" } }
      }.not_to change(Destination, :count)
      expect(response).to render_template ('destinations/new')
    end
  end
  
  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクト" do
      get new_destination_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
  
end
