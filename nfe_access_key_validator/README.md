# nfe_access_key_validator

Biblioteca Dart para validação offline da chave de acesso da Nota Fiscal Eletrônica (NF-e), modelo 55.

## Objetivo

Validar não apenas o dígito verificador da chave, mas também os campos que compõem sua estrutura:

- cUF
- AAMM
- CNPJ
- modelo
- série
- número da NF-e
- tipo de emissão
- cNF
- dígito verificador

A biblioteca deverá suportar tanto CNPJ numérico quanto o novo padrão alfanumérico.

## Documentação

- [Formato da chave](doc/access-key-format.md)
- [Regras de validação](doc/validation-rules.md)
- [CNPJ alfanumérico](doc/cnpj-alphanumeric.md)
- [Referências técnicas](doc/references.md)

## Status

Em especificação.