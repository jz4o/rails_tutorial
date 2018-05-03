require 'rails_helper'

RSpec.describe 'static_pages/contact.html.erb', type: :view do
  before { render }
  it { expect(view.content_for(:title)).to eq 'Contact' }
end
