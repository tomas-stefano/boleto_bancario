# encoding: utf-8
require 'boleto_bancario/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

# Copyright (C) 2012 Tomás D'Stefano <http://successoft.com>
#
# @author Tomás D'Stefano <tomas_stefano@successoft.com>
#
# == Boleto Bancário
#
# Emissão de Boletos Bancários em Ruby. Simples e principalmente, flexível.
#
# Essa biblioteca é baseada em outras <b>ótimas</b> bibliotecas.
# Recomendo analisar muito bem cada solução!
#
# * Novo Gateway de Pagamentos da Locaweb: http://www.locaweb.com.br/produtos/gateway-pagamento.html
# * Brcobranca: https://github.com/kivanio/brcobranca
# * Boleto Php: http://boletophp.com.br
# * Stella Caelum: http://stella.caelum.com.br
#
# === Coreuições
#
# Você pode contribuir de N formas. Seguem elas:
#
# * Homologando os boletos junto aos bancos (Super importante!!! :] ).
# * Fornecendo documentações mais atualizadas dos Bancos.
# * Escrevendo novos formatos (PDF, PNG), e me avisando para divulgar no Readme.
# * Refatorando código!! (Sempre bem vindo!)
# * Fornecendo Feedback construtivo! (Sempre bem vindo!)
#
# === Instalação via Rubygems
#
#   gem install boleto_bancario
#
# === Instalar via Bundler
#
# Coloque no Gemfile:
#
#   gem 'boleto_bancario'
#
# Depois de colocar no Gemfile:
#
#   bundle install
#
module BoletoBancario
  # Modulo responsável por guardar todas as regras dos campos de
  # todos os Boletos Bancários. <b>Contribuicões com novas documentações dos
  # bancos e homologação dos boletos são extremamente bem vindas!</b>
  #
  # Esse módulo também é responsável por guardar todas as regras de validação dos boletos e
  # contém a forma de chamar os objetos necessários para renderização
  # dos formatos (pdf, html, etc) e internacionalização dos boletos (caso
  # você precise mudar os nomes dos campos nos boletos)
  #
  module Core
    autoload :Boleto,      'boleto_bancario/core/boleto'
    autoload :BancoBrasil, 'boleto_bancario/core/banco_brasil'
    autoload :Bradesco,    'boleto_bancario/core/bradesco'
    autoload :Itau,        'boleto_bancario/core/itau'
    autoload :Santander,   'boleto_bancario/core/santander'
  end

  # Módulo que possui classes que realizam os cálculos dos campos que serão mostrados nos boletos.
  #
  module Calculos
    autoload :FatorVencimento,             'boleto_bancario/calculos/fator_vencimento'
    autoload :FatoresDeMultiplicacao,      'boleto_bancario/calculos/fatores_de_multiplicacao'
    autoload :LinhaDigitavel,              'boleto_bancario/calculos/linha_digitavel'
    autoload :Modulo10,                    'boleto_bancario/calculos/modulo10'
    autoload :Modulo11,                    'boleto_bancario/calculos/modulo11'
    autoload :Modulo11FatorDe2a9,          'boleto_bancario/calculos/modulo11_fator_de2a9'
    autoload :Modulo11FatorDe2a9RestoZero, 'boleto_bancario/calculos/modulo11_fator_de2a9_resto_zero'
    autoload :Modulo11FatorDe2a7,          'boleto_bancario/calculos/modulo11_fator_de2a7'
    autoload :Modulo11FatorDe9a2RestoX,    'boleto_bancario/calculos/modulo11_fator_de9a2_resto_x'
    autoload :Digitos,                     'boleto_bancario/calculos/digitos'
  end

  include Core
end
