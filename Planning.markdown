# BoletoBancario

Emissão de Boletos Bancários em Ruby. Simples, fácil e principalmente, flexível.

## Alternativas

Essa biblioteca é baseada em outras **ótimas** bibliotecas (**Recomendo analisar muito bem cada solução e usar a que resolver o seu problema!**):

* Stella Caelum [http://stella.caelum.com.br/](http://stella.caelum.com.br/)
* Novo Gateway de Pagamentos da Locaweb [http://www.locaweb.com.br/produtos/gateway-pagamento.html](http://www.locaweb.com.br/produtos/gateway-pagamento.html)
* Brcobranca [https://github.com/kivanio/brcobranca](https://github.com/kivanio/brcobranca)
* Boleto Php [http://boletophp.com.br/](http://boletophp.com.br/)
* Gem de Boleto Bancário (essa gem) [https://github.com/tomas-stefano/boleto_bancario](https://github.com/tomas-stefano/boleto_bancario)

## Instalação

    gem install boleto_bancario

## Bancos Suportados

* TODO: Precisa escrever essa parte

## Usage

Você pode usar as próprias classes da gem, porém, **recomendo criar uma subclasse** para os bancos que você gostaria de desenvolver.

Exemplo:

```ruby
  class Itau < BoletoBancario::Itau
  end

  class Santander < BoletoBancario::Santander
  end

  class Bradesco < BoletoBancario::Bradesco
  end

  class BancoBrasil < BoletoBancario::BancoBrasil
  end
```

## Attributos

* TODO: Precisa escrever essa parte

## Internacionalização (i18n)

* TODO: Precisa escrever essa parte

## Validações

* TODO: Precisa escrever essa parte

## Código do Banco

* TODO: Precisa escrever essa parte

## Agência / Código do Cedente

* TODO: Precisa escrever essa parte

## Nosso Número

* TODO: Precisa escrever essa parte

## Código de Barras

* TODO: Precisa escrever essa parte

## Linha digitável

* TODO: Precisa escrever essa parte

## Documentação

* TODO: Precisa escrever essa parte

## Formatos

* TODO: Essa parte ainda pode mudar até a versão 0.0.1.

Colocar na classe:

```ruby
  class BoletoItau < BoletoBancario::Itau
    respond_to :html, :pdf, :png
  end
```

Para renderizar o html:

```ruby
   itau = BoletoItau.new

   itau.respond_with # Irá chamar o método render da instância do objeto passado no método format.

   itau.respond_with(:pdf)
```

### Criando um novo Formato

Em relação a parte de formatos a gem de boleto bancário é extremamente flexível.

Basta criar um objeto que responda ao método **render**:

```ruby
   module BoletoBancario
     module Formato
       class Html < Boleto
         def render(*args)
         end
       end
     end
   end
```

```ruby
   module BoletoBancario
     module Formato
       class Pdf < Boleto
         def render(*args)
         end
       end
     end
   end
```

## Contribuições

Seja um contribuidor. Você pode contribuir de N formas. Seguem elas:

* Homologando boletos junto ao banco.
* Fornecendo documentações mais atualizadas dos Bancos.
* Escrevendo novos formatos (PDF, PNG), e me avisando para divulgar no Readme.
* Refatorando código!!
* Fornecendo Feedback construtivo! (Sempre bem vindo!)
