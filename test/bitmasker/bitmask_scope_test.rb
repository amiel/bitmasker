require 'test_helper'

class Bitmasker::BitmaskScopeTest < MiniTest::Unit::TestCase

  MockModel = Class.new do
    def self.table_name
      "mock_models"
    end
  end

  def model_instance
    @model_instance ||= MockModel.new
  end

  def setup
    @klass = Bitmasker::BitmaskScope.make(
      MockModel, 'email_mask', 'emails',
      send_weekly_email:        0b0001,
      send_monthly_newsletter:  0b0010,
      send_daily_spam:          0b0100,
    )
  end

  def subject
    @subject ||= @klass.new
  end

  def test_klass_to_s
    assert_equal "Bitmasker::BitmaskScope(Bitmasker::BitmaskScopeTest::MockModel#email_mask)", @klass.to_s
  end


  def test_with_attribute
    MockModel.expects(:where).with("mock_models.email_mask & :mask = :mask", mask: 1)
    subject.with_emails(:send_weekly_email)
  end

  def test_with_attributes_array
    MockModel.expects(:where).with("mock_models.email_mask & :mask = :mask", mask: 6)
    subject.with_emails([:send_monthly_newsletter, :send_daily_spam])
  end

  def test_with_attributes
    MockModel.expects(:where).with("mock_models.email_mask & :mask = :mask", mask: 6)
    subject.with_emails(:send_monthly_newsletter, :send_daily_spam)
  end

  def test_without_attribute
    MockModel.expects(:where).with("mock_models.email_mask & :mask = 0 OR mock_models.email_mask IS NULL", mask: 2)
    subject.without_emails(:send_monthly_newsletter)
  end

  def test_with_any_attribute
    MockModel.expects(:where).with("mock_models.email_mask & :mask <> 0", mask: 3)
    subject.with_any_emails([:send_weekly_email, :send_monthly_newsletter])
  end

  def test_bitmask_with_mask_code
    assert_equal ["send_monthly_newsletter", "send_daily_spam"], subject.bitmask(6).to_a
  end

  def test_with_unmatching_attribute
    MockModel.expects(:where).with("1 = 0")
    subject.with_emails(:omg_not_an_attribute)
  end
end
