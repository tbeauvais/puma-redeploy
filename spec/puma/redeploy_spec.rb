# frozen_string_literal: true

RSpec.describe Puma::Redeploy do
  it 'has a version number' do
    expect(Puma::Redeploy::VERSION).not_to be nil
  end
end
