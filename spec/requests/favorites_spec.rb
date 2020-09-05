require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  let!(:user) { create(:user) }
  let!(:destination) { create(:destination) }
  
  context "お気に入り登録処理" do
    context "ログインしていない場合" do
      it "お気に入り登録は実行できず、ログインページへリダイレクトすること" do
        expect { 
          post "/favorites/#{destination.id}/create"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
      
      it "お気に入り解除は実行できず、ログインページへリダイレクトすること" do
        expect { 
          delete "/favorites/#{destination.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end
    
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end
      
      it "お気に入り登録ができること" do
        expect {
          post "/favorites/#{destination.id}/create"
        }.to change(user.favorites, :count).by(1)
      end
      
      it "Ajaxによるお気に入り登録ができること" do
        expect {
          post "/favorites/#{destination.id}/create", xhr: true
        }.to change(user.favorites, :count).by(1)
      end
      
      it "お気に入り解除ができること" do
        user.favorite(destination)
        expect { 
          delete "/favorites/#{destination.id}/destroy"
        }.to change(user.favorites, :count).by(-1)
      end
      
      it "お気に入り解除ができること" do
        user.favorite(destination)
        expect { 
          delete "/favorites/#{destination.id}/destroy"
        }.to change(user.favorites, :count).by(-1)
      end
      
      it "Ajaxによるお気に入り解除ができること" do
        user.favorite(destination)
        expect { 
          delete "/favorites/#{destination.id}/destroy", xhr: true
        }.to change(user.favorites, :count).by(-1)
      end
    end
    
    context "お気に入り一覧ページ" do
      context "ログインしている場合" do
        it "ログインしている場合" do
          login_for_request(user)
          get favorites_user_path(user)
          expect(response).to have_http_status "200"
          expect(response).to render_template('users/favorites')
        end
      end
      
      context "ログインしていない場合" do  
        it "ログイン画面へリダイレクト" do
          get favorites_user_path(user)
          expect(response).to have_http_status "302"
          expect(response).to redirect_to login_path
        end
      end
    end
    
  end
  
end
