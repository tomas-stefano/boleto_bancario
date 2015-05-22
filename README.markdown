# BoletoBancario

Emissão de Boletos Bancários em Ruby.

Foi colocado um esforço enorme para tornar a gem **simples e principalmente, flexível**.

## Versão Beta

Essa gem ainda está em versão beta. Algumas coisas podem mudar até que a versão oficial seja lançada.

## Alternativas

Essa biblioteca é baseada em outras **ótimas** bibliotecas.
**Recomendo analisar muito bem cada solução**:

* Stella Caelum [http://stella.caelum.com.br/](http://stella.caelum.com.br/)
* Novo Gateway de Pagamentos da Locaweb [http://www.locaweb.com.br/produtos/gateway-pagamento.html](http://www.locaweb.com.br/produtos/gateway-pagamento.html)
* Brcobranca [https://github.com/kivanio/brcobranca](https://github.com/kivanio/brcobranca)
* Boleto Php [http://boletophp.com.br/](http://boletophp.com.br/)
* Gem de Boleto Bancário (essa gem) [https://github.com/tomas-stefano/boleto_bancario](https://github.com/tomas-stefano/boleto_bancario)

## Instalação

    gem install boleto_bancario

## Documentação

Seguimos todas as documentações descritas abaixo:

* [Banco do Brasil](documentacoes_dos_boletos/banco_brasil)
* [Banrisul](documentacoes_dos_boletos/banrisul)
* [Bradesco](documentacoes_dos_boletos/Bradesco)
* [Caixa](documentacoes_dos_boletos/Caixa)
* [HSBC](documentacoes_dos_boletos/HASBC)
* [Itaú](documentacoes_dos_boletos/Itau)
* [Real](documentacoes_dos_boletos/Real)
* [Santander](documentacoes_dos_boletos/santander)
* [Sicoob](documentacoes_dos_boletos/Sicoob)
* [Sicredi](documentacoes_dos_boletos/Sicredi)

Se você tiver uma documentação do boleto, **mais atualizada**, gostaria de pedir que você me enviasse. :)

## Bancos Suportados

Para todos os bancos e carteiras implementadas, **seguimos as documentações** que estão dentro do repositório:

<table>
  <tr>
    <th>Nome do Banco</th>
    <th>Carteiras Suportadas</th>
    <th>Testada/Homologada no banco</th>
  </tr>
  <tr>
    <td>Banco do Brasil</td>
    <td>
      12 com código do cedente de 6 dígitos,
      16 e 18 com código do cedente de 4 dígitos,
      16 e 18 com código do cedente e nosso número de 17 dígitos,
      16 e 18 com código do cedente de 6 dígitos,
      16, 17 e 18 código do cedente de 7 e 8 dígitos.
    </td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Banrisul</td>
    <td>00, 08.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Bradesco</td>
    <td>03, 06, 09, 19, 21, 22.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Caixa</td>
    <td>14, 24.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>HSBC</td>
    <td>CNR.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Itaú</td>
    <td>107, 109, 122, 142, 143, 126, 174, 175, 196, 198, 131, 146, 150, 168.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Real</td>
    <td>00, 20, 31, 42, 47, 85.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Santander</td>
    <td>101, 102, 121.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Sicoob</td>
    <td>1, 9.</td>
    <td>Esperando Contribuição</td>
  </tr>
  <tr>
    <td>Sicredi</td>
    <td>03, C.</td>
    <td>Esperando Contribuição</td>
  </tr>
</table>

**OBS.: Caso a homologação seja aceita junto ao banco, contribua e mude a seção acima. Caso recuse alguma carteira acima, por favor me avise, para tirar dessa lista.**

## Homologação no Banco

Uma ótima forma de contribuir para a gem, é validar junto ao banco os boletos implementados acima.

## Usage

Você pode usar as próprias classes da gem, porém, **recomendo criar uma subclasse** para os bancos que você gostaria de desenvolver.

### Exemplo

```ruby
class BoletoItau < BoletoBancario::Itau
end

class BoletoSantander < BoletoBancario::Santander
end

class BoletoBradesco < BoletoBancario::Bradesco
end

class BoletoBancoBrasil < BoletoBancario::BancoBrasil
end
```

Segue os attributos dos boletos:

* Agência
* Dígito da agência
* Conta Corrente
* Dígito da Conta Corrente
* Carteira
* Cedente
* Código do Cedente
* Documento do Cedente
* Endereço do Cedente
* Sacado
* Documento do Sacado
* Código da Moeda
* Data do documento
* Data do vencimento
* Número do documento
* Valor do documento (valor do boleto)
* Espécie
* Espécie do documento

### Criando os boletos / Validações

Agora você pode emitir um boleto, **usando a classe criada no exemplo acima**:

```ruby
BoletoItau.new(conta_corrente: '89755', agencia: '0097', :carteira => '195')
```

Você pode usar blocos se quiser:

```ruby
boleto_itau = BoletoItau.new do |boleto|
  boleto.conta_corrente        = '89755'
  boleto.agencia               = '0097'
  boleto.carteira              = '198'
  boleto.cedente               = 'Razao Social da Empresa'
  boleto.codigo_cedente        = '90901'
  boleto.endereco_cedente      = 'Rua nome da rua, 9999'
  boleto.numero_documento      = '12345678'
  boleto.sacado                = 'Nome do Sacado'
  boleto.documento_sacado      = '35433793990'
  boleto.data_vencimento       = Date.tomorrow
  boleto.valor_documento       = 31678.99
  boleto.seu_numero            = 1234
end
```

**Cada banco possui suas próprias validações de campo e de tamanho**.
Primeiramente, **antes de renderizar qualquer boleto você precisar verificar se esse o boleto é válido**.

```ruby
if boleto_itau.valid?
   # Renderiza o boleto itau
else
   # Trata os erros
end
```

### Campos do Boleto

Segue abaixo os métodos para serem chamados, no momento de renderizar os boletos. Os campos são de mesmo nome:

```ruby
boleto_itau.codigo_banco_formatado # Retorna o código do banco, junto com seu dígito

boleto_itau.codigo_de_barras

boleto_itau.linha_digitavel

boleto_itau.nosso_numero

boleto_itau.agencia_codigo_cedente

boleto_itau.carteira_formatada # Formata a carteira, para mostrar no boleto.

boleto_itau.numero_documento

boleto_itau.valor_documento

boleto_itau.especie

boleto_itau.especie_documento
```

## Sobrescrevendo comportamentos

Você pode sobrescrever os comportamentos na subclasse.

Por exemplo, imagine que você quer sobrescrever a forma como é tratada a segunda parte do código de barras.
**Seguindo a interface da classe BoletoBancario::Boleto** fica bem simples:

```ruby
class BoletoItau < BoletoBancario::Itau
  def codigo_de_barras_do_banco
   # Sua implementação ...
  end
end
```

## Formatos (HTML, PDF e PNG)

### Objetivos para as próximas versões: criar os formatos dos boletos de:

* HTML
* PDF
* PNG

## O que a gem não faz

A gem não trata os arquivos de remessa e os arquivos de retorno do banco.

Na minha opinião não deveria ser responsabilidade dessa gem.
Essa gem **apenas emite o boleto**, com todas as informações necessárias do boleto.

## Contribuições

Seja um contribuidor. Você pode contribuir de N formas. Seguem elas:

* Homologando boletos junto ao banco.
* Fornecendo documentações mais atualizadas dos Bancos.
* Escrevendo novos formatos (PDF, PNG), e me avisando para divulgar no Readme.
* Refatorando código!!
* Fornecendo Feedback construtivo! (Sempre bem vindo!)
