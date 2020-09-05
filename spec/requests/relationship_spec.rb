require 'rails_helper'

RSpec.describe "ユーザーフォロー機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  
  context "ログインしている場合" do
    before do
      login_for_request(user)
    end
    
    it "フォローができること" do
      expect {
        post relationships_path, params: { follow_id: other_user.id }
      }.to change(user.followings, :count).by(1)
    end
    
    it "Ajaxによるフォローができること" do
      expect {
        post relationships_path, xhr: true, params: { follow_id: other_user.id }
      }.to change(user.followings, :count).by(1)
    end
    
    it "フォロー解除ができること" do
      user.follow(other_user)
      relationship = user.follow_relationships.find_by(follow_id: other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(user.followings, :count).by(-1)
    end
    
    it "Ajaxによるフォロー解除ができること" do
      user.follow(other_user)
      relationship = user.follow_relationships.find_by(follow_id: other_user.id)
      expect {
        delete relationship_path(relationship), xhr: true
      }.to change(user.followings, :count).by(-1)
    end
  end
  
  context "ログインしていない場合" do
    it "Followページへ飛ぶとログインページへリダイレクト" do
      get followings_user_path(user)
      expect(response).to redirect_to login_path
    end
    
    it "followerページへ飛ぶとログインページへリダイレクト" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
    
    it "createアクションを実行した場合、ログインページへリダイレクト" do
      expect {
        post relationships_path
      }.not_to change(Relationship, :count)
      expect(response). to redirect_to login_path
    end
    
    it "destroyアクションを実行した場合、ログインページへリダイレクト" do
      expect {
        delete relationship_path(user)
      }.not_to change(Relationship, :count)
      expect(response). to redirect_to login_path
    end  
  end
end
