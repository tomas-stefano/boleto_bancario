require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo11FatorDe2a9 do
      context 'with Itau example' do
        subject { Modulo11FatorDe2a9.new('3419166700000123451101234567880057123457000') }

        it { should eq '6' }
      end

      context 'with Bradesco example' do
        subject { Modulo11FatorDe2a9.new('9999101200000350007772130530150081897500000') }

        it { should eq '1' }
      end

      context 'with Banco Brasil example' do
        subject { Modulo11FatorDe2a9.new('0019373700000001000500940144816060680935031') }

        it { should eq '3' }
      end

      context 'with Caixa example' do
        subject { Modulo11FatorDe2a9.new('1049107400000160000001100128701000901200200') }

        it { should eq '1' }
      end

      context 'with Banrisul example' do
        subject { Modulo11FatorDe2a9.new('0419100100000550002110000000012283256304168') }

        it { should eq '1' }
      end

      context 'when calculations returns 11' do
        subject { Modulo11FatorDe2a9.new('1049107400000160000001100128701000901200298') }

        it { should eq '1' }
      end

      context 'when calculations returns 1' do
        subject { Modulo11FatorDe2a9.new('1049107400000160000001100128701000901244437') }

        it { should eq '1' }
      end

      context 'with one digit' do
        subject { Modulo11FatorDe2a9.new('1') }

        it { should eq '9' }
      end

      context 'with two digits' do
        subject { Modulo11FatorDe2a9.new('91') }

        it { should eq '4' }
      end

      context 'with three digits' do
        subject { Modulo11FatorDe2a9.new('189') }

        it { should eq '9' }
      end
    end
  end
end