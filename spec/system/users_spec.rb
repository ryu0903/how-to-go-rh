require 'rails_helper'

RSpec.describe "Users", type: :system do
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
  end 
end
  

