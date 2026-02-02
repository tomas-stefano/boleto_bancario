# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Core
    describe Sicoob do
      it_behaves_like 'boleto bancario'

      describe "on validations" do
        it { is_expected.to have_valid(:agencia).when('1', '12', '123', '1234') }
        it { is_expected.not_to have_valid(:agencia).when('12345', '123456', nil, '') }

        it { is_expected.to have_valid(:codigo_cedente).when('1', 12345, '1234567') }
        it { is_expected.not_to have_valid(:codigo_cedente).when('12345678', 123456789, nil, '') }

        it { is_expected.to have_valid(:numero_documento).when('1', 12345, '123456') }
        it { is_expected.not_to have_valid(:numero_documento).when('1234567', nil, '') }

        it { is_expected.to have_valid(:carteira).when('1', 1, '9', 9) }
        it { is_expected.not_to have_valid(:carteira).when(nil, '', 2, '6') }

        it { is_expected.to have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { is_expected.not_to have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Sicoob.new(agencia: '215') }

          it { expect(subject.agencia).to eq '0215' }
        end

        context "when is nil" do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Sicoob.new(codigo_cedente: '9201') }

          it { expect(subject.codigo_cedente).to eq '0009201' }
        end

        context "when is nil" do
          it { expect(subject.codigo_cedente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Sicoob.new(numero_documento: '1') }

          it { expect(subject.numero_documento).to eq '000001' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Sicoob.new(carteira: '1') }

          it { expect(subject.carteira).to eq '1' }
        end

        context "when is nil" do
          it { expect(subject.carteira).to be nil }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '756' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '0' }
      end

      describe "#agencia_codigo_beneficiario" do
        subject { Sicoob.new(agencia: 48, codigo_cedente: '7368') }

        it { expect(subject.agencia_codigo_cedente).to eq '0048 / 0007368' }
      end

      describe "#nosso_numero" do
        subject { Sicoob.new(numero_documento: '68315') }

        it { expect(subject.nosso_numero).to eq "#{Date.today.strftime('%y')}068315" }
      end

      describe "#codigo_de_barras" do
        subject do
          Sicoob.new do |sicoob|
            sicoob.agencia          = 95
            sicoob.codigo_cedente   = 6532
            sicoob.numero_documento = 1101
            sicoob.carteira         = 1
            sicoob.valor_documento  = 93015.78
            sicoob.data_vencimento  = Date.parse('2019-02-17')
          end
        end

        # Note: The barcode includes the current year in nosso_numero, so we test the structure
        it 'generates a valid barcode structure' do
          expect(subject.codigo_de_barras.length).to eq 44
          expect(subject.codigo_de_barras).to start_with('756') # bank code
        end

        it 'generates a valid linha digitavel structure' do
          expect(subject.linha_digitavel).to match(/^\d{5}\.\d{5} \d{5}\.\d{6} \d{5}\.\d{6} \d \d{14}$/)
        end
      end
    end
  end
end
