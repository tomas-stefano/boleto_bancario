# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo10 do
      it "accepts the examples by the 'Itau documentation'" do
        expect(Modulo10.new('341911012')).to eq  '1'
        expect(Modulo10.new('3456788005')).to eq '8'
        expect(Modulo10.new('7123457000')).to eq '1'
      end

      it "accepts the example from Banrisul" do
        expect(Modulo10.new('00009274')).to eq '2'
      end

      it "returns zero when number is 0" do
        expect(Modulo10.new('0')).to eq '0'
      end

      it "returns zero when mod 10 is zero" do
        expect(Modulo10.new('99906')).to eq '0'
      end

      it "calculate when number had 1 digit" do
        expect(Modulo10.new('1')).to eq '8'
      end

      it "calculate when number had 2 digits" do
        expect(Modulo10.new('10')).to eq '9'
      end

      it "calculate when number had 3 digits" do
        expect(Modulo10.new('994')).to eq '4'
      end

      it "calculate when number had 5 digits" do
        expect(Modulo10.new('97831')).to eq '2'
      end

      it "calculate when number had 6 digits" do
        expect(Modulo10.new('147966')).to eq '6'
      end

      it "calculate when number had 10 digits" do
        expect(Modulo10.new('3456788005')).to eq '8'
      end

      it "accepts numbers too" do
        expect(Modulo10.new(12345)).to eq '5'
      end
    end
  end
end
