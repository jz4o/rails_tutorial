require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StaticPagesHelper. For example:
#
# describe StaticPagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context '引数を渡す場合' do
      it { expect(helper.full_title('Test')).to   eq 'Test | Ruby on Rails Tutorial Sample App' }
      it { expect(helper.full_title('String')).to eq 'String | Ruby on Rails Tutorial Sample App' }
    end
    context '引数を渡さない場合' do
      it { expect(helper.full_title).to eq 'Ruby on Rails Tutorial Sample App' }
    end
  end
end
