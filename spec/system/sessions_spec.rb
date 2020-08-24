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
      
    end
  end
  
end
