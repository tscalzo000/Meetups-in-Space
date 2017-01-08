require 'spec_helper'

describe Signup do
  it { should belong_to(:meetup)}
  it { should belong_to(:user)}

  it { should have_valid(:meetup_id).when(1)}
  it { should_not have_valid(:meetup_id).when(nil,'')}

  it { should have_valid(:user_id).when(1)}
  it { should_not have_valid(:user_id).when(nil,'')}
end
