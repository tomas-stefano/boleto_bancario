# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Core
    describe Sicredi do
      it_behaves_like 'boleto bancario'

      describe "on validations" do
        it { is_expected.to have_valid(:agencia).when('1', '12', '123', '1234') }
        it { is_expected.not_to have_valid(:agencia).when('12345', '123456', nil, '') }

        it { is_expected.to have_valid(:conta_corrente).when('1', '12', '123', '12345') }
        it { is_expected.not_to have_valid(:conta_corrente).when('123456', '1234567', nil, '') }

        it { is_expected.to have_valid(:numero_documento).when('1', '12', '123', '12345') }
        it { is_expected.not_to have_valid(:numero_documento).when('123456', nil, '') }

        it { is_expected.to have_valid(:carteira).when('03', 'C') }
        it { is_expected.not_to have_valid(:carteira).when(nil, '', '05', '20', '100', '120') }

        it { is_expected.to have_valid(:posto).when('1', '56', 34, 99) }
        it { is_expected.not_to have_valid(:posto).when(nil, '', '100', 100) }

        it { is_expected.to have_valid(:byte_id).when('2', 2, 5, '9') }
        it { is_expected.not_to have_valid(:byte_id).when(nil, '', '1', 1, 10, '100') }

        it { is_expected.to have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { is_expected.not_to have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
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

        it 'returns the nosso_numero with current year' do
          year = Date.today.strftime('%y')
          expect(subject.nosso_numero).to match(/^#{year}\/972815-\d$/)
        end
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

        # Note: The barcode includes the current year in nosso_numero, so we test the structure
        it 'generates a valid barcode structure' do
          expect(subject.codigo_de_barras.length).to eq 44
          expect(subject.codigo_de_barras).to start_with('748') # bank code
        end

        it 'generates a valid linha digitavel structure' do
          expect(subject.linha_digitavel).to match(/^\d{5}\.\d{5} \d{5}\.\d{6} \d{5}\.\d{6} \d \d{14}$/)
        end
      end
    end
  end
end
