# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Documento do
      describe '.valid?' do
        context 'with valid CPF' do
          it { expect(Documento.valid?('111.444.777-35')).to be true }
          it { expect(Documento.valid?('11144477735')).to be true }
          it { expect(Documento.valid?('529.982.247-25')).to be true }
        end

        context 'with invalid CPF' do
          it { expect(Documento.valid?('111.111.111-11')).to be false }
          it { expect(Documento.valid?('123.456.789-00')).to be false }
          it { expect(Documento.valid?('000.000.000-00')).to be false }
        end

        context 'with valid CNPJ' do
          it { expect(Documento.valid?('11.222.333/0001-81')).to be true }
          it { expect(Documento.valid?('11222333000181')).to be true }
          it { expect(Documento.valid?('64.132.916/0001-88')).to be true }
        end

        context 'with invalid CNPJ' do
          it { expect(Documento.valid?('11.111.111/1111-11')).to be false }
          it { expect(Documento.valid?('12.345.678/0001-00')).to be false }
          it { expect(Documento.valid?('00.000.000/0000-00')).to be false }
        end

        context 'with blank value' do
          it { expect(Documento.valid?(nil)).to be false }
          it { expect(Documento.valid?('')).to be false }
        end

        context 'with invalid size' do
          it { expect(Documento.valid?('123')).to be false }
          it { expect(Documento.valid?('12345678901234567890')).to be false }
        end
      end

      describe '.format' do
        context 'with CPF' do
          it { expect(Documento.format('11144477735')).to eq '111.444.777-35' }
          it { expect(Documento.format('529.982.247-25')).to eq '529.982.247-25' }
        end

        context 'with CNPJ' do
          it { expect(Documento.format('11222333000181')).to eq '11.222.333/0001-81' }
          it { expect(Documento.format('64.132.916/0001-88')).to eq '64.132.916/0001-88' }
        end

        context 'with invalid size' do
          it { expect(Documento.format('123')).to eq '123' }
        end

        context 'with blank value' do
          it { expect(Documento.format(nil)).to be_nil }
          it { expect(Documento.format('')).to eq '' }
        end
      end

      describe '.cpf?' do
        it { expect(Documento.cpf?('11144477735')).to be true }
        it { expect(Documento.cpf?('111.444.777-35')).to be true }
        it { expect(Documento.cpf?('11222333000181')).to be false }
      end

      describe '.cnpj?' do
        it { expect(Documento.cnpj?('11222333000181')).to be true }
        it { expect(Documento.cnpj?('11.222.333/0001-81')).to be true }
        it { expect(Documento.cnpj?('11144477735')).to be false }
      end
    end
  end
end
