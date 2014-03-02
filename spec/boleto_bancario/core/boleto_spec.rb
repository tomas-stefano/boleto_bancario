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
              :digito_agencia   => '1',
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

          its(:numero_documento)  { should eq '191075' }
          its(:valor_documento)   { should eq 101.99 }
          its(:data_vencimento)   { should eq Date.new(2012, 10, 10) }
          its(:carteira)          { should eq '175' }
          its(:agencia)           { should eq '0098' }
          its(:digito_agencia)    { should eq '1' }
          its(:conta_corrente)    { should eq '98701' }
          its(:codigo_moeda)      { should eq '9' }
          its(:cedente)           { should eq 'Nome da razao social' }
          its(:especie)           { should eq 'R$' }
          its(:especie_documento) { should eq 'DM' }
          its(:data_documento)    { should eq Date.today }
          its(:sacado)            { should eq 'Teste' }
          its(:documento_sacado)  { should eq '725.275.005-10' }
          its(:endereco_sacado)   { should eq 'Rua teste, 23045'}
          its(:local_pagamento)   { should eq 'PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO' }
          its(:instrucoes1)       { should eq 'Lembrar de algo 1'}
          its(:instrucoes2)       { should eq 'Lembrar de algo 2'}
          its(:instrucoes3)       { should eq 'Lembrar de algo 3'}
          its(:instrucoes4)       { should eq 'Lembrar de algo 4'}
          its(:instrucoes5)       { should eq 'Lembrar de algo 5'}
          its(:instrucoes6)       { should eq 'Lembrar de algo 6'}

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

          its(:numero_documento)  { should eq '187390' }
          its(:valor_documento)   { should eq 1 }
          its(:carteira)          { should eq '109' }
          its(:agencia)           { should eq '0914' }
          its(:conta_corrente)    { should eq '82369' }
          its(:codigo_moeda)      { should eq '9' }
          its(:codigo_cedente)    { should eq '90182' }
          its(:endereco_cedente)  { should eq 'Rua Itapaiuna, 2434' }
          its(:cedente)           { should eq 'Nome da razao social' }
          its(:documento_cedente) { should eq '62.526.713/0001-40' }
          its(:sacado)            { should eq 'Teste' }
          its(:aceite)            { should be true }
          its(:instrucoes1)       { should eq 'Lembrar de algo 1' }
          its(:instrucoes2)       { should eq 'Lembrar de algo 2' }
          its(:instrucoes3)       { should eq 'Lembrar de algo 3' }
          its(:instrucoes4)       { should eq 'Lembrar de algo 4' }
          its(:instrucoes5)       { should eq 'Lembrar de algo 5' }
          its(:instrucoes6)       { should eq 'Lembrar de algo 6' }
        end
      end

      describe "#carteira_formatada" do
        it "returns 'carteira' as default" do
          subject.stub(:carteira).and_return('Foo')
          subject.carteira_formatada.should eq 'Foo'
        end
      end

      describe "#valor_documento_formatado" do
        context "when period" do
          before { subject.stub(:valor_documento).and_return(123.45) }

          its(:valor_formatado_para_codigo_de_barras) { should eq '0000012345' }
        end

        context "when less than ten" do
          before { subject.stub(:valor_documento).and_return(5.0) }

          its(:valor_formatado_para_codigo_de_barras) { should eq '0000000500'}
        end

        context "when have many decimal points" do
          before { subject.stub(:valor_documento).and_return(10.999999) }

          its(:valor_formatado_para_codigo_de_barras) { should eq '0000001099' }
        end

        context "when integer" do
          before { subject.stub(:valor_documento).and_return(1_999) }

          its(:valor_formatado_para_codigo_de_barras) { should eq '0000199900' }
        end

        context "when period with string" do
          before { subject.stub(:valor_documento).and_return('236.91') }

          its(:valor_formatado_para_codigo_de_barras) { should eq '0000023691' }
        end

        context "when period with string with many decimals" do
          before { subject.stub(:valor_documento).and_return('10.999999') }

          its(:valor_formatado_para_codigo_de_barras) { should eq '0000001099' }
        end
      end

      describe "#aceite_formatado" do
        context "when is true" do
          subject { described_class.new(aceite: true) }

          its(:aceite_formatado) { should eq 'S' }
        end

        context "when is false" do
          subject { described_class.new(aceite: false) }

          its(:aceite_formatado) { should eq 'N' }
        end

        context "when is nil" do
          subject { described_class.new(aceite: nil) }

          its(:aceite_formatado) { should eq 'N' }
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
