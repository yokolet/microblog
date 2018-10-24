require 'rails_helper'

RSpec.describe Api::V1::Post, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:content) }
end
