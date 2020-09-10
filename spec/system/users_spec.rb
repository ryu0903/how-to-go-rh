require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  

  
  
  describe "ユーザー一覧ページ" do
    context "管理者ユーザーの場合" do
      it "ページネーション、自分以外の削除ボタンの確認" do
        create_list(:user, 31)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css ".pagination"
      
        User.all.page(1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | Delete" unless u == admin_user
        end
      end
    end
    
     context "一般ユーザーの場合" do
      it "ページネーション、自分の削除ボタンの確認" do
        create_list(:user, 31)
        login_for_system(user)
        visit users_path
        expect(page).to have_css ".pagination"
      
        User.all.page(1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | Delete"
          else
            expect(page).not_to have_content "#{u.name} | Delete"
          end
        end
      end
    end
  end

  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end
    
    context "ページレイアウト" do
      it "Singupの文字列の確認" do
        expect(page).to have_content 'Signup'
      end
      
      it "正しいタイトルの確認" do
        expect(page).to have_title full_title('Signup')
      end
    end
    
    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うと登録成功のフラッシュが表示されること" do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password(more than 6 letters)", with: "password"
        fill_in "Password Confirmation", with: "password"
        click_button "Signup"
        expect(page).to have_content "How to Goへようこそ！"
      end
      
      it "無効なユーザーでユーザー登録を行うと登録失敗のフラッシュが表示されること" do
        fill_in "Name", with: ""
        fill_in "Email", with: "user@example.com"
        fill_in "Password(more than 6 letters)", with: "password"
        fill_in "Password Confirmation", with: "pass"
        click_button "Signup"
        expect(page).to have_content "Nameを入力してください"
        expect(page).to have_content "Password confirmationとPasswordの入力が一致しません"
      end
    end
  end 
  
  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        create_list(:destination, 10, user: user)
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
      
      it "Destination投稿の件数が表示されていることを確認" do
        expect(page).to have_content user.destinations.count
        expect(page).to have_css ".badge"
      end
      
      it "Destination投稿一覧のページネーション" do
        expect(page). to have_css ".pagination"
      end
      
      it "Destinationの情報確認" do
        Destination.take(5).each do |destination|
          expect(page).to have_content destination.to
          expect(page).to have_content destination.from
          expect(page).to have_content destination.time
          expect(page).to have_content destination.date
          expect(page).to have_content destination.outline
          expect(page).to have_link destination.user.name, href: user_path(destination.user)
        end
      end
    end
      
    context "お気に入り登録・解除" do
      let!(:destination2) { create(:destination, user: other_user) }
      before do
        create(:relationship, user_id: user.id, follow_id: other_user.id) 
        login_for_system(user)
      end
        
      it "投稿のお気に入り登録/解除" do
        expect(user.favorite?(destination)).to be_falsey
        user.favorite(destination)
        expect(user.favorite?(destination)).to be_truthy
        user.unfavorite(destination)
        expect(user.favorite?(destination)).to be_falsey
      end
      
        it "トップページからお気に入り登録・解除ができること", js: true do
        visit root_path
        link = find('.favorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/create"
        link.click 
        link = find('.unfavorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/destroy"
        link.click
        link = find('.favorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/create"
      end
      
      it "詳細ページからお気に入り登録・解除ができること", js: true do
        visit destination_path(destination2)
        link = find('.favorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/create"
        link.click 
        link = find('.unfavorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/destroy"
        link.click
        link = find('.favorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/create"
      end
      
      it "一覧ページからお気に入り登録・削除ができること", js: true do
        user.favorite(destination2)
        visit favorites_user_path(user)
        link = find('.unfavorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/destroy"
        link.click
        link = find('.favorite')
        expect(link[:href]).to include "/favorites/#{destination2.id}/create"
      end
      
      it "お気に入り一覧ページ" do
        user.favorite(destination2)
        visit favorites_user_path(user)
        expect(page).to have_css ".favorite_destination", count: 1
        expect(page).to have_content destination2.to
        expect(page).to have_content destination2.from
        expect(page).to have_content destination2.time
        expect(page).to have_content destination2.date
        expect(page).to have_content destination2.outline
        expect(page).to have_link destination2.user.name, href: user_path(destination2.user)
      end  
      
    end
      
    context "ユーザーのフォロー/フォロー解除処理", js: true do
      it "フォロー/フォロー解除ができること" do
        login_for_system(user)
        visit user_path(other_user)
        expect(page).to have_button "Follow"
        click_button "Follow"
        expect(page).to have_button "Following"
        click_button "Following"
        expect(page).to have_button "Follow"
      end
    end
    
    context "通知生成" do
      
      let!(:other_destination) { create(:destination, user: other_user) }
      
      before do
        login_for_system(user)
      end
      
      context "自分以外のユーザーの投稿に対して" do
        before do 
          visit destination_path(other_destination)
        end
        
        it "お気に入り登録によって通知を作成" do
          find('.favorite').click
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content 'さんがお気に入りに登録しました。'
          expect(page).to have_content other_destination.to
          expect(page).to have_content other_destination.from
          expect(page).to have_content other_destination.date
          expect(page).to have_content other_destination.time
          expect(page).to have_content other_destination.outline
          expect(page).to have_content other_destination.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end
        
        it "コメント作成によって通知を作成" do
          fill_in "comment_content", with: "こんばんは"
          click_button "Comment"
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content 'さんがコメントしました。「こんばんは」'
          expect(page).to have_content other_destination.to
          expect(page).to have_content other_destination.from
          expect(page).to have_content other_destination.date
          expect(page).to have_content other_destination.time
          expect(page).to have_content other_destination.outline
          expect(page).to have_content other_destination.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end
        
        it "フォローによって通知を作成" do
          visit user_path(other_user)
          click_button "Follow"
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content 'さんにフォローされました。'
          expect(page).to have_content other_destination.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end
      end
      
      context "自分の投稿に対して" do
        before do
          visit destination_path(destination)
        end
        
        it "コメント作成によって通知が作成されないこと" do
          fill_in "comment_content", with: "こんばんは"
          click_button "Comment"
          expect(page).to have_css 'li.no_notification'
          visit notifications_path
          expect(page).not_to have_content 'さんがコメントしました。「こんばんは」'
          expect(page).not_to have_content other_destination.to
          expect(page).not_to have_content other_destination.from
          expect(page).not_to have_content other_destination.date
          expect(page).not_to have_content other_destination.time
          expect(page).not_to have_content other_destination.outline
          expect(page).not_to have_content other_destination.created_at.strftime("%Y/%m/%d(%a) %H:%M")
          expect(page).to have_content "通知はありません"
        end
      end
      
      context "通知の削除" do
        it "通知がある場合、削除ができること", js: true do
          visit destination_path(other_destination)
          find('.favorite').click
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content 'さんがお気に入りに登録しました。'
          expect(page).to have_content other_destination.to
          expect(page).to have_content other_destination.from
          expect(page).to have_content other_destination.date
          expect(page).to have_content other_destination.time
          expect(page).to have_content other_destination.outline
          expect(page).to have_content other_destination.created_at.strftime("%Y/%m/%d(%a) %H:%M")
          find('.notification-delete').click
          page.driver.browser.switch_to.alert.accept
          expect(page).not_to have_content other_destination.to
          expect(page).not_to have_content other_destination.from
          expect(page).not_to have_content other_destination.date
          expect(page).not_to have_content other_destination.time
          expect(page).not_to have_content other_destination.outline
          expect(page).not_to have_content other_destination.created_at.strftime("%Y/%m/%d(%a) %H:%M")
          expect(page).to have_content "通知はありません"
        end
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
      
      expect(page).to have_content "プロフィールが更新されました！"
      expect(user.reload.name).to eq "Example User for edit"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduce).to eq "こんばんは"
    end
    
    it "無効なプロフィール更新" do
      fill_in "Name", with: ""
      fill_in "Email", with: ""
      click_button "Update"
      
      expect(page).to have_content "プロフィールの更新に失敗しました。"
      expect(page).to have_content 'Nameを入力してください'
      expect(page).to have_content 'Emailを入力してください'
      expect(page).to have_content 'Emailは不正な値です'
      expect(user.reload.email).not_to eq ""
    end
    
    context "アカウント削除処理", js: true do
      it "正しく削除できること" do
        click_link "Delete Account"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "アカウントを削除しました。"
      end
    end
  end
  
end
