# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Caixa do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:agencia).when(1, 1234, '1', '1234') }
        it { should_not have_valid(:agencia).when(12345, '12345', nil, '') }

        it { should have_valid(:codigo_cedente).when(1, 123456, '1', '123456') }
        it { should_not have_valid(:codigo_cedente).when(1234567, '1234567', nil, '') }

        it { should have_valid(:carteira).when(14, 24, '14', '24') }
        it { should_not have_valid(:carteira).when(nil, '', 5, 20, '20', '100') }

        it { should have_valid(:numero_documento).when(1, 123456789112345, '1', '123456789112345') }
        it { should_not have_valid(:numero_documento).when(nil, '', 1234567891123456, '1234567891123456') }

        it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 9_999_999.99, '100.99') }
        it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 10_000_000.00) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Caixa.new(agencia: 2) }

          it { expect(subject.agencia).to eq '0002' }
        end

        context "when is nil" do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Caixa.new(codigo_cedente: '1') }

          it { expect(subject.codigo_cedente).to eq '000001' }
        end

        context "when is nil" do
          it { expect(subject.codigo_cedente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Caixa.new(numero_documento: 1234) }

          it { expect(subject.numero_documento).to eq '000000000001234' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Caixa.new(carteira: '24') }

          it { expect(subject.carteira).to eq '24' }
        end

        context "when is nil" do
          it { expect(subject.carteira).to be nil }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '104' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '0' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Caixa.new(agencia: '0235', codigo_cedente: '162546') }

        it { expect(subject.agencia_codigo_cedente).to eq '0235 / 162546-2' }
      end

      describe "#nosso_numero" do
        subject { Caixa.new(carteira: '24', numero_documento: '863245679215648') }

        it { expect(subject.nosso_numero).to eq '24863245679215648-2' }
      end

      describe "#codigo_de_barras" do
        subject do
          Caixa.new do |caixa|
            caixa.agencia          = 1333
            caixa.codigo_cedente   = '792157'
            caixa.carteira         = '14'
            caixa.numero_documento = '946375189643625'
            caixa.valor_documento  = 2952.95
            caixa.data_vencimento  = Date.parse('2015-03-16')
          end
        end

        it { expect(subject.codigo_de_barras).to eq '10492636900002952957921578946137541896436250' }
        it { expect(subject.linha_digitavel).to eq '10497.92151 78946.137540 18964.362505 2 63690000295295' }
      end
    end
  end
end
