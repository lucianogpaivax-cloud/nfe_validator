# Regras de Validação da Chave de Acesso da NF-e

## 1. Objetivo

Este documento define as regras utilizadas pela biblioteca `nfe_access_key_validator` para validar offline os componentes da chave de acesso da Nota Fiscal Eletrônica — NF-e, modelo 55.

A validação deverá ser executada em dois níveis:

1. **validação estrutural**, responsável por verificar tamanho e formato;
2. **validação semântica**, responsável por verificar se o conteúdo de cada campo é permitido.

A existência de um dígito verificador correto não implica, por si só, que a chave seja válida.

---

# 2. Ordem geral das validações

A biblioteca deverá executar as validações aproximadamente nesta ordem:

```text
Chave recebida
    ↓
Formato geral
    ↓
cUF
    ↓
AAMM
    ↓
CNPJ
    ↓
modelo
    ↓
série
    ↓
nNF
    ↓
tpEmis
    ↓
cNF
    ↓
cDV
```

O cálculo do `cDV` deverá ocorrer apenas depois que a chave possuir estrutura suficiente para ser processada.

---

# 3. Formato geral da chave

## 3.1 Tamanho

A chave de acesso deverá possuir exatamente:

```text
44 posições
```

Uma chave com tamanho diferente deverá ser considerada inválida.

### Exemplos

```text
44 posições → válido estruturalmente
43 posições → inválido
45 posições → inválido
```

### Código de erro sugerido

```text
INVALID_LENGTH
```

Mensagem sugerida:

```text
A chave de acesso deve possuir exatamente 44 posições.
```

---

## 3.2 Caracteres permitidos

Historicamente, a chave de acesso da NF-e era composta exclusivamente por caracteres numéricos.

Com a adoção do CNPJ alfanumérico, a biblioteca não deverá assumir que todas as 44 posições são obrigatoriamente numéricas.

Os caracteres alfabéticos somente poderão ocorrer dentro das posições correspondentes ao CNPJ.

Assim:

```text
cUF    → numérico
AAMM   → numérico
CNPJ   → numérico ou alfanumérico, conforme regra própria
mod    → numérico
serie  → numérico
nNF    → numérico
tpEmis → numérico
cNF    → numérico
cDV    → numérico
```

Portanto, a validação geral **não deverá utilizar** uma expressão semelhante a:

```text
^[0-9]{44}$
```

pois isso impediria o suporte ao CNPJ alfanumérico.

---

## 3.3 Caracteres especiais

A chave deverá ser processada sem:

* espaços;
* pontos;
* barras;
* hífens;
* quebras de linha;
* outros separadores.

Exemplo inválido:

```text
35 2608 12345678000195 55 001 ...
```

A biblioteca deverá trabalhar com a representação canônica da chave, sem formatação.

### Código de erro sugerido

```text
INVALID_FORMAT
```

---

# 4. Validação do cUF

## 4.1 Definição

O campo `cUF` ocupa as posições:

```text
1–2
```

da chave.

Tamanho:

```text
2 posições
```

O campo representa o código da Unidade da Federação.

---

## 4.2 Formato

O campo deverá conter exatamente dois caracteres numéricos.

Exemplos:

```text
35 → formato válido
53 → formato válido

3  → inválido
SP → inválido
3A → inválido
```

---

## 4.3 Códigos permitidos

A biblioteca deverá trabalhar com uma lista fechada dos códigos de UF válidos:

| Código | UF |
| -----: | -- |
|     11 | RO |
|     12 | AC |
|     13 | AM |
|     14 | RR |
|     15 | PA |
|     16 | AP |
|     17 | TO |
|     21 | MA |
|     22 | PI |
|     23 | CE |
|     24 | RN |
|     25 | PB |
|     26 | PE |
|     27 | AL |
|     28 | SE |
|     29 | BA |
|     31 | MG |
|     32 | ES |
|     33 | RJ |
|     35 | SP |
|     41 | PR |
|     42 | SC |
|     43 | RS |
|     50 | MS |
|     51 | MT |
|     52 | GO |
|     53 | DF |

Não deverá ser utilizada uma validação baseada simplesmente em intervalo numérico.

Por exemplo:

```text
34
```

está numericamente entre outros códigos existentes, mas não representa uma UF válida.

---

## 4.4 Regra

A validação deverá ser equivalente conceitualmente a:

```text
cUF ∈ conjunto_de_codigos_uf_validos
```

---

## 4.5 Exemplos

### Válidos

```text
11
35
53
```

### Inválidos

```text
00
10
18
30
34
54
99
SP
```

---

## 4.6 Código de erro sugerido

```text
INVALID_CUF
```

Mensagem sugerida:

```text
O código da UF informado não é válido.
```

---

# 5. Validação do AAMM

