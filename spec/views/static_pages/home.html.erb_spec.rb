require 'rails_helper'

RSpec.describe 'static_pages/home.html.erb', type: :view do
  before { render }
  it { expect(view.content_for(:title)).to eq 'Home' }
end
