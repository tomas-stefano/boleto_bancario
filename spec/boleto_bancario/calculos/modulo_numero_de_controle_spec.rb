require 'spec_helper'

module BoletoBancario
  module Calculos
    describe ModuloNumeroDeControle do
      context "when is simple calculation" do
        subject { ModuloNumeroDeControle.new('00009274') }

        it { should eq '22' }
      end

      context "another example" do
        subject { ModuloNumeroDeControle.new('0000001') }

        it { should eq '83' }
      end

      context "example with second digit invalid" do
        subject { ModuloNumeroDeControle.new('00009194') }

        it { should eq '38' }
      end

      context "example with second digit invalid and first digit with '9'" do
        subject { ModuloNumeroDeControle.new('411') }

        it { should eq '06' }
      end

      context 'should calculate when the first digit is not 10 (ten)' do
        subject { ModuloNumeroDeControle.new('5') }

        it { should eq '90' }
      end
    end
  end
end