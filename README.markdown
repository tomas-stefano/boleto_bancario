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
# Carteira 18 com código do cedente de 6 dígitos
boleto = BoletoBancario::BancoBrasil.new do |b|
  b.agencia               = '1234'
  b.digito_agencia        = '1'
  b.conta_corrente        = '12345678'
  b.digito_conta_corrente = '9'
  b.carteira              = '18'
  b.cedente               = 'Padaria do João LTDA'
  b.documento_cedente     = '12.345.678/0001-90'
  b.codigo_cedente        = '123456'
  b.endereco_cedente      = 'Rua das Flores, 100 - Centro - Brasília/DF'
  b.numero_documento      = '12345'
  b.sacado                = 'Maria Silva'
  b.documento_sacado      = '123.456.789-00'
  b.endereco_sacado       = 'Av. Brasil, 500 - Apt 101 - São Paulo/SP'
  b.data_vencimento       = Date.today + 10
  b.valor_documento       = 1250.00
  b.instrucoes            = 'Não receber após o vencimento. Juros de 1% ao mês.'
end

# Verificando os dados gerados
boleto.codigo_banco_formatado  # => "001-9"
boleto.nosso_numero            # => "12345678-12345-17"
boleto.agencia_codigo_cedente  # => "1234-1 / 123456"
```

### Banrisul

```ruby
# Carteira 00 - Cobrança Simples
boleto = BoletoBancario::Banrisul.new do |b|
  b.agencia               = '1102'
  b.digito_agencia        = '72'
  b.conta_corrente        = '9000150'
  b.digito_conta_corrente = '46'
  b.carteira              = '00'
  b.cedente               = 'Loja de Informática RS LTDA'
  b.documento_cedente     = '98.765.432/0001-10'
  b.endereco_cedente      = 'Av. Ipiranga, 1000 - Porto Alegre/RS'
  b.numero_documento      = '22832563'
  b.sacado                = 'José Santos'
  b.documento_sacado      = '987.654.321-00'
  b.endereco_sacado       = 'Rua Voluntários da Pátria, 200 - Porto Alegre/RS'
  b.data_vencimento       = Date.today + 15
  b.valor_documento       = 550.00
end

boleto.codigo_banco_formatado  # => "041-8"
boleto.nosso_numero            # => "22832563.42"
```

### Bradesco

```ruby
# Carteira 09 - Cobrança com Registro
boleto = BoletoBancario::Bradesco.new do |b|
  b.agencia               = '1234'
  b.digito_agencia        = '5'
  b.conta_corrente        = '1234567'
  b.digito_conta_corrente = '0'
  b.carteira              = '09'
  b.cedente               = 'Distribuidora ABC LTDA'
  b.documento_cedente     = '11.222.333/0001-44'
  b.endereco_cedente      = 'Rua Augusta, 2000 - São Paulo/SP'
  b.numero_documento      = '12345678901'
  b.sacado                = 'Carlos Ferreira'
  b.documento_sacado      = '111.222.333-44'
  b.endereco_sacado       = 'Rua Oscar Freire, 300 - São Paulo/SP'
  b.data_vencimento       = Date.today + 7
  b.valor_documento       = 1890.50
  b.instrucoes            = 'Após vencimento cobrar multa de 2%'
end

boleto.codigo_banco_formatado  # => "237-2"
boleto.nosso_numero            # => "09/12345678901-P"
boleto.agencia_codigo_cedente  # => "1234-5 / 1234567-0"

# Carteira 06 - Cobrança Sem Registro
boleto_sem_registro = BoletoBancario::Bradesco.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '1234567'
  b.carteira         = '06'
  b.cedente          = 'Distribuidora ABC LTDA'
  b.numero_documento = '98765432101'
  b.sacado           = 'Ana Paula'
  b.documento_sacado = '222.333.444-55'
  b.data_vencimento  = Date.today + 5
  b.valor_documento  = 350.00
