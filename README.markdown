# Boleto Bancário

[![CI](https://github.com/tomas-stefano/boleto_bancario/actions/workflows/ci.yml/badge.svg)](https://github.com/tomas-stefano/boleto_bancario/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/boleto_bancario.svg)](https://badge.fury.io/rb/boleto_bancario)

Gem para emissão de boletos bancários em Ruby.

## Requisitos

- Ruby 3.1 ou superior
- Rails 7.1 ou superior (opcional)

## Instalação

Adicione ao seu Gemfile:

```ruby
gem 'boleto_bancario'
```

Ou instale diretamente:

```bash
gem install boleto_bancario
```

## Bancos Suportados

| Banco | Código | Carteiras |
|-------|--------|-----------|
| Banco do Brasil | 001 | 12, 16, 17, 18 |
| Banrisul | 041 | 00, 08 |
| Bradesco | 237 | 03, 06, 09, 19, 21, 22 |
| Caixa Econômica | 104 | 14, 24 |
| Itaú | 341 | 107, 109, 122, 126, 131, 142, 143, 146, 150, 168, 174, 175, 196, 198 |
| Santander | 033 | 101, 102, 121 |
| Sicoob | 756 | 1, 9 |
| Sicredi | 748 | 03, C |
| **Nubank** | 260 | 1 |
| **Inter** | 077 | 112 |
| **C6 Bank** | 336 | 1 |

## Uso Básico

### Criando um Boleto

```ruby
boleto = BoletoBancario::Itau.new do |b|
  b.agencia           = '0097'
  b.conta_corrente    = '89755'
  b.carteira          = '198'
  b.cedente           = 'Razão Social da Empresa'
  b.codigo_cedente    = '90901'
  b.endereco_cedente  = 'Rua Exemplo, 123 - São Paulo/SP'
  b.numero_documento  = '12345678'
  b.sacado            = 'Nome do Cliente'
  b.documento_sacado  = '123.456.789-00'
  b.data_vencimento   = Date.today + 5
  b.valor_documento   = 199.90
end
```

### Validando o Boleto

Cada banco possui suas próprias validações. Sempre verifique se o boleto é válido antes de renderizar:

```ruby
if boleto.valid?
  # Boleto válido, pode renderizar
else
  boleto.errors.full_messages.each do |erro|
    puts erro
  end
end
```

### Acessando os Dados do Boleto

```ruby
boleto.codigo_banco_formatado  # => "341-7"
boleto.codigo_de_barras        # => "34191..."
boleto.linha_digitavel         # => "34191.75009 00000.000002..."
boleto.nosso_numero            # => "198/12345678-3"
boleto.agencia_codigo_cedente  # => "0097 / 90901-0"
```

## Formatos de Saída

### PDF

Gera o boleto em formato PDF usando Prawn:

```ruby
boleto.to_pdf
# => String com o conteúdo binário do PDF

# Salvando em arquivo
File.binwrite('boleto.pdf', boleto.to_pdf)
```

### HTML

Gera o boleto em formato HTML:

```ruby
boleto.to_html
# => String com o HTML completo do boleto
```

### PNG (Código de Barras)

Gera apenas a imagem do código de barras:

```ruby
boleto.to_png
# => String com o conteúdo binário do PNG

# Com opções customizadas
boleto.to_png(height: 80, margin: 20)

# Salvando em arquivo
File.binwrite('codigo_barras.png', boleto.to_png)
```

## Exemplos por Banco

### Banco do Brasil

```ruby
boleto = BoletoBancario::BancoBrasil.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '12345678'
  b.carteira         = '18'
  b.cedente          = 'Empresa LTDA'
  b.codigo_cedente   = '123456'
  b.numero_documento = '12345'
  b.sacado           = 'Cliente'
  b.documento_sacado = '123.456.789-00'
  b.data_vencimento  = Date.today + 10
  b.valor_documento  = 150.00
end
```

### Bradesco

```ruby
boleto = BoletoBancario::Bradesco.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '1234567'
  b.carteira         = '09'
  b.cedente          = 'Empresa LTDA'
  b.numero_documento = '12345678901'
  b.sacado           = 'Cliente'
  b.documento_sacado = '12.345.678/0001-00'
  b.data_vencimento  = Date.today + 10
  b.valor_documento  = 250.00
end
```

### Nubank

```ruby
boleto = BoletoBancario::Nubank.new do |b|
  b.agencia          = '0001'
  b.conta_corrente   = '1234567890'
  b.carteira         = '1'
  b.cedente          = 'Empresa LTDA'
  b.numero_documento = '12345678901'
  b.sacado           = 'Cliente'
  b.documento_sacado = '123.456.789-00'
  b.data_vencimento  = Date.today + 7
  b.valor_documento  = 99.90
end
```

### Inter

```ruby
boleto = BoletoBancario::Inter.new do |b|
  b.agencia          = '0001'
  b.conta_corrente   = '1234567890'
  b.carteira         = '112'
  b.cedente          = 'Empresa LTDA'
  b.numero_documento = '12345678901'
  b.sacado           = 'Cliente'
  b.documento_sacado = '123.456.789-00'
  b.data_vencimento  = Date.today + 7
  b.valor_documento  = 199.90
end
```

### C6 Bank

```ruby
boleto = BoletoBancario::C6Bank.new do |b|
  b.agencia          = '0001'
  b.conta_corrente   = '1234567890'
  b.carteira         = '1'
  b.cedente          = 'Empresa LTDA'
  b.numero_documento = '12345678901'
  b.sacado           = 'Cliente'
  b.documento_sacado = '123.456.789-00'
  b.data_vencimento  = Date.today + 7
  b.valor_documento  = 299.90
end
```

## Herança e Customização

Recomendamos criar subclasses para cada banco utilizado na sua aplicação:

```ruby
class MeuBoletoItau < BoletoBancario::Itau
  # Valores padrão para sua empresa
  def default_values
    super.merge(
      cedente: 'Minha Empresa LTDA',
      endereco_cedente: 'Rua Principal, 100 - São Paulo/SP',
      agencia: '1234',
      conta_corrente: '56789',
      carteira: '109'
    )
  end
end

# Uso simplificado
boleto = MeuBoletoItau.new(
  numero_documento: '123',
  sacado: 'Cliente',
  documento_sacado: '123.456.789-00',
  data_vencimento: Date.today + 5,
  valor_documento: 100.00
)
```

### Sobrescrevendo Comportamentos

```ruby
class MeuBoletoBradesco < BoletoBancario::Bradesco
  # Customiza o código de barras do banco
  def codigo_de_barras_do_banco
    # Sua implementação customizada
  end

  # Customiza a formatação do nosso número
  def nosso_numero
    # Sua implementação customizada
  end
end
```

## Validação de CPF/CNPJ

A gem inclui utilitários para validação de documentos:

```ruby
# Validação
BoletoBancario::Calculos::Documento.valid?('123.456.789-09')  # => true/false
BoletoBancario::Calculos::Documento.valid?('12.345.678/0001-95')  # => true/false

# Formatação
BoletoBancario::Calculos::Documento.format('12345678909')  # => "123.456.789-09"
BoletoBancario::Calculos::Documento.format('12345678000195')  # => "12.345.678/0001-95"
```

## Atributos Disponíveis

| Atributo | Descrição |
|----------|-----------|
| `agencia` | Número da agência |
| `digito_agencia` | Dígito verificador da agência |
| `conta_corrente` | Número da conta corrente |
| `digito_conta_corrente` | Dígito verificador da conta |
| `carteira` | Código da carteira |
| `cedente` | Nome/Razão social do beneficiário |
| `codigo_cedente` | Código do cedente no banco |
| `documento_cedente` | CPF/CNPJ do beneficiário |
| `endereco_cedente` | Endereço do beneficiário |
| `sacado` | Nome do pagador |
| `documento_sacado` | CPF/CNPJ do pagador |
| `endereco_sacado` | Endereço do pagador |
| `numero_documento` | Número do documento/boleto |
| `data_documento` | Data de emissão |
| `data_vencimento` | Data de vencimento |
| `valor_documento` | Valor do boleto |
| `especie` | Espécie da moeda (padrão: R$) |
| `especie_documento` | Espécie do documento (padrão: DM) |
| `instrucoes` | Instruções para o caixa |

## Métodos Disponíveis

| Método | Descrição |
|--------|-----------|
| `codigo_banco` | Código do banco (3 dígitos) |
| `digito_codigo_banco` | Dígito do código do banco |
| `codigo_banco_formatado` | Código formatado (ex: "341-7") |
| `codigo_de_barras` | Código de barras (44 dígitos) |
| `linha_digitavel` | Linha digitável formatada |
| `nosso_numero` | Nosso número formatado |
| `agencia_codigo_cedente` | Agência/Código do cedente |
| `carteira_formatada` | Carteira formatada para exibição |
| `to_pdf` | Gera PDF do boleto |
| `to_html` | Gera HTML do boleto |
| `to_png` | Gera PNG do código de barras |

## FEBRABAN 2025

A partir de 22/02/2025, o cálculo do fator de vencimento foi atualizado conforme norma FEBRABAN:

- **Antes de 22/02/2025**: Data base 07/10/1997
- **A partir de 22/02/2025**: Data base 29/05/2022, fator reinicia em 1000

A gem trata essa transição automaticamente.

## Internacionalização (i18n)

A gem inclui traduções em português brasileiro. Para usar em outros idiomas:

```ruby
# config/locales/boleto_bancario.en.yml
en:
  boleto_bancario:
    cedente: "Beneficiary"
    sacado: "Payer"
    # ...
```

## O Que a Gem Não Faz

Esta gem é focada exclusivamente na **emissão de boletos**. Ela **não** trata:

- Arquivos de remessa (CNAB 240/400)
- Arquivos de retorno
- Integração com APIs bancárias
- Registro de boletos online

Para essas funcionalidades, considere usar gems complementares.

## Documentação dos Bancos

As documentações oficiais utilizadas estão disponíveis em:

- [documentacoes_dos_boletos/](documentacoes_dos_boletos/)

## Contribuindo

Contribuições são bem-vindas! Você pode ajudar de várias formas:

1. **Homologando boletos** junto aos bancos
2. **Reportando bugs** e abrindo issues
3. **Enviando pull requests** com melhorias
4. **Atualizando documentações** dos bancos
5. **Adicionando suporte** a novos bancos

### Desenvolvimento

```bash
# Clone o repositório
git clone https://github.com/tomas-stefano/boleto_bancario.git
cd boleto_bancario

# Instale as dependências
bundle install

# Execute os testes
bundle exec rspec
```

## Changelog

Veja o arquivo [Changelog.markdown](Changelog.markdown) para o histórico de alterações.

## Licença

MIT License. Veja [LICENSE](LICENSE) para mais detalhes.
