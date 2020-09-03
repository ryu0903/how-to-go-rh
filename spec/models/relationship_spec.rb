require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:relationship) { create(:relationship) }
  
  it "関係性が有効であること" do
    expect(relationship).to be_valid
  end
  
  it "user_idがnilの場合、関係性が無効であること" do
    relationship.user_id = nil
    expect(relationship).not_to be_valid
  end
  
  it "follow_idがnilの場合、関係性が無効であること" do
    relationship.follow_id = nil
    expect(relationship).not_to be_valid
  end
end
