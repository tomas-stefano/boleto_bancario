require 'spec_helper'

module BoletoBancario
  module Calculos
    describe LinhaDigitavel do
      context "using the Itau documentation example" do
        subject { LinhaDigitavel.new('34196166700000123451091234567880057123457000') }

        it { should eq '34191.09123 34567.880058 71234.570001 6 16670000012345' }
      end

      context "using the Bradesco documentation example" do
        subject { LinhaDigitavel.new('99991101200000350007772130530150081897500000') }

        it { should eq '99997.77213 30530.150082 18975.000003 1 10120000035000' }
      end

      context "using the HSBC documentation example" do
        subject { LinhaDigitavel.new('39998100100000311551111122222500546666666001') }

        it { should eq '39991.11119 22222.500542 66666.660015 8 10010000031155' }
      end

      context "using the Caixa documentation example" do
        subject { LinhaDigitavel.new('10491107400000160000001100128701000901200200') }

        it { should eq '10490.00118 00128.701000 09012.002003 1 10740000016000' }
      end

      describe "when 'codigo_de_barras' invalid" do
        context "when is empty" do
          subject { LinhaDigitavel.new('') }

          it { should eq '' }
        end

        context "when nil" do
          subject { LinhaDigitavel.new(nil) }

          it { should eq '' }
        end

        context "when have less than 44 positions" do
          subject { LinhaDigitavel.new('121212121') }

          it { should eq '' }
        end

        context "when have more than 44 positions" do
          subject { LinhaDigitavel.new('12345678901234567890123456789012345678901234567890') }

          it { should eq '' }
        end
      end
    end
  end
end