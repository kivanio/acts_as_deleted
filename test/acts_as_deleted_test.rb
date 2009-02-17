require File.dirname(__FILE__) + '/test_helper.rb'

class ActsAsDeletedTest < Test::Unit::TestCase
  load_schema
  
  # FIXME this is bloated and should be mocked for better testing style of callbacks
  class Thingy < ActiveRecord::Base
    acts_as_deleted
    
    before_delete :before_deleted
    after_delete :after_deleted
    
    before_undelete :before_undeleted
    after_undelete :after_undeleted
    
    attr_reader :deleted_before, :deleted_after, :undeleted_before, :undeleted_after
    
  protected
    def before_deleted
      @deleted_before = deleted
    end
    
    def after_deleted
      @deleted_after = deleted
    end
    
    def before_undeleted
      @undeleted_before = deleted
    end
    
    def after_undeleted
      @undeleted_after = deleted
    end
  end
  
  # TODO better use transactional testing
  def teardown
    Thingy.delete_all
  end

  def test_schema_has_loaded_correctly
    assert_equal [], Thingy.all
  end  
  
  def test_named_scope_deleted
    deleted_scope = { :conditions => { :deleted => true } }
    assert_equal deleted_scope, Thingy.only_deleted.proxy_options
  end

  def test_named_scope_not_deleted
    not_deleted_scope = { :conditions => { :deleted => false } }
    assert_equal not_deleted_scope, Thingy.without_deleted.proxy_options
  end

  def test_delete_sets_deleted_and_saves_record
    thingy = Thingy.create(:name => 'Foo')
    assert_equal false, thingy.deleted
    thingy.delete
    thingy.reload
    assert_equal true, thingy.deleted
  end
  
  def test_delete_sets_timestamp
  	time = Time.now
    thingy = Thingy.create(:name => 'Foo')
    thingy.delete
    assert thingy.deleted_at > time
  end
  
  def test_delete_calls_before_delete_callback
    thingy = Thingy.create(:name => 'Foo')
    thingy.delete
    assert_equal false, thingy.deleted_before
  end
  
  def test_delete_calls_after_delete_callback
    thingy = Thingy.create(:name => 'Foo')
    thingy.delete
    assert_equal true, thingy.deleted_after
  end
  
  def test_undelete_unsets_deleted_and_deleted_at_and_saves_record
    thingy = Thingy.create(:name => 'Foo')
    thingy.delete
    thingy.undelete
    thingy.reload
    assert_equal false, thingy.deleted
    assert_nil thingy.deleted_at
  end
  
  def test_undelete_calls_before_undelete_callback
    thingy = Thingy.create(:name => 'Foo')
    thingy.delete
    thingy.undelete
    assert_equal true, thingy.deleted_after
  end
  
  def test_delete_with_user_sets_deleted_by_to_user_id
    thingy = Thingy.create(:name => 'Foo')
    thingy.delete_with_user(42)
    thingy.reload
    assert_equal 42, thingy.deleted_by
  end
end
