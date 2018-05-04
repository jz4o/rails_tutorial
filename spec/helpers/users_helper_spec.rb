require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
  describe 'gravatar_for' do
    gravatar_url = 'https://secure.gravatar.com/avatar'
    dummy_id = 'testtesttest'
    let(:user) { FactoryBot.build :user }
    let(:result) { %(<img alt="#{user.name}" class="gravatar" src="#{gravatar_url}/#{dummy_id}?s=#{size}" />) }
    before { allow(Digest::MD5).to receive(:hexdigest).and_return(dummy_id) }

    context 'default size' do
      subject { helper.gravatar_for(user) }
      let(:size) { 80 }
      it { is_expected.to eq result }
    end

    context 'specific size' do
      subject { helper.gravatar_for(user, size: size) }
      let(:size) { 120 }
      it { is_expected.to eq result }
    end
  end
end
