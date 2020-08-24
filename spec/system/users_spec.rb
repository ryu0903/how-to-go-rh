require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  
  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end
    
    context "ページレイアウト" do
      it "Sing Upの文字列の確認" do
        expect(page).to have_content 'Sign Up'
      end
      
      it "正しいタイトルの確認" do
        expect(page).to have_title full_title('Sign Up')
      end
    end
    
    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うと登録成功のフラッシュが表示されること" do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password(more than 6 letters)", with: "password"
        fill_in "Password Confirmation", with: "password"
        click_button "Sign Up"
        expect(page).to have_content "Welcome to How to Go!"
      end
      
      it "無効なユーザーでユーザー登録を行うと登録失敗のフラッシュが表示されること" do
        fill_in "Name", with: ""
        fill_in "Email", with: "user@example.com"
        fill_in "Password(more than 6 letters)", with: "password"
        fill_in "Password Confirmation", with: "pass"
        click_button "Sign Up"
        expect(page).to have_content "Nameを入力してください"
        expect(page).to have_content "Password confirmationとPasswordの入力が一致しません"
      end
    end
  end 
  
  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        visit user_path(user)
      end
    
      it "「Profile」の文字列の確認" do
        expect(page).to have_content 'Profile'
      end
    
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title('Profile')
      end
    
      it "ユーザー情報の表示確認" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduce
      end
    end
  end
end
