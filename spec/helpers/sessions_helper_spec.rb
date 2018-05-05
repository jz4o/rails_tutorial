require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create :user }

  describe 'login' do
    subject { session[:user_id] }
    before { helper.login user }

    it { is_expected.to eq user.id }
  end

  describe 'login?' do
    subject { helper.login? }

    context 'when logged in' do
      before { allow(helper).to receive(:current_user).and_return(user) }
      it { is_expected.to eq true }
    end

    context 'when not logged in' do
      before { allow(helper).to receive(:current_user).and_return(nil) }
      it { is_expected.to eq false }
    end
  end

  describe 'logout' do
    before { helper.logout }
    it { expect(session[:user_id]).to eq nil }
    it { expect(helper.current_user).to eq nil }
  end

  describe 'current_user' do
    subject { helper.current_user }

    context 'when logged in' do
      context 'when @current_user has been set' do
        before { assign(:current_user, user) }
        it { is_expected.to eq user }
      end

      context 'when session[:user_is] has been set' do
        before { allow(session).to receive(:[]).with(:user_id).and_return(user.id) }
        it { is_expected.to eq user }
      end
    end

    context 'when not logged in' do
      before do
        assign(:current_user, nil)
        allow(session).to receive(:[]).with(:user_id).and_return(nil)
      end
      it { is_expected.to eq nil }
    end
  end
end
