require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo10 do
      it "should accept the examples by the 'Itau documentation'" do
        Modulo10.new('341911012').should eq  '1'
        Modulo10.new('3456788005').should eq '8'
        Modulo10.new('7123457000').should eq '1'
      end

      it "should accept the example from Banrisul" do
        Modulo10.new('00009274').should eq '2'
      end

      it "returns zero when number is 0" do
        Modulo10.new('0').should eq '0'
      end

      it "returns zero when mod 10 is zero" do
        Modulo10.new('99906').should eq '0'
      end

      it "calculate when number had 1 digit" do
        Modulo10.new('1').should eq '8'
      end

      it "calculate when number had 2 digits" do
        Modulo10.new('10').should eq '9'
      end

      it "calculate when number had 3 digits" do
        Modulo10.new('994').should eq '4'
      end

      it "calculate when number had 5 digits" do
        Modulo10.new('97831').should eq '2'
      end

      it "calculate when number had 6 digits" do
        Modulo10.new('147966').should eq '6'
      end

      it "calculate when number had 10 digits" do
        Modulo10.new('3456788005').should eq '8'
      end

      it "should accept numbers too" do
        Modulo10.new(12345).should eq '5'
      end
    end
  end
end