require 'test_helper'

class PhoneWranglerTest < Test::Unit::TestCase

  include PhoneWrangler

  context "Parsing a phone number" do

    should "accept a string" do
      assert_nothing_raised do
        pn = PhoneNumber.new("1234")
      end
    end

    should "accept a hash" do
      assert_nothing_raised do
        pn = PhoneNumber.new(:area_code => '256', :prefix => '555', :number => '1234')
      end
    end

    should "raise ArgumentError when passed silly args" do
      assert_raise(ArgumentError) { PhoneNumber.new(3.77) }
      assert_raise(ArgumentError) { PhoneNumber.new(false) }
      assert_raise(ArgumentError) { PhoneNumber.new(/wicky/) }
    end

    should "return a PhoneNumber object" do
      pn = PhoneNumber.new("123-456-7685")
      assert_equal PhoneNumber, pn.class
    end

    should "agree it is empty when it is" do
      pn = PhoneNumber.new
      assert pn.empty?
    end

    should "not agree it is empty when it is not" do
      pn = PhoneNumber.new(:area_code => '256', :prefix => '555', :number => '1234')
      assert ! pn.empty?
    end

    should "correctly parse phone number strings" do
      pn = PhoneNumber.new("(256) 555-1234")
      assert_equal '256', pn.area_code
      assert_equal '555', pn.prefix
      assert_equal '1234', pn.number
      assert pn.extension.nil?
      pn = PhoneNumber.new("1-234-567-8901")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert pn.extension.nil?
      pn = PhoneNumber.new("1-234-567-8901x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1-234-567-8901 x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1-234-567-8901 ext 1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1-234-567-8901 ex1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1(234)567-8901x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("(234) 567-8901 x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1(234) 567.8901 x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1.234.567.8901 x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("234.567.8901 x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("234/567/8901 xt1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1 234.567/8901 xt1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1-234.567/8901 xt1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("1/234.567/8901 xt1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("12345678901x1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("(234) 567-8901 ext.1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("(234) 567-8901 Ext.1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("(234) 567-8901, Extension 1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("(234) 567-8901 (x1234)")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("(234) 567-8901:1234")
      assert_equal '234', pn.area_code
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
    end

    should "correctly parse short phone number strings" do
      pn = PhoneNumber.new("5678901x1234")
      assert pn.area_code.nil?
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert_equal '1234', pn.extension
      pn = PhoneNumber.new("567-8901")
      assert pn.area_code.nil?
      assert_equal '567', pn.prefix
      assert_equal '8901', pn.number
      assert pn.extension.nil?
      pn_short = PhoneNumber.new("456-7890")
      pn_parts = PhoneNumber.new(:prefix => '456', :number => '7890')
      assert_equal pn_parts, pn_short
    end

    should "allow a default area_code to be set for the class" do
      PhoneNumber.default_area_code = "256"
      assert_equal "256", PhoneNumber.default_area_code
      PhoneNumber.default_area_code = nil  # put it back, it's a class attr
    end

    should "set original to new value when re-assigned with raw=" do
      pn = PhoneNumber.new("1-234-567-8901")
      pn.raw = "456-909-8073"
      assert_equal "456-909-8073", pn.original
    end
  end

  context "With a default_area_code set" do
    setup do
      PhoneNumber.default_area_code = "404"
    end

    teardown do
      PhoneNumber.default_area_code = nil  # put it back, it's a class attr
    end

    should "use default area_code if one is not provided (String)" do
      pn = PhoneNumber.new("456-7890")
      assert_equal "404", pn.area_code
    end

    should "use default area_code if one is not provided (Hash)" do
      pn = PhoneNumber.new(:prefix => '456', :number => "7890")
      assert_equal "404", pn.area_code
    end

    should "ignore default_area_code if one is passed in (String)" do
      pn = PhoneNumber.new("256-456-7890")
      assert_equal "256", pn.area_code
    end

    should "ignore default_area_code if one is passed in (Hash)" do
      pn = PhoneNumber.new(:area_code => '256', :prefix => '456', :number => "7890")
      assert_equal "256", pn.area_code
    end

    should "return default area_code if it has one" do
      assert_equal '404', PhoneNumber.default_area_code
      PhoneNumber.default_area_code = nil  # put it back, it's a class attr
      assert_equal nil, PhoneNumber.default_area_code
    end

    should "use default area_code in comparison is needed on either side" do
      pn1 = PhoneNumber.new("456-7890")
      pn2 = PhoneNumber.new("404-456-7890")
      assert pn1 == pn2
    end
  end

  context "Printing a phone number" do
    setup do
      @phone_hash = {:area_code => '256', :prefix => '555', :number => '1234'}
      @pn = PhoneNumber.new(@phone_hash)
    end

    should "respond to to_s with a String" do
      assert_equal String, @pn.to_s.class
    end

    # TODO: I don't know if this is the right behavior, actually.  If the user
    # passes in a format string with extra decorative content, does he want it
    # back with only the decorative structure?  Or is an empty string better?
    should "return an empty string if the PhoneNumber is empty" do
      assert_equal '', PhoneNumber.new.to_s("x%e foo")
    end

    should "format numbers properly with to_s" do
      assert_equal "(256) 555-1234", @pn.to_s
    end

    should "correctly interpolate format string" do
      assert_equal "256 FF 555--1234", @pn.to_s("%a FF %p--%n")
      assert_equal "256-555-1234", @pn.to_s("%a-%p-%n")
      assert_equal "256/555-1234", @pn.to_s("%a/%p-%n")
      assert_equal "(256) 555-1234", @pn.to_s("(%a) %p-%n")
      assert_equal "256.555.1234", @pn.to_s("%a.%p.%n")
    end

    should "correctly interpolate format string with missing elements" do
      @pn = PhoneNumber.new("431-4310")
      # Make sure to_s doesn't barf based on the requested elements in the format string
      assert_equal " FF 431--4310", @pn.to_s("%a FF %p--%n")
    end

    should "correctly interpolate named patterns" do
      @pn.extension = "999"
      assert_equal " (256) 555-1234 x 999", @pn.to_s(:us)
      assert_equal "(256) 555-1234", @pn.to_s(:us_short)
      assert_equal "(256) 555-1234", @pn.to_s(:nanp_short)
    end

    should "return original data" do
      assert_equal @phone_hash, @pn.original
    end

    should "provide a digits-only version" do
      output = @pn.digits
      assert /^\d+$/ === output
      assert_equal @phone_hash[:area_code]+@phone_hash[:prefix]+@phone_hash[:number], output
    end
  end

  context "Comparing phone numbers" do
    setup do
      @phone_hash = {:area_code => '256', :prefix => '555', :number => '1234'}
      @pn = PhoneNumber.new(@phone_hash)
    end

    should "be equal to itself" do
      assert @pn == @pn
    end

    should "be equal to an identical PhoneNumber" do
      @pn_new = PhoneNumber.new(@phone_hash)
      assert @pn == @pn_new
    end

    should "should return true when == to an equivalent String" do
      assert @pn == "256-555-1234"
    end

    should "should return true when == to an equivalent Hash" do
      assert @pn == {:area_code => '256', :prefix => '555', :number => '1234'}
    end
  end
end
