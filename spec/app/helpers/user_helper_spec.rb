require 'spec_helper'

describe "Epistoleiro::App::UserHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend Epistoleiro::App::UserHelper }
  subject { helpers }

  it "should return nil" do
    expect(subject.foo).to be_nil
  end
end
