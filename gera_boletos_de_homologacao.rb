#!/usr/bin/env ruby

require 'boleto_bancario'
# require 'pdfkit'

#Pra testar no terminal:
# gem build boleto_bancario.gemspec
# gem gem install boleto_bancario-0.0.1.beta.gem --no-ri --no-rdoc
# irb
# > require 'boleto_bancario'
# 
#pedido teste: 2769161
#pagamento:

# 5.times do |index|
  index = 0
  boleto = BoletoBancario::Core::Santander.new do |boleto_santander|
    boleto_santander.conta_corrente        = '013002564'
    boleto_santander.digito_conta_corrente = '8'
    boleto_santander.agencia               = '3413'
    boleto_santander.carteira              = '102'
    boleto_santander.cedente               = 'OLOOK COM ONLINE DE MODA LTDA'
    boleto_santander.codigo_cedente        = '5739454'
    boleto_santander.endereco_cedente      = 'Rua Surubim, 159'
    boleto_santander.numero_documento      = "2769161"
    boleto_santander.sacado                = 'Oliver Azevedo Barnes'
    boleto_santander.documento_sacado      = '252.958.738-89'
    boleto_santander.data_vencimento       = Date.today + 4.days
    # boleto_santander.valor_documento       = 100.00 + index
    boleto_santander.valor_documento       = 1.00
  end
  
  html = boleto.to_html

  File.open("boleto#{index+1}.html", "w") do |file|
    puts "writing to file boleto#{index+1}.html"
    file.write html
  end

  #puts "writing to file boleto#{index+1}.pdf"
  #PDFKit.new(html).to_file("boleto#{index+1}.pdf")

  puts "finished #{index+1}"
# end
