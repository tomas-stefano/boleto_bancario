require 'spec_helper'

module BoletoBancario
  module Core
    describe Banrisul do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it "agencia should have 3 digits" do
          should have_valid(:agencia).when("1", "123", 1, 123)
          should_not have_valid(:agencia).when(nil, "", "1234")
        end

        it "codigo cedente should have 07 digits" do
          should have_valid(:codigo_cedente).when("1234567", "12", "12345")
          should_not have_valid(:codigo_cedente).when(nil, "", "12345678", "123456789")
        end

        it "numero documento should have 8 digits" do
          should have_valid(:numero_documento).when("12345678", "1234")
          should_not have_valid(:numero_documento).when(nil, "", "123456789")
        end

        it "carteira is supported" do
          should have_valid(:carteira).when('00', '08', 0, 8)
          should_not have_valid(:carteira).when(nil, '', '5', '20', '100')
        end

        describe "#valor_documento" do
          it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
          it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
        end
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Banrisul.new(agencia: '34') }

          it { expect(subject.agencia).to eq '034' }
        end

        context "when is nil" do
          subject { Banrisul.new(agencia: nil) }

          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Banrisul.new(numero_documento: '1234') }

          it { expect(subject.numero_documento).to eq '00001234' }
        end

        context "when is nil" do
          subject { Banrisul.new(numero_documento: nil) }

          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Banrisul.new(codigo_cedente: '1234') }

          it { expect(subject.codigo_cedente).to eq '0001234' }
        end

        context "when is nil" do
          subject { Banrisul.new(codigo_cedente: nil) }

          it { expect(subject.codigo_cedente).to be nil }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '041' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '8' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Banrisul.new(agencia: '100', codigo_cedente: '0000001') }

        it { expect(subject.agencia_codigo_cedente).to eq '100.81 0000001.83' }
      end

      describe "#nosso_numero" do
        context "using one example from documentation" do
          subject { Banrisul.new(numero_documento: '00009194') }

          it { expect(subject.nosso_numero).to eq '00009194.38' }
        end

        context "using other example from documentation" do
          subject { Banrisul.new(numero_documento: '00009274') }

          it { expect(subject.nosso_numero).to eq '00009274.22' }
        end

        context "another example" do
          subject { Banrisul.new(numero_documento: '22832563') }

          it { expect(subject.nosso_numero).to eq '22832563.51' }
        end
      end

      describe "#codigo_de_barras" do
        context "one example" do
          subject do
            Banrisul.new do |boleto|
              boleto.numero_documento = 22832563
              boleto.agencia          = 100
              boleto.data_vencimento  = Date.parse('2004-07-04')
              boleto.codigo_cedente   = "0000001"
              boleto.valor_documento  = 5.0
            end
          end

          it { expect(subject.codigo_de_barras).to eq '04197246200000005002110000000012283256304168' }
          it { expect(subject.linha_digitavel).to eq '04192.11008 00000.012286 32563.041683 7 24620000000500' }
        end
      end
    end
  end
end
