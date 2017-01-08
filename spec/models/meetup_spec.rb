require 'spec_helper'

describe Meetup do
  it { should have_valid(:name).when("Dog") }
  it { should_not have_valid(:name).when(nil, "") }

  it { should have_valid(:location).when("Moon") }
  it { should_not have_valid(:location).when(nil, "") }

  it { should have_valid(:description).when("Moon") }
  it { should_not have_valid(:description).when(nil, "") }

  it { should have_many(:signups) }
  it { should have_many(:comments) }
  it { should have_many(:users).through(:signups)}
end
