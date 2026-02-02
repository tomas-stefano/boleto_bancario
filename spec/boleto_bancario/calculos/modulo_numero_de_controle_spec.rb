# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe ModuloNumeroDeControle do
      context "when is simple calculation" do
        subject { ModuloNumeroDeControle.new('00009274') }

        it { is_expected.to eq '22' }
      end

      context "another example" do
        subject { ModuloNumeroDeControle.new('0000001') }

        it { is_expected.to eq '83' }
      end

      context "example with second digit invalid" do
        subject { ModuloNumeroDeControle.new('00009194') }

        it { is_expected.to eq '38' }
      end

      context "example with second digit invalid and first digit with '9'" do
        subject { ModuloNumeroDeControle.new('411') }

        it { is_expected.to eq '06' }
      end

      context 'calculates when the first digit is not 10 (ten)' do
        subject { ModuloNumeroDeControle.new('5') }

        it { is_expected.to eq '90' }
      end
    end
  end
end
