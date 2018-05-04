require 'rails_helper'

RSpec.describe User, type: :model do
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
      subject { FactoryBot.build :user, email: email }

      context 'valid' do
        emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        emails.each do |email|
          let(:email) { email }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        emails.each do |email|
          let(:email) { email }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end

  describe 'before_save' do
    describe 'email' do
      subject { user.email }
      let(:user) { FactoryBot.create :user, email: 'USER@EXAMPLE.COM' }
      it { is_expected.to eq 'user@example.com' }
    end
  end
end
