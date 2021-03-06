require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
 
  context "バリデーション" do
    
    it "Name,Emailがあれば有効な状態であること" do
      expect(user).to be_valid
    end
  
    it "Nameがなければ無効な状態であること" do
      user = build(:user, name:nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end
  
    it "名前が50文字以内であること" do
      user = build(:user, name: "a" * 51)
      user.valid?
      expect(user.errors[:name]).to include("は50文字以内で入力してください")
    end
    
    it "メールアドレスがなければ無効な状態であること" do
      user = build(:user, email: "#{"a" * 244}@example.com")
      user.valid?
      expect(user.errors[:email]).to include("は255文字以内で入力してください")
    end
    
    it "重複したメールアドレスなら無効にすること" do
      other_user = build(:user, email: user.email)
      other_user.valid?
      expect(other_user.errors[:email]).to include("はすでに存在します")
    end
    
    it "メールアドレスは小文字で保存されること" do
      email = "ExaMPle@example.com"
      user = create(:user, email: email)
      expect(user.email).to eq email.downcase
    end
    
    it "パスワードがなければ無効な状態であること" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end
    
    it "パスワードが6文字以上であれば有効であること" do
      user = build(:user, password: "a" * 6, password_confirmation: "a" * 6)
      user.valid?
      expect(user).to be_valid
    end
    
  end
  
  context "authenticated?メソッド" do
    it "ダイジェストが存在しない場合、falseを返すこと" do
      expect(user.authenticated?('')).to eq false
    end
  end
  
  context "フォロー機能" do
    it "フォロー/アンフォローの機能の動作確認" do
      #フォロー状況確認
      expect(user.following?(other_user)).to be_falsey
      #フォロー
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy #フォローしたか
      expect(other_user.followed_by?(user)).to be_truthy #フォローされたか
      #アンフォロー
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end
  
end  