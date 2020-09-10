require 'rails_helper'

RSpec.describe "Destinations", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:destination) { create(:destination, :picture, user: user) }
  let!(:destination2) { create(:destination, :picture, :schedules, user: user) }
  
 
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
       expect(page).to have_content "Reference"
      end
    end
  
    context "Destination登録" do
      it "有効なデータ登録、フラッシュメッセージ確認" do
        fill_in "d-to", with: "Tokyo"
        fill_in "d-from", with: "Hiroshima"
        fill_in "d-time", with: "4 hours"
        fill_in "d-date", with: "2020/8/1"
        fill_in "d-outline", with: "very far"
        fill_in "d-detail", with: "Take Shinkansen"
        fill_in "d-notice", with: "Get off Shinagawa"
        fill_in "d-reference", with: "https://jr-central.co.jp/"
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg", match: :first
        click_on 'd-button'
        expect(page).to have_content "投稿しました！"
      end
    
      it "無効なデータ登録、フラッシュメッセージ確認" do
        fill_in "d-to", with: ""
        fill_in "d-from", with: "Hiroshima"
        fill_in "d-time", with: "4 hours"
        fill_in "d-date", with: "2020/8/1"
        fill_in "d-outline", with: "very far"
        fill_in "d-detail", with: "Take Shinkansen"
        fill_in "d-notice", with: "Get off Shinagawa"
        fill_in "d-reference", with: "https://jr-central.co.jp/"
        click_on 'd-button'
        expect(page).to have_content "投稿に失敗しました。"
      end
      
        
      it "画像なしで登録した場合、デフォルト画像を表示" do
        fill_in "d-to", with: "Tokyo"
        fill_in "d-from", with: "Hiroshima"
        fill_in "d-time", with: "4 hours"
        fill_in "d-date", with: "2020/8/1"
        fill_in "d-outline", with: "very far"
        fill_in "d-detail", with: "Take Shinkansen"
        fill_in "d-notice", with: "Get off Shinagawa"
        fill_in "d-reference", with: "https://jr-central.co.jp/"
        click_on 'd-button'
        expect(page).to have_content "投稿しました！"
        expect(destination.picture.url).to include "test.jpg"
      end
    end
  end
  
  describe "Schedule登録" do  
    before do
      login_for_system(user)
      visit new_destination_path
      click_on "Schedule"
    end
    
    context "ページレイアウト" do
      it "追加ボタン、削除ボタン確認" do
        expect(page).to have_link "Remove Schedule"
        expect(page).to have_link "Add Schedule"
      end
      
      it "削除ボタンを押すとScheduleが削除されること", js: true do
        click_link "Remove Schedule"
        expect(page).not_to have_css ".s-f-picture"
        expect(page).not_to have_css ".s-f-to"
        expect(page).not_to have_css ".s-f-from"
        expect(page).not_to have_css ".s-f-date"
        expect(page).not_to have_css ".s-f-time"
        expect(page).not_to have_css ".s-f-detail"
        expect(page).not_to have_css ".s-f-notice"
      end
      
      it "追加ボタンを押すとフォームが追加されること", js: true do
        click_link "Remove Schedule"
        expect(page).not_to have_css ".s-f-picture"
        expect(page).not_to have_css ".s-f-to"
        expect(page).not_to have_css ".s-f-from"
        expect(page).not_to have_css ".s-f-date"
        expect(page).not_to have_css ".s-f-time"
        expect(page).not_to have_css ".s-f-detail"
        expect(page).not_to have_css ".s-f-notice"
        click_link 'Add Schedule'
        expect(page).to have_css ".s-f-picture"
        expect(page).to have_css ".s-f-to"
        expect(page).to have_css ".s-f-from"
        expect(page).to have_css ".s-f-date"
        expect(page).to have_css ".s-f-time"
        expect(page).to have_css ".s-f-detail"
        expect(page).to have_css ".s-f-notice"
      end
    end
    
    context "Schedule登録" do  
      it "有効なデータ登録、フラッシュメッセージ確認" do
        fill_in "s-to", with: "Tokyo"
        fill_in "s-from", with: "Hiroshima"
        fill_in "s-date", with: "2020/8/1"
        fill_in "s-outline", with: "very far"
        fill_in "s-f-to", with: "Tokyo"
        fill_in "s-f-from", with: "Hiroshima"
        fill_in "s-f-date", with: "2020/8/1"
        fill_in "s-f-time", with: "4 hours"
        fill_in "s-f-detail", with: "Take Shinkansen"
        fill_in "s-f-notice", with: "Get off Shinagawa"
        fill_in "s-reference", with: "https://jr-central.co.jp/"
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg", match: :first
        click_on 's-button'
        expect(page).to have_content "投稿しました！"
      end
    
      it "無効なデータ登録、フラッシュメッセージ確認" do
        fill_in "s-to", with: ""
        fill_in "s-from", with: "Hiroshima"
        fill_in "s-date", with: "2020/8/1"
        fill_in "s-outline", with: "very far"
        fill_in "s-f-to", with: "Tokyo"
        fill_in "s-f-from", with: "Hiroshima"
        fill_in "s-f-date", with: "2020/8/1"
        fill_in "s-f-time", with: "4 hours"
        fill_in "s-f-detail", with: "Take Shinkansen"
        fill_in "s-f-notice", with: "Get off Shinagawa"
        fill_in "s-reference", with: "https://jr-central.co.jp/"
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg", match: :first
        click_on 's-button'
        expect(page).to have_content "投稿に失敗しました。"
      end
      
        
      it "画像なしで登録した場合、デフォルト画像を表示" do
        fill_in "s-to", with: "Tokyo"
        fill_in "s-from", with: "Hiroshima"
        fill_in "s-date", with: "2020/8/1"
        fill_in "s-outline", with: "very far"
        fill_in "s-f-to", with: "Tokyo"
        fill_in "s-f-from", with: "Hiroshima"
        fill_in "s-f-date", with: "2020/8/1"
        fill_in "s-f-time", with: "4 hours"
        fill_in "s-f-detail", with: "Take Shinkansen"
        fill_in "s-f-notice", with: "Get off Shinagawa"
        fill_in "s-reference", with: "https://jr-central.co.jp/"
        click_on 's-button'
        expect(page).to have_content "投稿しました！"
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
        expect(page).to have_content '投稿を削除しました。'
      end
    end
    
    context "コメントの登録・削除", js: true do
      it "自分のコメントの登録・削除が正常に行われること" do
        login_for_system(user)
        visit destination_path(destination)
        fill_in "comment_content", with: "こんにちは"
        click_button "Comment"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_content user.name
          expect(page).to have_content "こんにちは"
        end
        link = find('.comment-delete-button')
        link.click
        expect(page).not_to have_content "こんにちは"
      end
      
      context "別のユーザーのコメントの場合" do
        let!(:comment) { create(:comment, user: user, destination: destination) }
        it "別ユーザーのコメントには削除ボタンがないこと" do
          login_for_system(other_user)
          visit destination_path(destination)
            
          within find("#comment-#{comment.id}") do
            expect(page).to have_content "私も行ってみたいです"
            expect(page).to have_content comment.user.name
            expect(page).not_to have_css ('.comment-delete-button')
          end
        end
      end
    end
  end
  
   describe "Schedule詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit destination_path(destination2)
      end
      
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title("Schedule: #{destination2.to}")
      end
      
      it "情報が表示されること" do
        expect(page).to have_link destination2.user.name, href: user_path(destination2.user)
        expect(page).to have_content destination2.to
        expect(page).to have_content destination2.from
        expect(page).to have_content destination2.date
        expect(page).to have_content destination2.outline
        expect(page).to have_content destination2.schedules.first.to
        expect(page).to have_content destination2.schedules.first.from
        expect(page).to have_content destination2.schedules.first.date
        expect(page).to have_content destination2.schedules.first.time
        expect(page).to have_content destination2.schedules.first.detail
        expect(page).to have_content destination2.schedules.first.notice
        expect(page).to have_content destination2.reference
        expect(page).to have_link nil, href: destination_path(destination2), class: "destination-picture"
      end
    end
    
    context "投稿の削除", js: true do 
      it "削除成功のメッセージ確認" do
        login_for_system(user)
        visit destination_path(destination2)
        click_link 'Delete'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿を削除しました。'
      end
    end
    
    context "コメントの登録・削除", js: true do
      it "自分のコメントの登録・削除が正常に行われること" do
        login_for_system(user)
        visit destination_path(destination2)
        fill_in "comment_content", with: "こんにちは"
        click_button "Comment"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_content user.name
          expect(page).to have_content "こんにちは"
        end
        link = find('.comment-delete-button')
        link.click
        expect(page).not_to have_content "こんにちは"
      end
      
      context "別のユーザーのコメントの場合" do
        let!(:comment) { create(:comment, user: user, destination: destination2) }
        it "別ユーザーのコメントには削除ボタンがないこと" do
          login_for_system(other_user)
          visit destination_path(destination2)
            
          within find("#comment-#{comment.id}") do
            expect(page).to have_content "私も行ってみたいです"
            expect(page).to have_content comment.user.name
            expect(page).not_to have_css ('.comment-delete-button')
          end
        end
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
        expect(page).to have_content "Reference"
      end
    end
    
    context "Destination編集" do
      it "有効なデータ更新、フラッシュメッセージ確認" do
        fill_in "d-e-to", with: "Tokyo"
        fill_in "d-e-from", with: "Hiroshima"
        fill_in "d-e-time", with: "4 hours"
        fill_in "d-e-date", with: "2020-08-01"
        fill_in "d-e-outline", with: "very far"
        fill_in "d-e-detail", with: "Take Shinkansen"
        fill_in "d-e-notice", with: "Get off Shinagawa"
        fill_in "d-e-reference", with: "https://jr-central.co.jp/"
        click_on "d-e-button"
        expect(page).to have_content "投稿を更新しました！"
        expect(destination.reload.to).to eq "Tokyo"
        expect(destination.reload.from).to eq "Hiroshima"
        expect(destination.reload.time).to eq "4 hours"
        expect(destination.reload.date).to eq "2020-08-01"
        expect(destination.reload.outline).to eq "very far"
        expect(destination.reload.detail).to eq "Take Shinkansen"
        expect(destination.reload.notice).to eq "Get off Shinagawa"
        expect(destination.reload.reference).to eq "https://jr-central.co.jp/"
        expect(destination.reload.picture.url).to include "test.jpg"
      end  
      
      it "無効な更新" do
        fill_in "d-e-to", with: "", match: :first
        click_button "d-e-button"
        expect(page).to have_content "更新に失敗しました。"
        expect(destination.reload.to).not_to eq ""
      end
    end
  end
  
  describe "Schedule編集ページ" do
    before do
      login_for_system(user)
      visit destination_path(destination2)
      click_link "Edit"
    end
    
    context "Schedule編集" do
      it "有効な更新、フラッシュメッセージ確認" do
        fill_in "s-e-to", with: "Tokyo"
        fill_in "s-e-from", with: "Hiroshima"
        fill_in "s-e-date", with: "2020-08-01"
        fill_in "s-e-outline", with: "very far"
        fill_in "s-f-to", with: "Tokyo"
        fill_in "s-f-from", with: "Hiroshima"
        fill_in "s-f-date", with: "2020-08-01"
        fill_in "s-f-time", with: "4 hours"
        fill_in "s-f-detail", with: "Take Shinkansen"
        fill_in "s-f-notice", with: "Get off Shinagawa"
        fill_in "s-e-reference", with: "https://jr-central.co.jp/"
        click_on 's-e-button'
        expect(page).to have_content "投稿を更新しました！"
        expect(destination2.reload.to).to eq "Tokyo"
        expect(destination2.reload.from).to eq "Hiroshima"
        expect(destination2.reload.date).to eq "2020-08-01"
        expect(destination2.reload.outline).to eq "very far"
        expect(destination2.reload.schedules.first.to).to eq "Tokyo"
        expect(destination2.reload.schedules.first.from).to eq "Hiroshima"
        expect(destination2.reload.schedules.first.date).to eq "2020-08-01"
        expect(destination2.reload.schedules.first.time).to eq "4 hours"
        expect(destination2.reload.schedules.first.detail).to eq "Take Shinkansen"
        expect(destination2.reload.schedules.first.notice).to eq "Get off Shinagawa"
        expect(destination2.reload.reference).to eq "https://jr-central.co.jp/"
        expect(destination2.reload.picture.url).to include "test.jpg"
      end
    
      it "無効な更新、フラッシュメッセージ確認" do
        fill_in "s-e-to", with: ""
        click_on 's-e-button'
        expect(page).to have_content "更新に失敗しました。"
      end
    end
    
    context "投稿の削除", js: true do
      it "削除後、削除成功のメッセージ確認" do
        click_link "Delete"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿を削除しました。'
      end
    end
  end
end
