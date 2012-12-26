require 'spec_helper'

module BoletoBancario
  module Core
    describe Boleto do
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
              :endereco_sacado  => 'Rua teste, 23045'
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
        end
      end

      describe "#carteira_formatada" do
        it "should return 'carteira' as default" do
          subject.stub(:carteira).and_return('Foo')
          subject.carteira_formatada.should eq 'Foo'
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