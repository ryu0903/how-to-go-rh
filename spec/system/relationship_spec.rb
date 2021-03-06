require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user4) { create(:user) }
  let!(:destination) { create(:destination, user: user) }
  let!(:destination2) { create(:destination, user: user2) }
  let!(:destination3) { create(:destination, user: user3) }
  
  describe "フォロー一覧ページ" do
    before do
      create(:relationship, follow_id: user2.id)
      create(:relationship, follow_id: user3.id)
      login_for_system(user)
      visit followings_user_path(user)
    end
    
    context "ページレイアウト" do
      it "「Follow」の文字列確認" do
        expect(page).to have_content 'Follow'
      end
      
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title('Follow')
      end
      
      it "ログイン中のユーザー情報の確認" do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link 'Follow', href: followings_user_path(user)
        expect(page).to have_link 'Follower', href: followers_user_path(user)
      end
      
      it "フォロー中のユーザーの表示確認" do
        user.followings.each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if current_user.following?(u)
            expect(page).to have_button 'Following'
          else
            expect(page).to have_button 'Follow'
          end
        end
      end
    end
  end
  
  context "フォロワー一覧ページ"
     before do
      create(:relationship, user_id: user2.id)
      create(:relationship, user_id: user3.id)
      create(:relationship, user_id: user4.id)
      login_for_system(user)
      visit followers_user_path(user)
    end
    
    context "ページレイアウト" do
      it "「Follower」の文字列確認" do
        expect(page).to have_content "Follower"
      end
      
      it "正しいタイトルの表示確認" do
        expect(page).to have_title full_title('Follower')
      end
      
      it "ログイン中のユーザー情報の確認" do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link 'Follow', href: followings_user_path(user)
        expect(page).to have_link 'Follower', href: followers_user_path(user)
      end
      
      it "フォロワーのの表示確認" do
        user.followers.each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if current_user.following?(u)
            expect(page).to have_button 'Following'
          else
            expect(page).to have_button 'Follow'
          end
        end
      end
    end
    
    describe "Destinationフィード" do
      before do
        create(:relationship, user_id: user.id, follow_id: user2.id)
        login_for_system(user)
      end
      
      it "フィードに自分の投稿が含まれていること" do
        expect(user.feed_destination).to include destination
      end
      
      it "フィードにフォロー中のユーザーの投稿が含まれていること" do
        expect(user.feed_destination).to include destination2
      end
      
      it "フィードにフォローしていないユーザーの投稿が含まれていないこと" do
        expect(user.feed_destination).not_to include destination3
      end
    end
end
