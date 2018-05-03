require 'rails_helper'

RSpec.describe 'static_pages/help.html.erb', type: :view do
  before { render }
  it { expect(view.content_for(:title)).to eq 'Help' }
end
