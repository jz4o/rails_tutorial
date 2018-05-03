require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    subject { get :home }
    it { is_expected.to have_http_status :ok }
  end

  describe 'GET #help' do
    subject { get :help }
    it { is_expected.to have_http_status :ok }
  end

  describe 'GET #about' do
    subject { get :about }
    it { is_expected.to have_http_status :ok }
  end

  describe 'GET #contact' do
    subject { get :contact }
    it { is_expected.to have_http_status :ok }
  end
end
