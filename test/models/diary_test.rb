require "test_helper"

class DiaryTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @diary = @user.diaries.build(title:"test1",content: "test2", user_id: @user.id, start_time: Time.now)
  end

  test "should be valid" do
    assert @diary.valid?
  end

  test "title should be present" do
    @diary.title = "   "
    assert_not @diary.valid?
  end

  test "title should be at most 20 characters" do
    @diary.title = "a" * 21
    assert_not @diary.valid?
  end

  test "content should be present" do
    @diary.title = "test1"
    @diary.content = "   "
    assert_not @diary.valid?
  end

  test "content should be at most 255 characters" do
    @diary.content = "a" * 256
    assert_not @diary.valid?
  end


end
