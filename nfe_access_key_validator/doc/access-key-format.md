# Formato da Chave de Acesso da NF-e

## 1. Objetivo

Este documento define a estrutura da chave de acesso da Nota Fiscal Eletrônica — NF-e, modelo 55, utilizada pela biblioteca `nfe_access_key_validator`.

O objetivo deste documento é estabelecer de forma inequívoca:

* os campos que compõem a chave;
* a ordem dos campos;
* a posição inicial e final de cada campo;
* o tamanho de cada campo;
* o tipo básico de conteúdo de cada campo.

As regras específicas de validade de cada componente serão documentadas separadamente em `validation-rules.md`.

---

## 2. Escopo

A biblioteca tem como escopo inicial a validação offline de chaves de acesso de:

**Nota Fiscal Eletrônica — NF-e, modelo 55.**

Não fazem parte do escopo inicial:

* NFC-e, modelo 65;
* CT-e;
* MDF-e;
* outros Documentos Fiscais eletrônicos — DF-e.

A arquitetura da biblioteca poderá futuramente ser expandida para outros modelos.

---

## 3. Tamanho da chave

A chave de acesso possui:

**44 posições.**

A biblioteca deverá sempre considerar a chave como uma sequência de exatamente 44 posições.

Importante:

Com a introdução do CNPJ alfanumérico, a expressão “44 dígitos” deixa de representar corretamente todos os casos possíveis.

A terminologia adotada por esta biblioteca será:

**chave de acesso de 44 posições**

e não:

**chave de 44 dígitos**.

Isso ocorre porque o campo CNPJ poderá conter caracteres alfabéticos.

---

## 4. Composição da chave

A chave de acesso é composta pelos seguintes nove campos lógicos:

| Ordem | Campo  | Posição inicial | Posição final | Tamanho |
| ----: | ------ | --------------: | ------------: | ------: |
|     1 | cUF    |               1 |             2 |       2 |
|     2 | AAMM   |               3 |             6 |       4 |
|     3 | CNPJ   |               7 |            20 |      14 |
|     4 | mod    |              21 |            22 |       2 |
|     5 | serie  |              23 |            25 |       3 |
|     6 | nNF    |              26 |            34 |       9 |
|     7 | tpEmis |              35 |            35 |       1 |
|     8 | cNF    |              36 |            43 |       8 |
|     9 | cDV    |              44 |            44 |       1 |

A soma dos tamanhos dos campos é:

```text
2 + 4 + 14 + 2 + 3 + 9 + 1 + 8 + 1 = 44
```

---

## 5. Representação estrutural

A estrutura pode ser representada da seguinte forma:

```text
cUF  AAMM  CNPJ            mod  serie  nNF        tpEmis  cNF       cDV
XX   XXXX  XXXXXXXXXXXXXX  XX   XXX    XXXXXXXXX  X       XXXXXXXX  X
```

Sem separadores:

```text
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Total:

```text
44 posições
```

---

## 6. Definição estrutural dos campos

### 6.1 cUF

**Nome:** Código da Unidade da Federação

**Posições:** 1 a 2

**Tamanho:** 2 posições

Representa o código da Unidade da Federação associada à emissão da NF-e.

Exemplo:

```text
35
```

A validação dos códigos permitidos será definida em `validation-rules.md`.

---

### 6.2 AAMM

**Nome:** Ano e mês

**Posições:** 3 a 6

**Tamanho:** 4 posições

Estrutura:

```text
AAMM
```

onde:

```text
AA = dois últimos dígitos do ano
MM = mês
```

Exemplo:

```text
2608
```

Representando:

```text
agosto de 2026
```

As regras de validade do mês e demais verificações serão documentadas em `validation-rules.md`.

---

### 6.3 CNPJ

**Nome:** Cadastro Nacional da Pessoa Jurídica do emitente

**Posições:** 7 a 20

**Tamanho:** 14 posições

O campo possui sempre 14 posições.

A biblioteca deverá aceitar os dois formatos de CNPJ coexistentes:

#### CNPJ numérico

Estrutura histórica composta exclusivamente por números.

Exemplo estrutural:

```text
12345678000195
```

#### CNPJ alfanumérico

O novo formato mantém 14 posições.

As 12 primeiras posições poderão conter:

```text
0-9
A-Z
```

As duas últimas posições correspondem aos dígitos verificadores e permanecem numéricas.

Representação estrutural:

```text
XXXXXXXXXXXXDD
```

onde:

```text
X = caractere numérico ou alfabético permitido
D = dígito verificador numérico
```

As regras completas serão documentadas em:

```text
cnpj-alphanumeric.md
```

---

### 6.4 mod

**Nome:** Modelo do documento fiscal

**Posições:** 21 a 22

**Tamanho:** 2 posições

Para o escopo inicial desta biblioteca:

```text
55
```

corresponde à NF-e.

Como esta biblioteca inicialmente valida exclusivamente NF-e, o modelo esperado será `55`.

---

### 6.5 serie

**Nome:** Série da NF-e

**Posições:** 23 a 25

**Tamanho:** 3 posições

Representação estrutural:

```text
XXX
```

Exemplo:

```text
001
```

As faixas de série permitidas serão definidas em `validation-rules.md`.

---

### 6.6 nNF

**Nome:** Número da Nota Fiscal Eletrônica

**Posições:** 26 a 34

**Tamanho:** 9 posições

Representação estrutural:

```text
XXXXXXXXX
```

Exemplo:

```text
000123456
```

As regras de validade do número da NF-e serão documentadas em `validation-rules.md`.

---

### 6.7 tpEmis

**Nome:** Tipo de emissão

**Posição:** 35

**Tamanho:** 1 posição

Representação:

```text
X
```

O conteúdo identifica a modalidade utilizada para emissão da NF-e.

Os códigos permitidos para NF-e modelo 55 serão definidos em `validation-rules.md`.

---

### 6.8 cNF

**Nome:** Código numérico da NF-e

**Posições:** 36 a 43

**Tamanho:** 8 posições

Representação:

```text
XXXXXXXX
```

Exemplo estrutural:

```text
12345678
```

As regras específicas do campo serão documentadas em `validation-rules.md`.

---

### 6.9 cDV

**Nome:** Dígito verificador da chave de acesso

**Posição:** 44

**Tamanho:** 1 posição

Representação:

```text
X
```

O valor é calculado a partir das 43 posições anteriores da chave.

O algoritmo de cálculo será documentado em `validation-rules.md`.

A biblioteca deverá considerar o impacto da presença de caracteres alfanuméricos no CNPJ sobre o cálculo do DV da chave.

---

## 7. Índices para implementação em Dart

A documentação funcional utiliza posições iniciando em `1`.

Porém, strings em Dart utilizam índices iniciando em `0`.

Portanto, a correspondência para implementação será:

| Campo  | Posições documentais | Índices Dart | Exemplo de extração |
| ------ | -------------------- | ------------ | ------------------- |
| cUF    | 1–2                  | 0–1          | `substring(0, 2)`   |
| AAMM   | 3–6                  | 2–5          | `substring(2, 6)`   |
| CNPJ   | 7–20                 | 6–19         | `substring(6, 20)`  |
| mod    | 21–22                | 20–21        | `substring(20, 22)` |
| serie  | 23–25                | 22–24        | `substring(22, 25)` |
| nNF    | 26–34                | 25–33        | `substring(25, 34)` |
| tpEmis | 35                   | 34           | `substring(34, 35)` |
| cNF    | 36–43                | 35–42        | `substring(35, 43)` |
| cDV    | 44                   | 43           | `substring(43, 44)` |

Observação:

No método `substring(start, end)` do Dart, o índice inicial é inclusivo e o índice final é exclusivo.

Exemplo:

```dart
final cuf = accessKey.substring(0, 2);
```

extrai as duas primeiras posições.

---

## 8. Princípio de parsing

O parser da biblioteca deverá decompor a chave sem realizar inicialmente validações semânticas.

Exemplo conceitual:

```text
Chave bruta
    ↓
verificação mínima para permitir parsing
    ↓
extração das posições
    ↓
NfeAccessKey
```

A responsabilidade do parser será identificar os componentes.

A responsabilidade dos validadores será determinar se os componentes são válidos.

Essas responsabilidades não deverão ser misturadas.

---

## 9. Invariantes estruturais

A partir desta especificação, ficam definidos os seguintes invariantes:

1. A chave possui exatamente 44 posições.
2. A chave possui nove campos lógicos.
3. A ordem dos campos é fixa.
4. Nenhum campo possui tamanho variável.
5. O CNPJ ocupa sempre 14 posições.
6. O CNPJ poderá ser numérico ou alfanumérico.
7. O modelo ocupa exatamente duas posições.
8. O campo `cNF` ocupa exatamente oito posições.
9. O `cDV` ocupa sempre a última posição da chave.
10. A alteração para CNPJ alfanumérico não altera o tamanho total da chave.

---

## 10. Layout congelado — versão 1

Para a primeira versão da biblioteca, o seguinte layout é considerado congelado:

```text
01-02  cUF
03-06  AAMM
07-20  CNPJ
21-22  mod
23-25  serie
26-34  nNF
35     tpEmis
36-43  cNF
44     cDV
```

Alterações futuras neste layout deverão:

1. possuir referência oficial;
2. ser documentadas neste arquivo;
3. resultar em revisão da versão da especificação;
4. possuir testes correspondentes.

---

## 11. Referências

As referências normativas e técnicas utilizadas pela biblioteca serão centralizadas em:

```text
doc/references.md
```

As principais fontes para esta especificação são:

* Portal Nacional da Nota Fiscal Eletrônica;
* Manual de Orientação do Contribuinte — MOC 7.0;
* Anexo I — Leiaute e Regra de Validação da NF-e/NFC-e;
* Notas Técnicas publicadas pelo Portal Nacional da NF-e;
* Nota Técnica 2026.004 — adequação da NF-e/NFC-e ao CNPJ alfanumérico;
* documentação técnica da Receita Federal sobre o CNPJ alfanumérico.

---

## 12. Status da especificação

**Status:** Layout estrutural congelado — versão 1.

Este documento congela apenas:

* quantidade de campos;
* ordem;
* posição;
* tamanho;
* finalidade estrutural.

As regras semânticas ainda serão especificadas em:

```text
doc/validation-rules.md
```