end
```

### Caixa Econômica Federal

```ruby
# Carteira 14 - Cobrança Simples com Registro
boleto = BoletoBancario::Caixa.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '123456'
  b.carteira         = '14'
  b.cedente          = 'Construtora XYZ LTDA'
  b.documento_cedente = '33.444.555/0001-66'
  b.codigo_cedente   = '123456'
  b.endereco_cedente = 'Setor Comercial Sul, Quadra 1 - Brasília/DF'
  b.numero_documento = '000000000000001'
  b.sacado           = 'Roberto Almeida'
  b.documento_sacado = '333.444.555-66'
  b.endereco_sacado  = 'SGAN 607, Bloco A - Brasília/DF'
  b.data_vencimento  = Date.today + 30
  b.valor_documento  = 15000.00
  b.instrucoes       = 'Referente à parcela 1/12 do contrato 12345'
end

boleto.codigo_banco_formatado  # => "104-0"
boleto.nosso_numero            # => "14000000000000001-0"

# Carteira 24 - Cobrança Sem Registro
boleto_sr = BoletoBancario::Caixa.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '123456'
  b.carteira         = '24'
  b.cedente          = 'Construtora XYZ LTDA'
  b.codigo_cedente   = '123456'
  b.numero_documento = '000000000000002'
  b.sacado           = 'Fernanda Costa'
  b.documento_sacado = '444.555.666-77'
  b.data_vencimento  = Date.today + 15
  b.valor_documento  = 8500.00
end
```

### Itaú

```ruby
# Carteira 198 - Cobrança com Registro
boleto = BoletoBancario::Itau.new do |b|
  b.agencia               = '0097'
  b.conta_corrente        = '12345'
  b.digito_conta_corrente = '7'
  b.carteira              = '198'
  b.cedente               = 'Tech Solutions LTDA'
  b.documento_cedente     = '55.666.777/0001-88'
  b.codigo_cedente        = '12345'
  b.endereco_cedente      = 'Av. Paulista, 1500 - 10º andar - São Paulo/SP'
  b.numero_documento      = '12345678'
  b.sacado                = 'Pedro Henrique'
  b.documento_sacado      = '555.666.777-88'
  b.endereco_sacado       = 'Rua Consolação, 100 - São Paulo/SP'
  b.data_vencimento       = Date.today + 5
  b.valor_documento       = 2500.00
  b.seu_numero            = '1234'
  b.instrucoes            = 'Cobrar juros de 0,033% ao dia após vencimento'
end

boleto.codigo_banco_formatado  # => "341-7"
boleto.nosso_numero            # => "198/12345678-2"
boleto.agencia_codigo_cedente  # => "0097 / 12345-7"

# Carteira 109 - Direta Eletrônica sem Registro
boleto_109 = BoletoBancario::Itau.new do |b|
  b.agencia          = '0097'
  b.conta_corrente   = '12345'
  b.carteira         = '109'
  b.cedente          = 'Tech Solutions LTDA'
  b.codigo_cedente   = '12345'
  b.numero_documento = '87654321'
  b.sacado           = 'Juliana Lima'
  b.documento_sacado = '666.777.888-99'
  b.data_vencimento  = Date.today + 3
  b.valor_documento  = 199.90
end

# Carteira 175 - Cobrança com Registro com IOF
boleto_175 = BoletoBancario::Itau.new do |b|
  b.agencia          = '0097'
  b.conta_corrente   = '12345'
  b.carteira         = '175'
  b.cedente          = 'Seguradora ABC'
  b.codigo_cedente   = '12345'
  b.numero_documento = '11111111'
  b.sacado           = 'Marcos Souza'
  b.documento_sacado = '777.888.999-00'
  b.data_vencimento  = Date.today + 30
  b.valor_documento  = 5000.00