## 5.1 Definição

O campo `AAMM` ocupa as posições:

```text
3–6
```

da chave.

Possui:

```text
4 posições
```

e representa o ano e o mês associados à emissão do documento.

Estrutura:

```text
AAMM
```

onde:

```text
AA = dois últimos dígitos do ano
MM = mês
```

---

## 5.2 Formato

O campo deverá conter exatamente quatro caracteres numéricos.

### Exemplos

```text
2608 → formato válido
2512 → formato válido
```

Inválidos:

```text
268
202608
26A8
ABCD
```

---

## 5.3 Validação do mês

As duas últimas posições deverão representar um mês válido.

Faixa permitida:

```text
01 até 12
```

Assim:

```text
2601 → válido
2608 → válido
2612 → válido
```

e:

```text
2600 → inválido
2613 → inválido
2699 → inválido
```

---

## 5.4 Validação do ano

Nesta versão da especificação, os dois primeiros caracteres deverão apenas ser numéricos.

Não será criada, inicialmente, uma regra que invalide automaticamente anos futuros ou antigos.

Motivo:

Uma regra temporal baseada na data atual poderia fazer com que uma chave passasse de válida para inválida apenas em razão do momento da execução da biblioteca.

Caso seja necessária uma validação temporal futura, ela deverá ser implementada como regra independente ou política configurável.

---

## 5.5 Regra

A validação básica deverá verificar:

```text
tamanho == 4
```

e:

```text
todos os caracteres são numéricos
```

e:

```text
01 <= MM <= 12
```

---

## 5.6 Exemplos válidos

```text
0001
9912
2507
2608
```

Do ponto de vista estritamente estrutural desta regra, todos os exemplos acima possuem:

* ano em duas posições;
* mês entre `01` e `12`.

---

## 5.7 Exemplos inválidos

```text
2600
2613
26A8
268
202608
```

---

## 5.8 Códigos de erro sugeridos

Para formato inválido:

```text
INVALID_AAMM_FORMAT
```

Para mês inválido:

```text
INVALID_MONTH
```

Mensagens sugeridas:

```text
O campo AAMM deve possuir quatro caracteres numéricos.
```

```text
O mês informado na chave deve estar entre 01 e 12.
```

---

# 6. CNPJ

Status:

```text
PENDENTE
```

As regras do CNPJ serão especificadas separadamente devido ao suporte simultâneo a:

* CNPJ numérico;
* CNPJ alfanumérico;
* validação dos dois dígitos verificadores.

Documento relacionado:

```text
doc/cnpj-alphanumeric.md
```

---

# 7. Modelo

Status:

```text
PENDENTE
```

---

# 8. Série

Status:

```text
PENDENTE
```

---

# 9. Número da NF-e — nNF

Status:

```text
PENDENTE
```

---

# 10. Tipo de emissão — tpEmis

Status:

```text
PENDENTE
```

---

# 11. Código numérico — cNF

Status:

```text
PENDENTE
```

---

# 12. Dígito verificador da chave — cDV

Status:

```text
PENDENTE
```

---

# 13. Política de erros

A biblioteca deverá informar não apenas se a chave é válida ou inválida, mas também quais regras falharam.

Cada erro deverá possuir, no mínimo:

```text
campo
código
mensagem
```

Exemplo conceitual:

```text
field: cUF
code: INVALID_CUF
message: O código da UF informado não é válido.
```

Uma chave poderá apresentar mais de um erro simultaneamente.

Exemplo:

```text
INVALID_CUF
INVALID_MONTH
INVALID_CNPJ
```

A API não deverá obrigatoriamente interromper a validação no primeiro erro.

---

# 14. Casos de teste derivados desta etapa

Os seguintes testes deverão ser implementados futuramente.

## Formato geral

```text
✓ aceita chave com 44 posições
✗ rejeita chave com 43 posições
✗ rejeita chave com 45 posições
✗ rejeita espaços
✗ rejeita caracteres especiais fora do CNPJ
```

## cUF

```text
✓ aceita 11
✓ aceita 35
✓ aceita 53

✗ rejeita 00
✗ rejeita 34
✗ rejeita 99
✗ rejeita SP
```

## AAMM

```text
✓ aceita 2601
✓ aceita 2608
✓ aceita 2612

✗ rejeita 2600
✗ rejeita 2613
✗ rejeita 26A8
✗ rejeita tamanho diferente de 4
```

---

# 15. Status

As seguintes regras estão especificadas nesta versão:

```text
[FECHADO] Formato geral
[FECHADO] cUF
[FECHADO] AAMM

[PENDENTE] CNPJ
[PENDENTE] modelo
[PENDENTE] série
[PENDENTE] nNF
[PENDENTE] tpEmis
[PENDENTE] cNF
[PENDENTE] cDV
```
