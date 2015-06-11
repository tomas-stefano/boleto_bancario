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

        it { should have_valid(:carteira).when('03', 'C') }
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

          it { expect(subject.agencia).to eq '0530' }
        end

        context "when is nil" do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Sicredi.new(conta_corrente: '96') }

          it { expect(subject.conta_corrente).to eq '00096' }
        end

        context "when is nil" do
          it { expect(subject.conta_corrente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Sicredi.new(numero_documento: '1') }

          it { expect(subject.numero_documento).to eq '00001' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Sicredi.new(carteira: '03') }

          it { expect(subject.carteira).to eq '03' }
        end

        context "when is nil" do
          it { expect(subject.carteira).to be nil }
        end
      end

      describe "#carteira_formatada" do
        context "when is registered" do
          subject { Sicredi.new(carteira: '03') }

          it { expect(subject.carteira_formatada).to eq '1' }
        end

        context "when isn't registered" do
          subject { Sicredi.new(carteira: 'C') }

          it { expect(subject.carteira_formatada).to eq '1' }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '748' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq 'X' }
      end

      describe "#tipo_cobranca" do
        it { expect(subject.tipo_cobranca).to eq '3' }
      end

      describe "#tipo_carteira" do
        it { expect(subject.tipo_carteira).to eq '1' }
      end

      describe "#agencia_codigo_beneficiario" do
        subject { Sicredi.new(agencia: '7190', posto: 2, conta_corrente: '25439') }

        it { expect(subject.agencia_codigo_cedente).to eq '7190.02.25439' }
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

        it { expect(subject.nosso_numero).to eq '15/972815-9' }
      end

      describe "#codigo_de_barras" do
        subject do
          Sicredi.new do |sicredi|
            sicredi.agencia          = '8136'
            sicredi.conta_corrente   = '62918'
            sicredi.posto            = 34
            sicredi.byte_id          = 3
            sicredi.carteira         = '03'
            sicredi.numero_documento = 87264
            sicredi.valor_documento  = 8013.65
            sicredi.data_vencimento  = Date.parse('2006-10-29')
          end
        end

        it { expect(subject.codigo_de_barras).to eq '74894330900008013653115387264581363462918104' }
        it { expect(subject.linha_digitavel).to eq '74893.11535 87264.581361 34629.181040 4 33090000801365' }
      end
    end
  end
end
