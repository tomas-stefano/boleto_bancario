# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Boleto do
      describe '.model_name' do
        it 'returns Boleto' do
          expect(Boleto.model_name).to eq 'BoletoBancario::Core::Boleto'
        end
      end

      describe '.human_attribute_name' do
        it 'respond to internationalization attribute' do
          expect(Boleto).to respond_to(:human_attribute_name)
        end
      end

      describe '#to_partial_path' do
        subject(:boleto) { Boleto.new }

        it 'returns the path from class name' do
          expect(boleto.to_partial_path).to eq 'boleto_bancario/boleto'
        end
      end

      describe '#to_model' do
        subject(:boleto) { Boleto.new }

        it 'returns the same object for comparison purposes' do
          expect(boleto.to_model).to eq boleto
        end
      end

      describe '#initialize' do
        context 'when passing a Hash' do
          subject do
            described_class.new(
              :numero_documento => '191075',
              :valor_documento  => 101.99,
              :data_vencimento  => Date.new(2012, 10, 10),
              :carteira         => '175',
              :agencia          => '0098',
              :conta_corrente   => '98701',
              :cedente          => 'Nome da razao social',
              :sacado           => 'Teste',
              :documento_sacado => '725.275.005-10',
              :endereco_sacado  => 'Rua teste, 23045',
              :instrucoes1      => 'Lembrar de algo 1',
              :instrucoes2      => 'Lembrar de algo 2',
              :instrucoes3      => 'Lembrar de algo 3',
              :instrucoes4      => 'Lembrar de algo 4',
              :instrucoes5      => 'Lembrar de algo 5',
              :instrucoes6      => 'Lembrar de algo 6',
            )
          end

          it { expect(subject.numero_documento).to  eq '191075' }
          it { expect(subject.valor_documento).to   eq 101.99 }
          it { expect(subject.data_vencimento).to   eq Date.new(2012, 10, 10) }
          it { expect(subject.carteira).to          eq '175' }
          it { expect(subject.agencia).to           eq '0098' }
          it { expect(subject.conta_corrente).to    eq '98701' }
          it { expect(subject.codigo_moeda).to      eq '9' }
          it { expect(subject.cedente).to           eq 'Nome da razao social' }
          it { expect(subject.especie).to           eq 'R$' }
          it { expect(subject.especie_documento).to eq 'DM' }
          it { expect(subject.data_documento).to    eq Date.today }
          it { expect(subject.sacado).to            eq 'Teste' }
          it { expect(subject.documento_sacado).to  eq '725.275.005-10' }
          it { expect(subject.endereco_sacado).to   eq 'Rua teste, 23045' }
          it { expect(subject.local_pagamento).to   eq 'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO' }
          it { expect(subject.instrucoes1).to       eq 'Lembrar de algo 1' }
          it { expect(subject.instrucoes2).to       eq 'Lembrar de algo 2' }
          it { expect(subject.instrucoes3).to       eq 'Lembrar de algo 3' }
          it { expect(subject.instrucoes4).to       eq 'Lembrar de algo 4' }
          it { expect(subject.instrucoes5).to       eq 'Lembrar de algo 5' }
          it { expect(subject.instrucoes6).to       eq 'Lembrar de algo 6' }
        end

        context 'when passing a block' do
          subject do
            described_class.new do |boleto|
              boleto.numero_documento   = '187390'
              boleto.valor_documento    = 1
              boleto.data_vencimento    = Date.new(2012, 10, 10)
              boleto.carteira           = '109'
              boleto.agencia            = '0914'
              boleto.conta_corrente     = '82369'
              boleto.codigo_cedente     = '90182'
              boleto.endereco_cedente   = 'Rua Itapaiuna, 2434'
              boleto.cedente            = 'Nome da razao social'
              boleto.documento_cedente  = '62.526.713/0001-40'
              boleto.sacado             = 'Teste'
              boleto.instrucoes1        = 'Lembrar de algo 1'
              boleto.instrucoes2        = 'Lembrar de algo 2'
              boleto.instrucoes3        = 'Lembrar de algo 3'
              boleto.instrucoes4        = 'Lembrar de algo 4'
              boleto.instrucoes5        = 'Lembrar de algo 5'
              boleto.instrucoes6        = 'Lembrar de algo 6'
            end
          end

          it { expect(subject.numero_documento).to  eq '187390' }
          it { expect(subject.valor_documento).to   eq 1 }
          it { expect(subject.carteira).to          eq '109' }
          it { expect(subject.agencia).to           eq '0914' }
          it { expect(subject.conta_corrente).to    eq '82369' }
          it { expect(subject.codigo_moeda).to      eq '9' }
          it { expect(subject.codigo_cedente).to    eq '90182' }
          it { expect(subject.endereco_cedente).to  eq 'Rua Itapaiuna, 2434' }
          it { expect(subject.cedente).to           eq 'Nome da razao social' }
          it { expect(subject.documento_cedente).to eq '62.526.713/0001-40' }
          it { expect(subject.sacado).to            eq 'Teste' }
          it { expect(subject.aceite).to            be true }
          it { expect(subject.instrucoes1).to       eq 'Lembrar de algo 1' }
          it { expect(subject.instrucoes2).to       eq 'Lembrar de algo 2' }
          it { expect(subject.instrucoes3).to       eq 'Lembrar de algo 3' }
          it { expect(subject.instrucoes4).to       eq 'Lembrar de algo 4' }
          it { expect(subject.instrucoes5).to       eq 'Lembrar de algo 5' }
          it { expect(subject.instrucoes6).to       eq 'Lembrar de algo 6' }
        end
      end

      describe "#carteira_formatada" do
        it "returns 'carteira' as default" do
          subject.stub(:carteira).and_return('Foo')

          expect(subject.carteira_formatada).to eq 'Foo'
        end
      end

      describe "#valor_documento_formatado" do
        context "when period" do
          before { subject.stub(:valor_documento).and_return(123.45) }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000012345' }
        end

        context "when less than ten" do
          before { subject.stub(:valor_documento).and_return(5.0) }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000000500' }
        end

        context "when have many decimal points" do
          before { subject.stub(:valor_documento).and_return(10.999999) }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000001099' }
        end

        context "when integer" do
          before { subject.stub(:valor_documento).and_return(1_999) }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000199900' }
        end

        context "when period with string" do
          before { subject.stub(:valor_documento).and_return('236.91') }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000023691' }
        end

        context "when period with string with many decimals" do
          before { subject.stub(:valor_documento).and_return('10.999999') }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000001099' }
        end

        context "when the cents is not broken" do
          before { subject.stub(:valor_documento).and_return(229.5) }

          it { expect(subject.valor_formatado_para_codigo_de_barras).to eq '0000022950' }
        end
      end

      describe "#aceite_formatado" do
        context "when is true" do
          subject { described_class.new(aceite: true) }

          it { expect(subject.aceite_formatado).to eq 'S' }
        end

        context "when is false" do
          subject { described_class.new(aceite: false) }

          it { expect(subject.aceite_formatado).to eq 'N' }
        end

        context "when is nil" do
          subject { described_class.new(aceite: nil) }

          it { expect(subject.aceite_formatado).to eq 'N' }
        end
      end

      describe "#codigo_banco" do
        it { expect { subject.codigo_banco }.to raise_error(NotImplementedError) }
      end

      describe "#digito_codigo_banco" do
        it { expect { subject.digito_codigo_banco }.to raise_error(NotImplementedError) }
      end

      describe "#agencia_codigo_cedente" do
        it { expect { subject.agencia_codigo_cedente }.to raise_error(NotImplementedError) }
      end

      describe "#nosso_numero" do
        it { expect { subject.nosso_numero }.to raise_error(NotImplementedError) }
      end

      describe "#codigo_de_barras_do_banco" do
        it { expect { subject.codigo_de_barras_do_banco }.to raise_error(NotImplementedError) }
      end
    end
  end
end
