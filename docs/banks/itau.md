# Itaú

## Código do Banco
341-7

## Carteiras Suportadas

| Código | Descrição | Status |
|--------|-----------|--------|
| 107 | Sem registro com emissão integral – 15 posições | Esperando Contribuição |
| 109 | Direta eletrônica sem emissão – simples | Esperando Contribuição |
| 122 | Carteira especial | Esperando Contribuição |
| 126 | Carteira padrão | Esperando Contribuição |
| 131 | Carteira padrão | Esperando Contribuição |
| 142 | Carteira especial | Esperando Contribuição |
| 143 | Carteira especial | Esperando Contribuição |
| 146 | Carteira padrão | Esperando Contribuição |
| 150 | Carteira padrão | Esperando Contribuição |
| 168 | Carteira padrão | Esperando Contribuição |
| 174 | Sem registro emissão parcial com protesto borderô | Esperando Contribuição |
| 175 | Sem registro sem emissão com protesto eletrônico | Esperando Contribuição |
| 196 | Sem registro com emissão e entrega – 15 posições | Esperando Contribuição |
| 198 | Sem registro sem emissão 15 dígitos | Esperando Contribuição |

## Exemplo de Uso

```ruby
class BoletoItau < BoletoBancario::Itau
end

boleto = BoletoItau.new do |b|
  b.cedente           = 'Empresa Exemplo LTDA'
  b.documento_cedente = '12.345.678/0001-90'
  b.endereco_cedente  = 'Rua Exemplo, 123 - São Paulo/SP'
  b.agencia           = '0057'
  b.conta_corrente    = '12345'
  b.digito_conta_corrente = '7'
  b.carteira          = '109'
  b.numero_documento  = '12345678'
  b.data_vencimento   = Date.today + 30
  b.valor_documento   = 150.00
  b.sacado            = 'Cliente Exemplo'
  b.documento_sacado  = '123.456.789-00'
end

if boleto.valid?
  puts boleto.codigo_de_barras
  puts boleto.linha_digitavel
  puts boleto.nosso_numero
end
```

## Campos Específicos

| Campo | Descrição | Tamanho Máximo |
|-------|-----------|----------------|
| `agencia` | Número da agência | 4 dígitos |
| `conta_corrente` | Número da conta corrente | 5 dígitos |
| `digito_conta_corrente` | Dígito da conta | 1 dígito |
| `carteira` | Código da carteira | 3 dígitos |
| `numero_documento` | Número do documento | 8 dígitos |
| `codigo_cedente` | Código do cliente (carteiras especiais) | 5 dígitos |
| `seu_numero` | Seu número (carteiras especiais) | 7 dígitos |

## Métodos Disponíveis

```ruby
boleto.codigo_de_barras      # => "34191556100002952951751234567861565138771000"
boleto.linha_digitavel       # => "34191.75124 34567.861561 51387.710000 1 55540000295295"
boleto.nosso_numero          # => "109/12345678-8"
boleto.agencia_codigo_cedente # => "0057 / 12345-7"
boleto.carteira_formatada    # => "109"
boleto.codigo_banco_formatado # => "341-7"
boleto.to_pdf                # => Conteúdo PDF do boleto
boleto.to_html               # => Conteúdo HTML do boleto
boleto.to_png                # => Imagem PNG do código de barras
```

## Carteiras Especiais

As carteiras 107, 122, 142, 143, 196 e 198 são consideradas "especiais" e requerem
os campos `codigo_cedente` e `seu_numero` preenchidos.
