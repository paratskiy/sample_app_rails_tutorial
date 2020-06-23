require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:paratskiy)
    @other = users(:lana)
    @relationship = Relationship.new(follower_id: @user.id, followed_id: @other.id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require a follower_id' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a followed_id' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
