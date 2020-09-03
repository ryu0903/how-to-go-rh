require 'rails_helper'

RSpec.describe "ユーザーフォロー機能", type: :request do
  let!(:user) { create(:user) }
  describe "ログインしていない場合" do
    it "Followページへ飛ぶとログインページへリダイレクト" do
      get followings_user_path(user)
      expect(response).to redirect_to login_path
    end
    
    it "followerページへ飛ぶとログインページへリダイレクト" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
