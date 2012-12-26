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

        it { should have_valid(:carteira).when('1', '12', '123') }
        it { should_not have_valid(:carteira).when('1234', nil, '') }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Santander.new(agencia: '2') }

          its(:agencia) { should eq '0002' }
        end

        context "when is nil" do
          its(:agencia) { should be nil }
        end
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Santander.new(codigo_cedente: '1') }

          its(:codigo_cedente) { should eq '0000001' }
        end

        context "when is nil" do
          its(:codigo_cedente) { should be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Santander.new(numero_documento: '1') }

          its(:numero_documento) { should eq '000000000001' }
        end

        context "when is nil" do
          its(:numero_documento) { should be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Santander.new(carteira: '1') }

          its(:carteira) { should eq '001' }
        end

        context "when is nil" do
          its(:carteira) { should be nil }
        end
      end

      describe "#carteira_formatada" do
        context "when is registered" do
          subject { Santander.new(:carteira => 101) }

          its(:carteira_formatada) { should eq 'COBRANÇA SIMPLES ECR' }
        end

        context "when isn't registered" do
          subject { Santander.new(:carteira => 102) }

          its(:carteira_formatada) { should eq 'COBRANÇA SIMPLES CSR' }
        end
      end

      describe "#codigo_banco" do
        its(:codigo_banco) { should eq '033' }
      end

      describe "#digito_codigo_banco" do
        its(:digito_codigo_banco) { should eq '7' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Santander.new(agencia: '0235', digito_agencia: '6', codigo_cedente: '1625462') }

        its(:agencia_codigo_cedente) { should eq '0235-6 / 1625462' }
      end

      describe "#nosso_numero" do
        subject { Santander.new(numero_documento: '566612457800') }

        its(:nosso_numero) { should eq '566612457800-2' }
      end

      describe "#codigo_de_barras" do
        subject do
          Santander.new do |santander|
            santander.codigo_cedente   = '0707077'
            santander.numero_documento = '000001234567'
            santander.valor_documento  = 2952.95
            santander.carteira         = '102'
            santander.agencia          = 1333
            santander.digito_agencia   = 1
            santander.data_vencimento  = Date.parse('2012-12-28')
          end
        end

        its(:codigo_de_barras) { should eq '03391556100002952959070707700000123456790102' }
        its(:linha_digitavel)  { should eq '03399.07073 07700.000123 34567.901029 1 55610000295295' }
      end

      describe "#iof" do
        context "default iof" do
          its(:iof) { should eq '0' }
        end

        context "setting iof" do
          subject { Santander.new(iof: 7) }

          its(:iof) { should eq '7' }
        end
      end
    end
  end
end