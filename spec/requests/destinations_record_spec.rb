require 'rails_helper'

RSpec.describe "新規投稿", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:destination) {create(:destination, user: user) }
  let!(:picture_path) { File.join(Rails.root, 'spec/fixtures/test.jpg') }
  let!(:picture) { Rack::Test::UploadedFile.new(picture_path) }
  
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
                                                         reference: "https://jr-central.co.jp/",
                                                         picture: picture,
                                                         schedules_attributes: [
                                                           to: "Okinawa",
                                                           from: "Tokyo",
                                                           date: "2020-08-01",
                                                           time: "3 hours",
                                                           detail: "very far",
                                                           notice: "very far"
                                                           ] } }
      }.to change(Destination, :count).by(1)
      follow_redirect!
      expect(response).to render_template ('destinations/show')
    end
    
    it "Scheduleも同時に増えること" do
       expect {
        post destinations_path, params: { destination: { to: "Tokyo",
                                                         from: "Hiroshima",
                                                         time: "4 hours",
                                                         date: "2020/8/1",
                                                         outline: "very far",
                                                         detail: "Take 'Nozomi' bullet train",
                                                         notice: "Get off Shinagawa station",
                                                         reference: "https://jr-central.co.jp/",
                                                         picture: picture,
                                                         schedules_attributes: [
                                                           to: "Okinawa",
                                                           from: "Tokyo",
                                                           date: "2020-08-01",
                                                           time: "3 hours",
                                                           detail: "very far",
                                                           notice: "very far"
                                                           ] } }
      }.to change(Schedule, :count).by(1)
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
                                                         reference: "https://jr-central.co.jp/",
                                                         picture: picture,
                                                         schedules_attributes: [
                                                           to: "Okinawa",
                                                           from: "Tokyo",
                                                           date: "2020-08-01",
                                                           time: "3 hours",
                                                           detail: "very far",
                                                           notice: "very far"
                                                           ] } }
      }.not_to change(Destination, :count)
      expect(response).to render_template ('destinations/new')
    end
    
    context "Scheduleがない状態で投稿" do
      it "正常に投稿できること" do
        expect {
        post destinations_path, params: { destination: { to: "Tokyo",
                                                         from: "Hiroshima",
                                                         time: "4 hours",
                                                         date: "2020/8/1",
                                                         outline: "very far",
                                                         detail: "Take 'Nozomi' bullet train",
                                                         notice: "Get off Shinagawa station",
                                                         reference: "https://jr-central.co.jp/",
                                                         picture: picture } }
        }.to change(Destination, :count).by(1)
      end
      
      it "Scheduleは増えないこと" do
        expect {
        post destinations_path, params: { destination: { to: "Tokyo",
                                                         from: "Hiroshima",
                                                         time: "4 hours",
                                                         date: "2020/8/1",
                                                         outline: "very far",
                                                         detail: "Take 'Nozomi' bullet train",
                                                         notice: "Get off Shinagawa station",
                                                         reference: "https://jr-central.co.jp/",
                                                         picture: picture } }
        }.not_to change(Schedule, :count)
      end  
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
