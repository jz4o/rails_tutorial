require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    describe 'response' do
      subject { get :new }
      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template :new }
    end
    describe 'assigns' do
      subject { assigns[:user] }
      before { get :new }
      it { is_expected.to be_a_new User }
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { user: user_attributes } }
    let(:user_attributes) { FactoryBot.attributes_for :user }

    context 'when success with save' do
      before { allow_any_instance_of(User).to receive(:valid?).and_return(true) }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to assigns[:user] }
      it { expect { subject }.to change(User, :count).by(1) }
      it do
        subject
        expect(flash[:success]).to eq 'Welcome to the Sample App!'
      end
      it do
        subject
        expect(controller.current_user).to eq assigns[:user]
      end
    end

    context 'when failure with save' do
      before { allow_any_instance_of(User).to receive(:valid?).and_return(false) }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template :new }
      it { expect { subject }.not_to change(User, :count) }
    end
  end
end
