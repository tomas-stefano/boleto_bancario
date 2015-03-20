# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Sicredi do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:agencia).when('1', '12', '123', '1234') }
        it { should_not have_valid(:agencia).when('12345', '123456', nil, '') }

        it { should have_valid(:conta_corrente).when('1', '12', '123', '12345') }
        it { should_not have_valid(:conta_corrente).when('123456', '1234567', nil, '') }

        it { should have_valid(:numero_documento).when('1', '12', '123', '12345') }
        it { should_not have_valid(:numero_documento).when('123456', nil, '') }

        it { should have_valid(:carteira).when('11', '31', 11, 31) }
        it { should_not have_valid(:carteira).when(nil, '', '05', '20', '100', '120') }

        it { should have_valid(:posto).when('1', '56', 34, 99) }
        it { should_not have_valid(:posto).when(nil, '', '100', 100) }

        it { should have_valid(:byte_id).when('2', 2, 5, '9') }
        it { should_not have_valid(:byte_id).when(nil, '', '1', 1, 10, '100') }

        it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Sicredi.new(agencia: '530') }

          its(:agencia) { should eq '0530' }
        end

        context "when is nil" do
          its(:agencia) { should be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Sicredi.new(conta_corrente: '96') }

          its(:conta_corrente) { should eq '00096' }
        end

        context "when is nil" do
          its(:conta_corrente) { should be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Sicredi.new(numero_documento: '1') }

          its(:numero_documento) { should eq '00001' }
        end

        context "when is nil" do
          its(:numero_documento) { should be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Sicredi.new(carteira: '11') }

          its(:carteira) { should eq '11' }
        end

        context "when is nil" do
          its(:carteira) { should be nil }
        end
      end

      describe "#carteira_formatada" do
        context "when is registered" do
          subject { Sicredi.new(carteira: 11) }

          its(:carteira_formatada) { should eq '1' }
        end

        context "when isn't registered" do
          subject { Sicredi.new(carteira: 31) }

          its(:carteira_formatada) { should eq '1' }
        end
      end

      describe "#codigo_banco" do
        its(:codigo_banco) { should eq '748' }
      end

      describe "#digito_codigo_banco" do
        its(:digito_codigo_banco) { should eq 'X' }
      end

      describe "#agencia_codigo_beneficiario" do
        subject { Sicredi.new(agencia: '7190', posto: 2, conta_corrente: '25439') }

        its(:agencia_codigo_cedente) { should eq '7190.02.25439' }
      end

      describe "#nosso_numero" do
        subject do
          Sicredi.new do |sicredi|
            sicredi.agencia          = 4927
            sicredi.posto            = '99'
            sicredi.conta_corrente   = 24837
            sicredi.byte_id          = '9'
            sicredi.numero_documento = '72815'
          end
        end

        its(:nosso_numero) { should eq '15/972815-9' }
      end

      describe "#codigo_de_barras" do
        subject do
          Sicredi.new do |sicredi|
            sicredi.agencia          = '8136'
            sicredi.conta_corrente   = '62918'
            sicredi.posto            = 34
            sicredi.byte_id          = 3
            sicredi.carteira         = '31'
            sicredi.numero_documento = 87264
            sicredi.valor_documento  = 8013.65
            sicredi.data_vencimento  = Date.parse('2006-10-29')
          end
        end

        its(:codigo_de_barras) { should eq '74894330900008013653115387264581363462918104' }
        its(:linha_digitavel)  { should eq '74893.11535 87264.581361 34629.181040 4 33090000801365' }
      end
    end
  end
end
