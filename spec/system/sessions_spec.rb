require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }
  
  before do
    visit login_path
  end
  
  describe "ログインページ" do
    context "ページレイアウト" do
    
      it "「Log In」の文字列の確認" do
        expect(page).to have_content "Log In"
      end
      
      it "正しいタイトルの確認" do
        expect(page).to have_title full_title("Log In")
      end
      
      it "「Keep Login」のチェックボックスの表示確認" do
        expect(page).to have_content 'Keep Login'
        expect(page).to have_css 'input#session_remember_me'
      end
    end
    
    context "ログイン処理" do
      it "無効なユーザーでのログイン失敗処理" do
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "pass"
        click_button "Log In"
        expect(page).to have_content "Login failed"
      end
      
      it "ヘッダーのログイン前後の表示確認" do
        expect(page).to have_link 'Sign Up', href: signup_path
        expect(page).to have_link 'Log In', href: login_path
        expect(page).not_to have_link 'Log Out', href: logout_path
        
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log In"
        
        expect(page).to have_link 'New Post', href: new_destination_path 
        expect(page).to have_link 'Users', href: users_path 
        expect(page).to have_link 'Profile', href: user_path(user)
        expect(page).to have_link 'Favorites', href: '#'
        expect(page).to have_link 'Log Out', href: logout_path
        expect(page).not_to have_link 'Log In', href: login_path
      end
    end
  end
end
