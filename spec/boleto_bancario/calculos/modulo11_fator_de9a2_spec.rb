require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo11FatorDe9a2 do
      context "when the mod result is 10 (ten)" do
        subject { Modulo11FatorDe9a2.new('3973') }

        it { should eq '10' }
      end

      context "when the mod result is zero" do
        subject { Modulo11FatorDe9a2.new('3995') }

        it { should eq '0' }
      end

      context "when the result is one" do
        subject { Modulo11FatorDe9a2.new('5964') }

        it { should eq '1' }
      end

      context "with a five digit number" do
        subject { Modulo11FatorDe9a2.new('10949') }

        it { should eq '5' }
      end
    end
  end
end