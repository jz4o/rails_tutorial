require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build :user, user_attributes }
  let(:created_user) { FactoryBot.create :user, user_attributes }
  let(:user_attributes) { nil }

  describe 'validation' do
    presence_columns = %i[name email password]
    presence_columns.each do |column|
      it { should validate_presence_of column }
    end

    insensitive_uniqueness_columns = %i[email]
    insensitive_uniqueness_columns.each do |column|
      it { should validate_uniqueness_of(column).case_insensitive }
    end

    minimum_length_columns = { 6 => %i[password] }
    minimum_length_columns.each do |length, columns|
      columns.each do |column|
        it { should validate_length_of(column).is_at_least length }
      end
    end

    maximum_length_columns = { 255 => %i[name email] }
    maximum_length_columns.each do |length, columns|
      columns.each do |column|
        it { should validate_length_of(column).is_at_most length }
      end
    end

    describe 'email' do
      subject { user }

      context 'valid' do
        emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        emails.each do |email|
          let(:user_attributes) { { email: email } }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        emails.each do |email|
          let(:user_attributes) { { email: email } }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end

  describe 'before_save' do
    describe 'email' do
      subject { created_user.email }
      let(:user_attributes) { { email: 'USER@EXAMPLE.COM' } }
      it { is_expected.to eq 'user@example.com' }
    end
  end

  describe 'method' do
    describe '#remember' do
      subject { user.remember_digest }
      before do
        allow(User).to receive(:digest).and_return('ok')
        user.remember
      end

      it { is_expected.to eq 'ok' }
    end

    describe '#forget' do
      subject { created_user.remember_digest }
      before do
        created_user.remember
        created_user.forget
      end
      it { is_expected.to eq nil }
    end

    describe '#authenticated?' do
      subject { user.authenticated? test_string }
      let(:test_string) { 'string' }

      context 'when remember_token is false ' do
        let(:test_string) { false }
        before { is_expected.to eq false }
      end

      context 'when remember_token is true' do
        before do
          password = double 'password'
          allow(BCrypt::Password).to receive(:new).with(user.remember_digest).and_return(password)
          allow(password).to receive(:is_password?).with(test_string).and_return(true)
        end
        it { is_expected.to eq true }
      end
    end

    describe '.digest' do
      subject { User.digest test_string }
      let(:test_string) { 'string' }
      before { allow(BCrypt::Password).to receive(:create).with(test_string, cost: cost).and_return('ok') }

      context 'when min cost is true' do
        let(:cost) { BCrypt::Engine::MIN_COST }
        before { allow(ActiveModel::SecurePassword).to receive(:min_cost).and_return(true) }
        it { is_expected.to eq 'ok' }
      end

      context 'when min cost is false' do
        let(:cost) { BCrypt::Engine.cost }
        before { allow(ActiveModel::SecurePassword).to receive(:min_cost).and_return(false) }
        it { is_expected.to eq 'ok' }
      end
    end

    describe 'new_token' do
      subject { User.new_token }
      before { allow(SecureRandom).to receive(:urlsafe_base64).and_return('ok') }
      it { is_expected.to eq 'ok' }
    end
  end
end