end
```

### Santander

```ruby
# Carteira 102 - Cobrança Simples com Registro
boleto = BoletoBancario::Santander.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '1234567'
  b.carteira         = '102'
  b.cedente          = 'Importadora Global LTDA'
  b.documento_cedente = '77.888.999/0001-00'
  b.codigo_cedente   = '1234567'
  b.endereco_cedente = 'Av. das Nações Unidas, 12000 - São Paulo/SP'
  b.numero_documento = '1234567890123'
  b.sacado           = 'Lucas Oliveira'
  b.documento_sacado = '888.999.000-11'
  b.endereco_sacado  = 'Rua Funchal, 500 - São Paulo/SP'
  b.data_vencimento  = Date.today + 10
  b.valor_documento  = 3750.00
end

boleto.codigo_banco_formatado  # => "033-7"
boleto.nosso_numero            # => "1234567890123-4"
boleto.agencia_codigo_cedente  # => "1234 / 1234567"

# Carteira 101 - Cobrança Simples Rápida
boleto_101 = BoletoBancario::Santander.new do |b|
  b.agencia          = '1234'
  b.conta_corrente   = '1234567'
  b.carteira         = '101'
  b.cedente          = 'Importadora Global LTDA'
  b.codigo_cedente   = '1234567'
  b.numero_documento = '9876543210987'
  b.sacado           = 'Beatriz Mendes'
  b.documento_sacado = '999.000.111-22'
  b.data_vencimento  = Date.today + 7
  b.valor_documento  = 890.00
end
```

### Sicoob

```ruby
# Carteira 1 - Simples com Registro
boleto = BoletoBancario::Sicoob.new do |b|
  b.agencia          = '3069'
  b.conta_corrente   = '828452'
  b.carteira         = '1'
  b.cedente          = 'Cooperativa Agrícola do Vale'
  b.documento_cedente = '11.222.333/0001-44'
  b.codigo_cedente   = '828452'
  b.convenio         = '123456'
  b.endereco_cedente = 'Rodovia BR-101, km 50 - Interior/MG'
  b.numero_documento = '1234567'
  b.sacado           = 'Fazenda Santa Maria'
  b.documento_sacado = '22.333.444/0001-55'
  b.endereco_sacado  = 'Fazenda Santa Maria, s/n - Zona Rural - Interior/MG'
  b.data_vencimento  = Date.today + 30
  b.valor_documento  = 25000.00
  b.instrucoes       = 'Referente à compra de insumos agrícolas'
end

boleto.codigo_banco_formatado  # => "756-0"
boleto.nosso_numero            # => "1234567-4"
boleto.agencia_codigo_cedente  # => "3069 / 828452"

# Carteira 9 - Sem Registro
boleto_9 = BoletoBancario::Sicoob.new do |b|
  b.agencia          = '3069'
  b.conta_corrente   = '828452'
  b.carteira         = '9'
  b.cedente          = 'Cooperativa Agrícola do Vale'
  b.codigo_cedente   = '828452'
  b.convenio         = '123456'
  b.numero_documento = '7654321'
  b.sacado           = 'Sítio Boa Vista'
  b.documento_sacado = '33.444.555/0001-66'
  b.data_vencimento  = Date.today + 15
  b.valor_documento  = 8500.00
end
```

### Sicredi

```ruby
# Carteira 03 - Cobrança com Registro
boleto = BoletoBancario::Sicredi.new do |b|
  b.agencia          = '0710'
  b.conta_corrente   = '54321'
  b.carteira         = '03'
  b.posto            = '08'
  b.byte_id          = '2'
  b.cedente          = 'Supermercado Bom Preço LTDA'
  b.documento_cedente = '44.555.666/0001-77'
  b.endereco_cedente = 'Av. Central, 500 - Centro - Interior/RS'
  b.numero_documento = '12345'
  b.sacado           = 'João da Silva'
  b.documento_sacado = '444.555.666-77'
  b.endereco_sacado  = 'Rua das Palmeiras, 100 - Interior/RS'
  b.data_vencimento  = Date.today + 7
  b.valor_documento  = 450.00
