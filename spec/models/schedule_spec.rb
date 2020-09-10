require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let!(:schedule) { create(:schedule) }
 
  it "有効な状態であること" do
    expect(schedule).to be_valid
  end
end
