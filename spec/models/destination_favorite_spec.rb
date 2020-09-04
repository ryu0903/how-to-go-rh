require 'rails_helper'

RSpec.describe DestinationFavorite, type: :model do
  let!(:destination_favorite) { create(:destination_favorite) }
    
    it "destination_favoriteインスタンスが有効であること" do
      expect(destination_favorite).to be_valid
    end
    
    it "user_idがnilの場合無効であること" do
      destination_favorite.user_id = nil
      expect(destination_favorite).not_to be_valid
    end
    
    it "destination_idがnilの場合無効であること" do
      destination_favorite.destination_id = nil
      expect(destination_favorite).not_to be_valid
    end
end
