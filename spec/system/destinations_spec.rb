require 'rails_helper'

RSpec.describe "Destinations", type: :system do
  let!(:user) { create(:user) }
  let!(:destination) { create(:destination, :picture, user: user) }
  
  describe "Destination登録ページ" do
    before do
      login_for_system(user)
      visit new_destination_path
    end
  
    context "ページレイアウト" do
      it "「New Post」の文字列確認" do
        expect(page).to have_content "New Post"
      end
      
      it "正しいタイトルの確認" do
        expect(page).to have_title full_title('New Post')
      end
      
      it "入力フォームのラベル確認" do
       expect(page).to have_content "Destination"
       expect(page).to have_content "From"
       expect(page).to have_content "Time"
       expect(page).to have_content "Date"
       expect(page).to have_content "Outline"
       expect(page).to have_content "Detail"
       expect(page).to have_content "Notice/Advice"
      end
    end
  
    context "Destination登録" do
      it "有効なデータ登録、フラッシュメッセージ確認" do
        fill_in "Destination", with: "Tokyo"
        fill_in "From", with: "Hiroshima"
        fill_in "Time", with: "4 hours"
        fill_in "Date", with: "2020/8/1"
        fill_in "Outline", with: "very far"
        fill_in "Detail", with: "Take Shinkansen"
        fill_in "Notice/Advice", with: "Get off Shinagawa"
        fill_in "Reference", with: "https://jr-central.co.jp/"
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg"
        click_button "Post"
        expect(page).to have_content "Your Destination Posted!"
      
      end
    
      it "無効なデータ登録、フラッシュメッセージ確認" do
        fill_in "Destination", with: ""
        fill_in "From", with: "Hiroshima"
        fill_in "Time", with: "4 hours"
        fill_in "Date", with: "2020/8/1"
        fill_in "Outline", with: "very far"
        fill_in "Detail", with: "Take Shinkansen"
        fill_in "Notice/Advice", with: "Get off Shinagawa"
        fill_in "Reference", with: "https://jr-central.co.jp/"
        click_button "Post"
        expect(page).to have_content "Post failed"
      end
      
        
      it "画像なしで登録した場合、デフォルト画像を表示" do
        fill_in "Destination", with: "Tokyo"
        fill_in "From", with: "Hiroshima"
        fill_in "Time", with: "4 hours"
        fill_in "Date", with: "2020/8/1"
        fill_in "Outline", with: "very far"
        fill_in "Detail", with: "Take Shinkansen"
        fill_in "Notice/Advice", with: "Get off Shinagawa"
        fill_in "Reference", with: "https://jr-central.co.jp/"
        click_button "Post"
        expect(page).to have_content "Your Destination Posted!"
        expect(destination.picture.url).to include "test.jpg"
      end
    end
  end
  
  describe "Destination詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit destination_path(destination)
      end
      
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title("Destination: #{destination.to}")
      end
      
      it "情報が表示されること" do
        expect(page).to have_link destination.user.name, href: user_path(destination.user)
        expect(page).to have_content destination.to
        expect(page).to have_content destination.from
        expect(page).to have_content destination.time
        expect(page).to have_content destination.date
        expect(page).to have_content destination.outline
        expect(page).to have_content destination.detail
        expect(page).to have_content destination.notice
        expect(page).to have_content destination.reference
        expect(page).to have_link nil, href: destination_path(destination), class: "destination-picture"
      end
    end
    
    context "投稿の削除", js: true do 
      it "削除成功のメッセージ確認" do
        login_for_system(user)
        visit destination_path(destination)
        click_link 'Delete'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Your Post Deleted'
      end
    end
  end
  
  describe "Destination編集ページ" do
    before do
      login_for_system(user)
      visit destination_path(destination)
      click_link "Edit"
    end
    
    context "ページレイアウト" do
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title("Edit: #{destination.to}")
      end
      
      it "ラベル確認" do
        expect(page).to have_content "Destination"
        expect(page).to have_content "From"
        expect(page).to have_content "Time"
        expect(page).to have_content "Date"
        expect(page).to have_content "Outline"
        expect(page).to have_content "Detail"
        expect(page).to have_content "Notice/Advice"
      end
    end
    
    context "Destination編集" do
      it "有効なデータ更新、フラッシュメッセージ確認" do
        fill_in "Destination", with: "Tokyo"
        fill_in "From", with: "Hiroshima"
        fill_in "Time", with: "4 hours"
        fill_in "Date", with: "2020-08-01"
        fill_in "Outline", with: "very far"
        fill_in "Detail", with: "Take Shinkansen"
        fill_in "Notice/Advice", with: "Get off Shinagawa"
        fill_in "Reference", with: "https://jr-central.co.jp/"
        click_button "Update"
        expect(page).to have_content "Your Post Updated!"
        expect(destination.reload.to).to eq "Tokyo"
        expect(destination.reload.from).to eq "Hiroshima"
        expect(destination.reload.time).to eq "4 hours"
        expect(destination.reload.date.to_s).to eq "2020-08-01"
        expect(destination.reload.outline).to eq "very far"
        expect(destination.reload.detail).to eq "Take Shinkansen"
        expect(destination.reload.notice).to eq "Get off Shinagawa"
        expect(destination.reload.reference).to eq "https://jr-central.co.jp/"
        expect(destination.reload.picture.url).to include "test.jpg"
      end  
      
      it "無効な更新" do
        fill_in "Destination", with: ""
        click_button "Update"
        expect(page).to have_content "Update failed"
        expect(destination.reload.to).not_to eq ""
      end
    end
    
    context "投稿の削除", js: true do
      it "削除後、削除成功のメッセージ確認" do
        click_link "Delete"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Your Post Deleted'
      end
    end
  end
end
