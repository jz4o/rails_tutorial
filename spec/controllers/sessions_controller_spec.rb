require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    subject { get :new }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :new }
  end

  describe 'POST #create' do
    subject { post :create }

    let(:user) { FactoryBot.build :user }
    before do
      param = { email: user.email, password: user.password }
      allow(User).to receive(:find_by).and_return(user)
      allow(controller).to receive(:session_params).and_return(param)
    end

    context 'when success with authenticate' do
      before do
        allow(user).to receive(:authenticate).and_return(true)
        allow(controller).to receive(:login)
      end

      it { is_expected.to redirect_to user }
      it do
        expect(controller).to receive(:login)
        subject
      end
    end

    context 'when failure with authenticate' do
      before { allow(user).to receive(:authenticate).and_return(false) }
      it { is_expected.to render_template :new }
      it do
        subject
        expect(controller.flash.now[:danger]).to eq 'Invalid email/password combination'
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy }
    before { allow(controller).to receive(:logout) }
    it { is_expected.to redirect_to root_path }
    it do
      expect(controller).to receive(:logout).once
      subject
    end
  end
end
