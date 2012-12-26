require 'spec_helper'

module BoletoBancario
  module Calculos
    describe FatoresDeMultiplicacao do
      context 'with factors of 2 and 1' do
        let(:factors) { [2, 1] }

        context 'with one digit' do
          subject { FatoresDeMultiplicacao.new(1, fatores: factors) }

          it { should eq [2] }
        end

        context 'with four digits' do
          subject { FatoresDeMultiplicacao.new(1234, fatores: factors) }

          it { should eq [1, 4, 3, 8] }
        end

        context 'with five digits' do
          subject { FatoresDeMultiplicacao.new(11385, fatores: factors) }

          it { should eq [2, 1, 6, 8, 10] }
        end

        context 'with ten digits' do
          subject { FatoresDeMultiplicacao.new(1234567890, fatores: factors) }

          it { should eq [1, 4, 3, 8, 5, 12, 7, 16, 9, 0] }
        end
      end

      context 'with factors of 2..9' do
        let(:factors) { (2..9).to_a }

        context 'with one digit' do
          subject { FatoresDeMultiplicacao.new(4, fatores: factors) }

          it { should eq [8] }
        end

        context 'with four digits' do
          subject { FatoresDeMultiplicacao.new(1864, fatores: factors) }

          it { should eq [ 5, 32, 18, 8] }
        end

        context 'with ten digits' do
          subject { FatoresDeMultiplicacao.new(1234567890, fatores: factors) }
        end

        context 'with bradesco documentation example' do
          let(:bradesco_example) { '9999101200000350007772130530150081897500000' }
          subject { FatoresDeMultiplicacao.new(bradesco_example, fatores: factors) }

          it { should eq [36, 27, 18, 81, 8, 0, 6, 10, 0, 0, 0, 0, 0, 21, 30, 0, 0, 0, 14, 63, 56, 14, 6, 15, 0, 15, 6, 0, 8, 35, 0, 0, 32, 3, 16, 81, 56, 35, 0, 0, 0, 0, 0] }
        end

        context 'with itau documentation example' do
          let(:itau_example) { '3419166700000123451101234567880057123457000' }
          subject { FatoresDeMultiplicacao.new(itau_example, fatores: factors) }

          it { should eq [12, 12, 2, 81, 8, 42, 36, 35, 0, 0, 0, 0, 0, 7, 12, 15, 16, 15, 2, 9, 0, 7, 12, 15, 16, 15, 12, 63, 64, 56, 0, 0, 20, 21, 2, 18, 24, 28, 30, 35, 0, 0, 0] }
        end
      end
    end
  end
end