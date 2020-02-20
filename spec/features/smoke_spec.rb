require "rails_helper"

RSpec.describe "Smoke test", type: :feature do
  it "succeeds" do
    visit "/"
  end
end
