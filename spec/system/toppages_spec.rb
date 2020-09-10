require 'rails_helper'

RSpec.describe "Toppages", type: :system do
  
  describe "トップページ" do
    
    before do
      visit root_path
    end
    
    it "How to Goの文字列の確認" do
      expect(page).to have_content 'How to Go'
    end
    
    it "タイトルの表示確認" do
      expect(page).to have_title full_title
    end
    
     it "正しいタイトルの表示確認" do
      expect(page).to have_title full_title
    end
    
    context "Destinationフィード", js: true do
      let!(:user) { create(:user) }
      let!(:destination) { create(:destination, user: user) }
      
      it "ページネーション確認" do
        login_for_system(user)
        create_list(:destination, 10, user: user)
        visit root_path
        expect(page).to have_content "Everyone's Posts"
        expect(page).to have_css ".pagination"
        Destination.take(5).each do |d|
          expect(page).to have_link d.user.name, href: user_path(d.user)
        end
      end
      
      it "投稿を削除後、削除成功のメッセージ確認" do
        login_for_system(user)
        visit root_path
        click_link "Delete"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿を削除しました。'
      end
    end
    
  end
end