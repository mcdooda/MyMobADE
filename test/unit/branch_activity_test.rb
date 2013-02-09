# == Schema Information
#
# Table name: branch_activities
#
#  id                :integer          not null, primary key
#  branch_id         :integer
#  activity_cache_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class BranchActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
