# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Core
    describe C6Bank do
      it_behaves_like 'boleto bancario'

      describe 'on validations' do
        it { is_expected.to have_valid(:agencia).when('1', '123', '1234') }
        it { is_expected.not_to have_valid(:agencia).when('12345', nil, '') }

        it { is_expected.to have_valid(:conta_corrente).when('1', '123456', '1234567890') }
        it { is_expected.not_to have_valid(:conta_corrente).when('12345678901', nil, '') }

        it { is_expected.to have_valid(:numero_documento).when('12345678911', '1234567', '123') }
        it { is_expected.not_to have_valid(:numero_documento).when('', nil, '123456789012') }

        it { is_expected.to have_valid(:carteira).when('1') }
        it { is_expected.not_to have_valid(:carteira).when(nil, '', '2', '100') }

        it { is_expected.to have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { is_expected.not_to have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
      end

      describe '#agencia' do
        context 'when have a value' do
          subject { C6Bank.new(agencia: '1') }

          it { expect(subject.agencia).to eq '0001' }
        end

        context 'when is nil' do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe '#conta_corrente' do
        context 'when have a value' do
          subject { C6Bank.new(conta_corrente: '12345') }

          it { expect(subject.conta_corrente).to eq '0000012345' }
        end

        context 'when is nil' do
          it { expect(subject.conta_corrente).to be nil }
        end
      end

      describe '#numero_documento' do
        context 'when have a value' do
          subject { C6Bank.new(numero_documento: '1234') }

          it { expect(subject.numero_documento).to eq '00000001234' }
        end

        context 'when is nil' do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe '#codigo_banco' do
        it { expect(subject.codigo_banco).to eq '336' }
      end

      describe '#digito_codigo_banco' do
        it { expect(subject.digito_codigo_banco).to eq '5' }
      end

      describe '#agencia_codigo_cedente' do
        subject { C6Bank.new(agencia: '0001', conta_corrente: '1234567890') }

        it { expect(subject.agencia_codigo_cedente).to eq '0001 / 1234567890-3' }
      end

      describe '#nosso_numero' do
        subject { C6Bank.new(numero_documento: '12345678') }

        it { expect(subject.nosso_numero).to eq '00012345678-9' }
      end

      describe '#to_partial_path' do
        it { expect(subject.to_partial_path).to eq 'boleto_bancario/c6_bank' }
      end
    end
  end
end