end

boleto.codigo_banco_formatado  # => "748-X"
boleto.agencia_codigo_cedente  # => "0710.08.54321"

# Carteira C - Correspondente
boleto_c = BoletoBancario::Sicredi.new do |b|
  b.agencia          = '0710'
  b.conta_corrente   = '54321'
  b.carteira         = 'C'
  b.posto            = '08'
  b.byte_id          = '3'
  b.cedente          = 'Supermercado Bom Preço LTDA'
  b.numero_documento = '54321'
  b.sacado           = 'Maria Aparecida'
  b.documento_sacado = '555.666.777-88'
  b.data_vencimento  = Date.today + 10
  b.valor_documento  = 1200.00
end
```

### Nubank

```ruby
boleto = BoletoBancario::Nubank.new do |b|
  b.agencia          = '0001'
  b.conta_corrente   = '1234567890'
  b.carteira         = '1'
  b.cedente          = 'Startup Digital LTDA'
  b.documento_cedente = '55.666.777/0001-88'
  b.endereco_cedente = 'Rua Capote Valente, 39 - Pinheiros - São Paulo/SP'
  b.numero_documento = '00012345678'
  b.sacado           = 'Amanda Torres'
  b.documento_sacado = '666.777.888-99'
  b.endereco_sacado  = 'Av. Rebouças, 1000 - Apt 42 - São Paulo/SP'
  b.data_vencimento  = Date.today + 7
  b.valor_documento  = 299.90
  b.instrucoes       = 'Pagamento referente à assinatura mensal'
end

boleto.codigo_banco_formatado  # => "260-0"
boleto.nosso_numero            # => "00012345678-9"
boleto.agencia_codigo_cedente  # => "0001 / 1234567890-3"
```

### Inter

```ruby
boleto = BoletoBancario::Inter.new do |b|
  b.agencia          = '0001'
  b.conta_corrente   = '9876543210'
  b.carteira         = '112'
  b.cedente          = 'E-commerce Express LTDA'
  b.documento_cedente = '66.777.888/0001-99'
  b.endereco_cedente = 'Av. Raja Gabaglia, 1000 - Belo Horizonte/MG'
  b.numero_documento = '00098765432'
  b.sacado           = 'Ricardo Gomes'
  b.documento_sacado = '777.888.999-00'
  b.endereco_sacado  = 'Rua da Bahia, 500 - Belo Horizonte/MG'
  b.data_vencimento  = Date.today + 5
  b.valor_documento  = 1599.00
  b.instrucoes       = 'Pedido #98765 - Entrega expressa inclusa'
end

boleto.codigo_banco_formatado  # => "077-9"
boleto.nosso_numero            # => "00098765432-9"
boleto.agencia_codigo_cedente  # => "0001 / 9876543210-3"
```

### C6 Bank

```ruby
boleto = BoletoBancario::C6Bank.new do |b|
  b.agencia          = '0001'
  b.conta_corrente   = '5678901234'
  b.carteira         = '1'
  b.cedente          = 'Fintech Solutions LTDA'
  b.documento_cedente = '77.888.999/0001-00'
  b.endereco_cedente = 'Av. Faria Lima, 3000 - 15º andar - São Paulo/SP'
  b.numero_documento = '00056789012'
  b.sacado           = 'Camila Rodrigues'
  b.documento_sacado = '888.999.000-11'
  b.endereco_sacado  = 'Rua Pamplona, 200 - São Paulo/SP'
  b.data_vencimento  = Date.today + 10
  b.valor_documento  = 4500.00
  b.instrucoes       = 'Parcela 3/6 - Contrato de serviços'
end

boleto.codigo_banco_formatado  # => "336-5"
boleto.nosso_numero            # => "00056789012-4"
boleto.agencia_codigo_cedente  # => "0001 / 5678901234-3"
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
