# == Schema Information
#
# Table name: activity_caches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :string(255)
#  begin_time :string(255)
#  duration   :string(255)
#  teachers   :string(255)
#  rooms      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ActivityCacheTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
