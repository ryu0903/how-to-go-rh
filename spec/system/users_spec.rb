require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  
  describe "ユーザー一覧ページ" do
    it "ページネーション、削除ボタンの確認" do
      create_list(:user, 31)
      login_for_system(user)
      visit users_path
      expect(page).to have_css ".pagination"
      
      User.all.page(1).each do |u|
        expect(page).to have_link u.name, href: user_path(u)
      end
    end
  end
    
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
        login_for_system(user)
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
      
      it "プロフィール編集ページへのリンク" do
        expect(page).to have_link 'Edit Profile', href: edit_user_path(user)
      end
      
    end
  end
  
  describe "プロフィール編集ページ" do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link 'Edit Profile'
    end
    
    context "ページレイアウト" do
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title('Edit Profile')
      end
    end
    
    it "有効なプロフィール更新" do
      fill_in "Name", with: "Example User for edit"
      fill_in "Email", with: "edit-user@example.com"
      fill_in "Introduction", with: "こんばんは"
      click_button "Update"
      
      expect(page).to have_content "Profile Updated"
      expect(user.reload.name).to eq "Example User for edit"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduce).to eq "こんばんは"
    end
    
    it "無効なプロフィール更新" do
      fill_in "Name", with: ""
      fill_in "Email", with: ""
      click_button "Update"
      
      expect(page).to have_content "Profile update failed"
      expect(page).to have_content 'Nameを入力してください'
      expect(page).to have_content 'Emailを入力してください'
      expect(page).to have_content 'Emailは不正な値です'
      expect(user.reload.email).not_to eq ""
    end
    
  end
  
end
