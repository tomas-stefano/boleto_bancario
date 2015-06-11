# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Hsbc do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:codigo_cedente).when(1, 1234567, '1', '1234567') }
        it { should_not have_valid(:codigo_cedente).when(12345678, '12345678', nil, '') }

        it { should have_valid(:numero_documento).when(1, 1234567891123, '1', '1234567891123') }
        it { should_not have_valid(:numero_documento).when(nil, '', 12345678911234, '12345678911234') }

        it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.00) }

        it { should have_valid(:carteira).when('CNR') }
        it { should_not have_valid(:carteira).when(nil, '', '5', 'CSB') }
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Hsbc.new(codigo_cedente: '1') }

          it { expect(subject.codigo_cedente).to eq '0000001' }
        end

        context "when is nil" do
          it { expect(subject.codigo_cedente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Hsbc.new(numero_documento: 1234) }

          it { expect(subject.numero_documento).to eq '0000000001234' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      it { expect(subject.codigo_banco).to eq '399' }

      it { expect(subject.digito_codigo_banco).to eq '9' }

      describe "#nosso_numero" do
        subject { Hsbc.new(codigo_cedente: '7984135', numero_documento: '4716881775613', data_vencimento: Date.parse('2009-05-22')) }

        it { expect(subject.nosso_numero).to eq '4716881775613440' }
      end

      describe "#codigo_de_barras" do
        subject do
          Hsbc.new do |hsbc|
            hsbc.codigo_cedente   = 3485910
            hsbc.numero_documento = '43862'
            hsbc.valor_documento  = 3740.58
            hsbc.data_vencimento  = Date.parse('2024-02-18')
          end
        end

        it { expect(subject.codigo_de_barras).to eq '39991963000003740583485910000000004386204942' }
        it { expect(subject.linha_digitavel).to eq '39993.48596 10000.000009 43862.049426 1 96300000374058' }
      end
    end
  end
end
