require 'rails_helper'

RSpec.describe "通知機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  let!(:other_destination) { create(:destination, user: other_user) }
  
  context "通知一覧ページの表示" do
    context "ログインしているユーザーの場合" do
      before do 
        login_for_request(user)
      end
      
      it "正常なレスポンス" do
        get notifications_path
        expect(response).to render_template('notifications/index')
      end
    end
    
    context "ログインしていないユーザーの場合" do
      it "ログインページへリダイレクト" do
        get notifications_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end
  
  context "通知処理" do
    before do
      login_for_request(user)
    end
    
    context "自分以外のユーザーの投稿に対して" do
      it "お気に入り登録によって通知を作成" do
        post "/favorites/#{other_destination.id}/create"
        expect(user.reload.notification).to be_falsey
        expect(other_user.reload.notification).to be_truthy
      end
      
      it "コメント作成によって通知を作成" do
        post comments_path, params: { destination_id: other_destination.id,
                                      comment: { content: "こんにちは" } }
        expect(user.reload.notification).to be_falsey
        expect(other_user.reload.notification).to be_truthy
      end
      
    end
    
    context "自分の投稿に対して" do
      it "お気に入り登録によって通知が作成されないこと" do
        post "/favorites/#{destination.id}/create"
        expect(user.reload.notification).to be_falsey
      end
      
      it "コメント作成によって通知が作成されないこと" do
        post comments_path, params: { destination_id: destination.id,
                                      comment: { content: "こんにちは" } }
        expect(user.reload.notification).to be_falsey
      end
    end
    
  end
end
