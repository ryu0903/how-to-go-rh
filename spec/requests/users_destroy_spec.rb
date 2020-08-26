require 'rails_helper'

RSpec.describe "ユーザーの削除", type: :request do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }
  
  context "管理者ユーザーの場合" do
    it "ユーザーを削除後、ユーザー一覧ページへリダイレクト" do
      login_for_request(admin_user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to users_url
      follow_redirect!
      expect(response).to render_template('users/index')
    end
  end
  
  context "管理者ユーザーでない場合" do
    it "自身を削除後、トップページへリダイレクト" do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to root_url
    end
  end
  
  context "非管理者ユーザーが他のユーザーを削除しようとした場合" do
    it "トップページへリダイレクト" do
      login_for_request(user)
      expect {
        delete user_path(other_user)
      }.not_to change(User, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_url
    end
  end
  
  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクト" do
      expect {
        delete user_path(user)
      }.not_to change(User, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

end
