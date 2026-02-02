# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo11FatorDe9a2RestoX do
      context "when the mod result is 10 (ten)" do
        subject { Modulo11FatorDe9a2RestoX.new('3973') }

        it { is_expected.to eq 'X' }
      end

      context "when the mod result is zero" do
        subject { Modulo11FatorDe9a2RestoX.new('3995') }

        it { is_expected.to eq '0' }
      end

      context "using the 'Banco Brasil' documentation example" do
        subject { Modulo11FatorDe9a2RestoX.new('01129004590') }

        it { is_expected.to eq '3' }
      end

      context "when the result is one" do
        subject { Modulo11FatorDe9a2RestoX.new('5964') }

        it { is_expected.to eq '1' }
      end

      context "with a five digit number" do
        subject { Modulo11FatorDe9a2RestoX.new('10949') }

        it { is_expected.to eq '5' }
      end
    end
  end
end
