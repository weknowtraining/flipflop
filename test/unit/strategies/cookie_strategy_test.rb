require File.expand_path("../../../test_helper", __FILE__)

require "action_controller"

describe Flipflop::CookieStrategy do
  def create_cookie_jar
    env = Rack::MockRequest.env_for("/example")
    request = ActionDispatch::TestRequest.new(env)

    method = ActionDispatch::Cookies::CookieJar.method(:build)
    if method.arity == 2 # Rails 5.0
      method.call(request, {})
    else
      method.call(request)
    end
  end

  describe "with defaults" do
    subject do
      Flipflop::CookieStrategy.new
    end

    before do
      subject.class.cookies = create_cookie_jar
    end

    after do
      subject.class.cookies = nil
    end

    it "should have default name" do
      assert_equal "cookie", subject.name
    end

    it "should have default description" do
      assert_equal "Stores features in a browser cookie. Applies to current user.",
        subject.description
    end

    it "should be switchable" do
      assert_equal true, subject.switchable?
    end

    it "should have unique key" do
      assert_match /^\d+$/, subject.key
    end

    describe "with enabled feature" do
      before do
        subject.class.cookies[subject.cookie_name(:one)] = "1"
      end

      it "should know feature" do
        assert_equal true, subject.knows?(:one)
      end

      it "should have feature enabled" do
        assert_equal true, subject.enabled?(:one)
      end

      it "should be able to switch feature off" do
        subject.switch!(:one, false)
        assert_equal false, subject.enabled?(:one)
      end

      it "should be able to clear feature" do
        subject.clear!(:one)
        assert_equal false, subject.knows?(:one)
      end
    end

    describe "with disabled feature" do
      before do
        subject.class.cookies[subject.cookie_name(:two)] = "0"
      end

      it "should know feature" do
        assert_equal true, subject.knows?(:two)
      end

      it "should not have feature enabled" do
        assert_equal false, subject.enabled?(:two)
      end

      it "should be able to switch feature on" do
        subject.switch!(:two, true)
        assert_equal true, subject.enabled?(:two)
      end

      it "should be able to clear feature" do
        subject.clear!(:two)
        assert_equal false, subject.knows?(:two)
      end
    end

    describe "with uncookied feature" do
      it "should not know feature" do
        assert_equal false, subject.knows?(:three)
      end

      it "should be able to switch feature on" do
        subject.switch!(:three, true)
        assert_equal true, subject.enabled?(:three)
        assert_equal true, subject.knows?(:three)
      end
    end
  end
end

describe Flipflop::CookieStrategy::Loader do
  subject do
    # Force loading of cookie logic.
    ActionDispatch::Cookies

    Class.new(ActionController::Metal) do
      class << self
        attr_accessor :cookies
      end

      include ActionController::Helpers
      include ActionController::Cookies
      include AbstractController::Callbacks
      include Flipflop::CookieStrategy::Loader

      def index
        self.class.cookies = Flipflop::CookieStrategy.cookies
      end
    end
  end

  it "should add before filter to controller" do
    filters = subject._process_action_callbacks.select { |f| f.kind == :before }
    assert_equal 1, filters.length
  end

  it "should add after filter to controller" do
    filters = subject._process_action_callbacks.select { |f| f.kind == :after }
    assert_equal 1, filters.length
  end

  it "should set cookies" do
    subject.action(:index).call({})
    assert_instance_of ActionDispatch::Cookies::CookieJar, subject.cookies
  end

  it "should clear cookies" do
    subject.action(:index).call({})
    assert_nil Flipflop::CookieStrategy.cookies
  end
end
