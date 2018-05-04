require 'rails_helper'

RSpec.describe 'users/new.html.erb', type: :view do
  before do
    assign :user, User.new
    render
  end
  it { expect(view.content_for(:title)).to eq 'Sign up' }
end
