require 'spec_helper'

module BoletoBancario
  module Calculos
    describe FatorVencimento do
      describe "#base_date" do
        it "should be 1997-10-07" do
          FatorVencimento.new(Date.parse("2012-02-01")).base_date.should eq Date.new(1997, 10, 7)
        end
      end

      describe "#calculate" do
        it 'should return an empty string when passing nil value' do
          FatorVencimento.new(nil).should eq ''
        end

        it 'should return an empty string when passing empty value' do
          FatorVencimento.new('').should eq ''
        end

        it "should calculate the days between expiration date and base date" do
          FatorVencimento.new(Date.parse("2012-12-2")).should eq "5535"
        end

        it "should calculate equal to itau documentation example" do
          FatorVencimento.new(Date.parse("2000-07-04")).should eq "1001"
        end

        it "should calculate equal to itau documentation last section of the docs" do
          FatorVencimento.new(Date.parse("2002-05-01")).should eq "1667"
        end

        it "should calculate to the maximum date equal to itau documentation example" do
          FatorVencimento.new(Date.parse("2025-02-21")).should eq "9999"
        end

        it "should calculate the days between expiration date one year ago" do
          FatorVencimento.new(Date.parse("2011-05-25")).should eq "4978"
        end

        it "should calculate the days between expiration date two years ago" do
          FatorVencimento.new(Date.parse("2010-10-02")).should eq "4743"
        end

        it "should calculate the days between expiration date one year from now" do
          FatorVencimento.new(Date.parse("2013-02-01")).should eq "5596"
        end

        it "should calculate the days between expiration date eigth years from now" do
          FatorVencimento.new(Date.parse("2020-02-01")).should eq "8152"
        end

        it "should calculate the days between expiration date formating with 4 digits" do
          FatorVencimento.new(Date.parse("1997-10-08")).should eq "0001"
        end
      end
    end
  end
end