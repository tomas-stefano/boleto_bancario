# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Santander do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:agencia).when('1', '12', '123', '1234') }
        it { should_not have_valid(:agencia).when('12345', '123456', nil, '') }

        it { should have_valid(:codigo_cedente).when('1', '12', '123', '1234567') }
        it { should_not have_valid(:codigo_cedente).when('12345678', '123456789', nil, '') }

        it { should have_valid(:numero_documento).when('1', '12', '123', '123456789112') }
        it { should_not have_valid(:numero_documento).when('1234567891123', nil, '') }

        it { should have_valid(:carteira).when('101', '102', '121', 101, 102, 121) }
        it { should_not have_valid(:carteira).when(nil, '', '05', '20', '100', '120') }

        it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Santander.new(agencia: '2') }

          it { expect(subject.agencia).to eq '0002' }
        end

        context "when is nil" do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Santander.new(codigo_cedente: '1') }

          it { expect(subject.codigo_cedente).to eq '0000001' }
        end

        context "when is nil" do
          it { expect(subject.codigo_cedente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Santander.new(numero_documento: '1') }

          it { expect(subject.numero_documento).to eq '000000000001' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Santander.new(carteira: '101') }

          it { expect(subject.carteira).to eq '101' }
        end

        context "when is nil" do
          it { expect(subject.carteira).to be nil }
        end
      end

      describe "#carteira_formatada" do
        context "when is registered" do
          subject { Santander.new(:carteira => 101) }

          it { expect(subject.carteira_formatada).to eq 'COBRANÇA SIMPLES ECR' }
        end

        context "when isn't registered" do
          subject { Santander.new(:carteira => 102) }

          it { expect(subject.carteira_formatada).to eq 'COBRANÇA SIMPLES CSR' }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '033' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '7' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Santander.new(agencia: '0235', codigo_cedente: '1625462') }

        it { expect(subject.agencia_codigo_cedente).to eq '0235 / 1625462' }
      end

      describe "#nosso_numero" do
        subject { Santander.new(numero_documento: '566612457800') }

        it { expect(subject.nosso_numero).to eq '566612457800-2' }
      end

      describe "#codigo_de_barras" do
        subject do
          Santander.new do |santander|
            santander.codigo_cedente   = '0707077'
            santander.numero_documento = '000001234567'
            santander.valor_documento  = 2952.95
            santander.carteira         = '102'
            santander.agencia          = 1333
            santander.data_vencimento  = Date.parse('2012-12-28')
          end
        end

        it { expect(subject.codigo_de_barras).to eq '03391556100002952959070707700000123456790102' }
        it { expect(subject.linha_digitavel).to eq '03399.07073 07700.000123 34567.901029 1 55610000295295' }
      end

      describe "#iof" do
        context "default iof" do
          it { expect(subject.iof).to eq '0' }
        end

        context "setting iof" do
          subject { Santander.new(iof: 7) }

          it { expect(subject.iof).to eq '7' }
        end
      end
    end
  end
end
