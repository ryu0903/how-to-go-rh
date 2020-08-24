require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user) }
  
  it "正常なレスポンス" do
    get login_path
    expect(response).to be_success
    expect(response).to have_http_status "200"
  end
  
end
