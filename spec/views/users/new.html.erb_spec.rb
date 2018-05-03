require 'rails_helper'

RSpec.describe 'users/new.html.erb', type: :view do
  before { render }
  it { expect(view.content_for(:title)).to eq 'Sign up' }
end
