require 'rails_helper'

RSpec.describe "Destination編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  let!(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test2.png') }
  let!(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }
  
  describe "ログイン済ユーザーの場合&フレンドリーフォワーディング" do
    it "正常なレスポンス" do
      get edit_destination_path(destination)
      login_for_request(user)
      expect(response).to redirect_to edit_destination_url(destination)
      patch destination_path(destination), params: { destination: { to: "沖縄",
                                                                   from: "Tokyo",
                                                                   time: "3 hours",
                                                                   date: "2020-8-5",
                                                                   outline: "bacation",
                                                                   detail: "airplane",
                                                                   notice: "very hot",
                                                                   reference: "ANA",
                                                                   picture: picture2} }
      redirect_to destination
      follow_redirect!
      expect(response).to render_template('destinations/show')
    end
  end
  
  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクト" do
      get edit_destination_path(destination)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      
      patch destination_path(destination), params: { destination: { to: "沖縄",
                                                                    from: "Tokyo",
                                                                    time: "3 hours",
                                                                    date: "2020-8-5",
                                                                    outline: "bacation",
                                                                    detail: "airplane",
                                                                    notice: "very hot",
                                                                    reference: "ANA" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path 
    end
  end
  
  context "別アカウントでログイン済のユーザーの場合" do
    it "ホーム画面へリダイレクト" do
      login_for_request(other_user)
      get edit_destination_path(destination)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
      
      patch destination_path(destination), params: { destination: { to: "沖縄",
                                                                    from: "Tokyo",
                                                                    time: "3 hours",
                                                                    date: "2020-8-5",
                                                                    outline: "bacation",
                                                                    detail: "airplane",
                                                                    notice: "very hot",
                                                                    reference: "ANA" } } 
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
    end
  end
end
