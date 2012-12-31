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

        it "digito agencia should have 2 digits (NC)" do
          should have_valid(:digito_agencia).when("12")
          should_not have_valid(:digito_agencia).when(nil, "", "1", "123")
        end

        it "codigo cedente should have 07 digits" do
          should have_valid(:codigo_cedente).when("1234567", "12", "12345")
          should_not have_valid(:codigo_cedente).when(nil, "", "12345678", "123456789")
        end

        it "numero_controle_codigo_cedente should have 2 digits" do
          should have_valid(:digito_codigo_cedente).when("12")
          should_not have_valid(:digito_codigo_cedente).when(nil, "", "1", "123", "1234")
        end

        it "numero documento should have 8 digits" do
          should have_valid(:numero_documento).when("12345678", "1234")
          should_not have_valid(:numero_documento).when(nil, "", "123456789")
        end
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Banrisul.new(agencia: '34') }

          its(:agencia) { should eq '034' }
        end

        context "when is nil" do
          subject { Banrisul.new(agencia: nil) }

          its(:agencia) { should be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Banrisul.new(numero_documento: '1234') }

          its(:numero_documento) { should eq '00001234' }
        end

        context "when is nil" do
          subject { Banrisul.new(numero_documento: nil) }

          its(:numero_documento) { should be nil }
        end
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Banrisul.new(codigo_cedente: '1234') }

          its(:codigo_cedente) { should eq '0001234' }
        end

        context "when is nil" do
          subject { Banrisul.new(codigo_cedente: nil) }

          its(:codigo_cedente) { should be nil }
        end
      end

      describe "#codigo_banco" do
        its(:codigo_banco) { should eq '041' }
      end

      describe "#digito_codigo_banco" do
        its(:digito_codigo_banco) { should eq '8' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Banrisul.new(agencia: '100', digito_agencia: '81', codigo_cedente: '0000001', digito_codigo_cedente: '83') }

        its(:agencia_codigo_cedente) { should eq '100.81 0000001.83' }
      end

      describe "#nosso_numero" do
        context "using one example from documentation" do
          subject { Banrisul.new(numero_documento: '00009194') }

          its(:nosso_numero) { should eq '00009194.38' }
        end

        context "using other example from documentation" do
          subject { Banrisul.new(numero_documento: '00009274') }

          its(:nosso_numero) { should eq '00009274.22' }
        end

        context "another example" do
          subject { Banrisul.new(numero_documento: '22832563') }

          its(:nosso_numero) { should eq '22832563.51' }
        end
      end

      describe "#codigo_de_barras" do
        context "one example" do
          subject do
            Banrisul.new do |boleto|
              boleto.numero_documento = 22832563
              boleto.agencia          = 100
              boleto.digito_agencia   = 81
              boleto.data_vencimento  = Date.parse('2004-07-04')
              boleto.codigo_cedente   = "0000001"
              boleto.valor_documento  = 5.0
            end
          end

          its(:codigo_de_barras) { should eq '04197246200000005002110000000012283256304168' }
          its(:linha_digitavel)  { should eq '04192.11008 00000.012286 32563.041683 7 24620000000500' }
        end
      end
    end
  end
end