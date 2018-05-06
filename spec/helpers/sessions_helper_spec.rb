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
    subject { helper.login user, remember_me }
    let(:remember_me) { '0' }

    shared_examples 'unrelated to remember me' do
      it { is_expected.to eq user.id }
    end

    context 'when checked remember me' do
      let(:remember_me) { '1' }
      before { allow(helper).to receive(:remember) }
      it do
        expect(helper).to receive(:remember).once
        subject
      end
    end

    context 'when not checked remember me' do
      let(:remember_me) { '0' }
      before { allow(helper).to receive(:forget) }
      it do
        expect(helper).to receive(:forget).once
        subject
      end
    end
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

  describe 'remember' do
    before do
      allow(User).to receive(:new_token).and_return('token_ok')
      allow(User).to receive(:digest).with('token_ok').and_return('digest_ok')
      user.remember
    end
    it { expect(user.remember_token).to eq 'token_ok' }
    it { expect(user.remember_digest).to eq 'digest_ok' }
  end

  describe 'logout' do
    before do
      allow(helper).to receive(:forget).and_call_original
      helper.login user
      helper.remember user
      helper.logout
    end
    it { expect(session[:user_id]).to eq nil }
    it { expect(helper.current_user).to eq nil }
    it do
      remember_me = '1'

      expect(helper).to receive(:forget).once
      helper.login user, remember_me
      helper.remember user
      helper.logout
    end
  end

  describe 'forget' do
    subject { user.remember_digest }
    before do
      user.remember
      user.forget
    end
    it { is_expected.to eq nil }
  end

  describe 'current_user' do
    subject { helper.current_user }

    context 'when logged in' do
      context 'when @current_user has been set' do
        before { assign(:current_user, user) }
        it { is_expected.to eq user }
      end

      context 'when session[:user_id] has been set' do
        before { allow(session).to receive(:[]).with(:user_id).and_return(user.id) }
        it { is_expected.to eq user }
      end

      context 'when cookies.signed[:user_id] has been set' do
        before do
          allow(User).to receive(:find_by).and_return(user)
          allow(helper).to receive(:login)
          helper.remember user
        end

        context 'when success with authenticate' do
          before { allow(user).to receive(:authenticated?).and_return(true) }
          it { is_expected.to eq user }
          it do
            expect(helper).to receive(:login).once
            subject
          end
        end

        context 'when failure with authenticate' do
          before { allow(user).to receive(:authenticated?).and_return(false) }
          it { is_expected.to eq nil }
          it do
            expect(helper).not_to receive(:login)
            subject
          end
        end
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
