require 'rails_helper'

RSpec.describe "Destinations", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
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
        fill_in "Destination", with: "Tokyo", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Time", with: "4 hours", match: :first
        fill_in "Date", with: "2020/8/1", match: :first
        fill_in "Outline", with: "very far", match: :first
        fill_in "Detail", with: "Take Shinkansen", match: :first
        fill_in "Notice/Advice", with: "Get off Shinagawa", match: :first
        fill_in "Reference", with: "https://jr-central.co.jp/", match: :first
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg", match: :first
        click_button "Post", match: :first
        expect(page).to have_content "投稿しました！"
      
      end
    
      it "無効なデータ登録、フラッシュメッセージ確認" do
        fill_in "Destination", with: "", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Time", with: "4 hours", match: :first
        fill_in "Date", with: "2020/8/1", match: :first
        fill_in "Outline", with: "very far", match: :first
        fill_in "Detail", with: "Take Shinkansen", match: :first
        fill_in "Notice/Advice", with: "Get off Shinagawa", match: :first
        fill_in "Reference", with: "https://jr-central.co.jp/", match: :first
        click_button "Post", match: :first
        expect(page).to have_content "投稿に失敗しました。"
      end
      
        
      it "画像なしで登録した場合、デフォルト画像を表示" do
        fill_in "Destination", with: "Tokyo", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Time", with: "4 hours", match: :first
        fill_in "Date", with: "2020/8/1", match: :first
        fill_in "Outline", with: "very far", match: :first
        fill_in "Detail", with: "Take Shinkansen", match: :first
        fill_in "Notice/Advice", with: "Get off Shinagawa", match: :first
        fill_in "Reference", with: "https://jr-central.co.jp/", match: :first
        click_button "Post", match: :first
        expect(page).to have_content "投稿しました！"
        expect(destination.picture.url).to include "test.jpg"
      end
    end
    
    context "Schedule登録" do
      before do
        click_on "Schedule"
      end
      
      it "入力フォームのラベル確認" do
        expect(page).to have_content "Destination"
        expect(page).to have_content "From"
        expect(page).to have_content "Date"
        expect(page).to have_content "Outline"
      end
      
      it "有効なデータ登録、フラッシュメッセージ確認" do
        fill_in "Destination", with: "Tokyo", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Date", with: "2020/8/1", match: :first
        fill_in "Outline", with: "very far", match: :first
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg", match: :first
        click_button "Post", match: :first
        expect(page).to have_content "投稿しました！"
      end
    
      it "無効なデータ登録、フラッシュメッセージ確認" do
        fill_in "Destination", with: "", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Date", with: "2020/8/1", match: :first
        fill_in "Outline", with: "very far", match: :first
        attach_file "destination[picture]", "#{Rails.root}/spec/fixtures/test.jpg", match: :first
        click_button "Post", match: :first
        expect(page).to have_content "投稿に失敗しました。"
      end
      
        
      it "画像なしで登録した場合、デフォルト画像を表示" do
        fill_in "Destination", with: "Tokyo", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Date", with: "2020/8/1", match: :first
        fill_in "Outline", with: "very far", match: :first
        click_button "Post", match: :first
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
  
  describe "Destination編集ページ" do
    before do
      login_for_system(user)
      visit destination_path(destination)
      click_link "Edit"
      click_on 'Destination'
    end
    
    context "ペー���レイアウト" do
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
        fill_in "Destination", with: "Tokyo", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Time", with: "4 hours", match: :first
        fill_in "Date", with: "2020-08-01", match: :first
        fill_in "Outline", with: "very far", match: :first
        fill_in "Detail", with: "Take Shinkansen", match: :first
        fill_in "Notice/Advice", with: "Get off Shinagawa", match: :first
        fill_in "Reference", with: "https://jr-central.co.jp/", match: :first
        click_button "Update", match: :first
        expect(page).to have_content "投稿を更新しました！"
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
        fill_in "Destination", with: "", match: :first
        click_button "Update", match: :first
        expect(page).to have_content "更新に失敗しました。"
        expect(destination.reload.to).not_to eq ""
      end
    end
    
     context "Schedule編集" do
      before do
        click_on "Schedule"
      end
      
      it "入力フォームのラベル確認" do
        expect(page).to have_content "Destination"
        expect(page).to have_content "From"
        expect(page).to have_content "Date"
        expect(page).to have_content "Outline"
      end
      
      it "有効な更新、フラッシュメッセージ確認" do
        fill_in "Destination", with: "Tokyo", match: :first
        fill_in "From", with: "Hiroshima", match: :first
        fill_in "Time", with: "", match: :first
        fill_in "Date", with: "2020-08-01", match: :first
        fill_in "Outline", with: "very far", match: :first
        fill_in "Detail", with: "", match: :first
        fill_in "Notice/Advice", with: "", match: :first
        fill_in "Reference", with: "", match: :first
        click_button "Update", match: :first
        expect(page).to have_content "投稿を更新しました！"
        expect(destination.reload.to).to eq "Tokyo"
        expect(destination.reload.from).to eq "Hiroshima"
        expect(destination.reload.time).not_to eq "4 hours"
        expect(destination.reload.date).to eq "2020-08-01"
        expect(destination.reload.outline).to eq "very far"
        expect(destination.reload.detail).not_to eq "Take Shinkansen"
        expect(destination.reload.notice).not_to eq "Get off Shinagawa"
        expect(destination.reload.reference).not_to eq "https://jr-central.co.jp/"
        expect(destination.reload.picture.url).to include "test.jpg"
      end
    
      it "無効な更新、フラッシュメッセージ確認" do
        fill_in "Destination", with: "", match: :first
        click_button "Update", match: :first
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
