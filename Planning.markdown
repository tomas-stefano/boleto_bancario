# BoletoBancario

Emissão de Boletos Bancários em Ruby. Simples, fácil e principalmente, flexível.

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
