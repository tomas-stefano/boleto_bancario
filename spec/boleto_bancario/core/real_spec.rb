# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Real do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:agencia).when('1', '12', '123', '1234') }
        it { should_not have_valid(:agencia).when('12345', '123456', nil, '') }

        it { should have_valid(:conta_corrente).when('1', '12', '123', '1234567') }
        it { should_not have_valid(:conta_corrente).when('12345678', '123456789', nil, '') }

        it { should have_valid(:numero_documento).when('1', '12', '123', '1234567891123') }
        it { should_not have_valid(:numero_documento).when('12345678911234', nil, '') }

        it { should have_valid(:carteira).when('0', 20, '31', 42, '47', 85) }
        it { should_not have_valid(:carteira).when(nil, '1', 2, '123') }

        it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Real.new(agencia: '802') }

          it { expect(subject.agencia).to eq '0802' }
        end

        context "when is nil" do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Real.new(conta_corrente: '1625') }

          it { expect(subject.conta_corrente).to eq '0001625' }
        end

        context "when is nil" do
          it { expect(subject.conta_corrente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Real.new(numero_documento: '2483169') }

          it { expect(subject.numero_documento).to eq '0000002483169' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Real.new(carteira: '20') }

          it { expect(subject.carteira).to eq '20' }
        end

        context "when is nil" do
          it { expect(subject.carteira).to be nil }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '356' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '5' }
      end

      describe "#agencia_codigo_beneficiario" do
        subject { Real.new(agencia: '501', conta_corrente: 6703255) }

        it { expect(subject.agencia_codigo_cedente).to eq '0501/6703255/1' }
      end

      describe "#codigo_de_barras" do
        subject do
          Real.new do |real|
            real.agencia          = 501
            real.conta_corrente   = '6703255'
            real.numero_documento = 3020
            real.valor_documento  = 35
            real.data_vencimento  = Date.parse('2001-10-02')
          end
        end

        it { expect(subject.codigo_de_barras).to eq '35699145600000035000501670325510000000003020' }
        it { expect(subject.linha_digitavel).to eq '35690.50168 70325.510009 00000.030205 9 14560000003500' }
      end
    end
  end
end
