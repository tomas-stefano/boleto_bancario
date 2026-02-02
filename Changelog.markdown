# 1.0.0

## Breaking Changes

* **Ruby 3.3+ required** - Dropped support for Ruby 1.9.x, 2.x, and early 3.x versions
* **Rails 7.1+ required** - Updated ActiveModel and ActiveSupport to ~> 7.1
* **RSpec 3.x** - Updated test suite to modern RSpec syntax
* **Removed HSBC** - HSBC Brazil operations were sold to Bradesco
* **Removed Banco Real** - Banco Real merged with Santander

## New Features

### New Banks
* **Nubank** (código 260) - Digital bank support
* **Banco Inter** (código 077) - Digital bank support
* **C6 Bank** (código 336) - Digital bank support

### Output Formats
* **PDF rendering** - Generate boletos as PDF using Prawn
* **HTML rendering** - Generate boletos as HTML for web display
* **PNG rendering** - Generate barcode images as PNG

### Internationalization
* **pt-BR locale** - Added Portuguese (Brazil) translations for all labels and error messages

### Compliance
* **FEBRABAN 2025** - Updated Fator de Vencimento calculation for the February 22, 2025 transition
  * Old base date: October 7, 1997 (factor 9999 reached on Feb 21, 2025)
  * New base date: May 29, 2022 (factor restarts at 1000 on Feb 22, 2025)

### Utilities
* **CPF/CNPJ validation** - Added `Documento` class for validating and formatting Brazilian documents

## Improvements

* Added `frozen_string_literal: true` pragma to all Ruby files
* Migrated CI from Travis CI to GitHub Actions
* Updated all dependencies to modern versions
* Improved documentation with YARD

## Dependencies

* `activesupport` ~> 7.1
* `activemodel` ~> 7.1
* `barby` ~> 0.6
* `prawn` ~> 2.4
* `prawn-table` ~> 0.2
* `chunky_png` ~> 1.4
* `rspec` ~> 3.13 (development)

---

# 0.0.2

* Implementado Banrisul.

# 0.0.1.beta

* Implementado Banco do Brasil.
* Implementado Santander.
* Implementado Bradesco.
* Implementado Itaú.
