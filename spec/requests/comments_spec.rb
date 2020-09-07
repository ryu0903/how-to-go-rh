require 'rails_helper'

RSpec.describe "コメント機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:destination) { create(:destination) }
  let!(:comment) { create(:comment, user_id: user.id, destination: destination) }
  
  context "コメントの登録" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end
      
      it "有効な内容のコメントが登録できること" do
        expect { 
          post comments_path, params: { destination_id: destination.id,
                                        comment: { content: "こんにちは" } }
          }.to change(destination.comments, :count).by(1)
      end
      
        it "Ajaxにより有効な内容のコメントが登録できること" do
        expect { 
          post comments_path, params: { destination_id: destination.id,
                                        comment: { content: "こんにちは" }, xhr: true }
          }.to change(destination.comments, :count).by(1)
      end
      
    end
    
    context "ログインしていない場合" do
      it "コメントは登録できず、ログインページへリダイレクト" do
        expect {
          post comments_path, params: { destination_id: destination.id,
                                       comment: { content: "こんにちは" } }
        }.not_to change(destination.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
  
  context "コメントの登録" do
    context "ログインしている場合" do
     context "コメントを作成したユーザーの場合" do
      it "削除ができること" do
        login_for_request(user)
        expect {
          delete comment_path(comment)
        }.to change(destination.comments, :count).by(-1)
      end
      
       it "Ajaxによる削除ができること" do
        login_for_request(user)
        expect {
          delete comment_path(comment), xhr: true
        }.to change(destination.comments, :count).by(-1)
      end
    end
      
      context "コメントを作成したユーザーでない場合" do
        it "削除ができないこと" do
          login_for_request(other_user)
          expect {
            delete comment_path(comment)
          }.not_to change(destination.comments, :count)
        end
      end
    end
    
    context "ログインしていない場合" do
      it "コメントの削除はできず、ログインページへリダイレクト" do
        expect {
          delete comment_path(comment)
        }.not_to change(destination.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

end
