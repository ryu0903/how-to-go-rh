require 'rails_helper'

RSpec.describe Destination, type: :model do
  let!(:destination_yesterday) { create(:destination, :yesterday) }
  let!(:destination_one_week_ago) { create(:destination, :one_week_ago) }
  let!(:destination_one_month_ago) { create(:destination, :one_month_ago) }
  let!(:destination) { create(:destination) }
  
  context "バリデーション" do
    it "有効な状態であること" do
      expect(destination).to be_valid
    end
    
    it "行き先がなかれば無効" do
      destination = build(:destination, to: nil)
      destination.valid?
      expect(destination.errors[:to]).to include("を入力してください")
    end
    
    it "行き先が30文字以内" do
      destination = build(:destination, to: "a" * 31)
      destination.valid?
      expect(destination.errors[:to]).to include("は30文字以内で入力してください")
    end
    
    it "出発地がなければ無効" do
      destination = build(:destination, from: nil)
      destination.valid?
      expect(destination.errors[:from]).to include("を入力してください")
    end
    
    it "出発地が30文字以内" do
      destination = build(:destination, from: "a" * 31)
      destination.valid?
      expect(destination.errors[:from]).to include("は30文字以内で入力してください")
    end
    
    it "日付がなければ無効" do
      destination = build(:destination, date: nil)
      destination.valid?
      expect(destination.errors[:date]).to include("を入力してください")
    end
    
    it "ユーザーIDがなければ無効" do
      destination = build(:destination, user_id: nil)
      destination.valid?
      expect(destination.errors[:user_id]).to include("を入力してください")
    end
  
  end
  
  context "並び順" do
    it "直近の投稿が一番最初に来ること" do
      expect(destination).to eq Destination.first
    end
  end
  
end
