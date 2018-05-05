require 'rails_helper'

RSpec.describe 'sessions/new.html.erb', type: :view do
  before { render }
  it { expect(view.content_for(:title)).to eq 'Log in' }
end
