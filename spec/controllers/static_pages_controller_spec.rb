require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    subject { get :home }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :home }
  end

  describe 'GET #help' do
    subject { get :help }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :help }
  end

  describe 'GET #about' do
    subject { get :about }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :about }
  end

  describe 'GET #contact' do
    subject { get :contact }
    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :contact }
  end
end
