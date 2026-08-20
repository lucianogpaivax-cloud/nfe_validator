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

# 6. Validação do CNPJ

## 6.1 Definição

O campo `CNPJ` ocupa as posições:

```text
7–20
```

da chave de acesso.

Possui:

```text
14 posições
```

A biblioteca deverá suportar simultaneamente:

* CNPJ numérico tradicional;
* CNPJ alfanumérico.

Os CNPJs numéricos existentes permanecem válidos e não serão convertidos para o novo formato.

---

## 6.2 Estrutura

O CNPJ possui a seguinte estrutura lógica:

```text
XXXXXXXXXXXXDD
```

onde:

```text
XXXXXXXXXXXX = 12 posições da identificação
DD           = 2 dígitos verificadores
```

No novo padrão:

* as primeiras 12 posições podem conter números e letras;
* as duas últimas posições devem ser obrigatoriamente numéricas.

---

## 6.3 Caracteres permitidos

Nas posições 1 a 12 do CNPJ serão permitidos:

```text
0–9
A–Z
```

As posições 13 e 14 deverão conter exclusivamente:

```text
0–9
```

Portanto, conceitualmente:

```text
[0-9A-Z]{12}[0-9]{2}
```

---

## 6.4 Letras minúsculas

A representação canônica utilizada pela biblioteca será em letras maiúsculas.

Exemplo canônico:

```text
12ABC34501DE35
```

A biblioteca deverá definir uma política explícita para letras minúsculas.

Para a versão inicial, será adotada a seguinte política:

```text
normalizar letras minúsculas para maiúsculas antes da validação
```

Exemplo:

```text
12abc34501de35
```

será normalizado para:

```text
12ABC34501DE35
```

antes do cálculo dos dígitos verificadores.

Essa normalização não altera o significado do identificador.

---

## 6.5 Formatação

A biblioteca deverá trabalhar internamente com CNPJ sem máscara.

Exemplo aceito internamente:

```text
12345678000195
```

ou:

```text
12ABC34501DE35
```

Representações contendo:

```text
.
/
-
espaços
```

não deverão aparecer dentro da chave de acesso.

Exemplo inválido dentro da chave:

```text
12.ABC.345/01DE-35
```

---

## 6.6 Separação entre base e dígitos verificadores

Para fins de cálculo:

```text
CNPJ = base + DV1 + DV2
```

onde:

```text
base = posições 1 a 12
DV1  = posição 13
DV2  = posição 14
```

Exemplo:

```text
12ABC34501DE35
```

será dividido em:

```text
Base = 12ABC34501DE
DV1  = 3
DV2  = 5
```

---

# 6.7 Conversão de caracteres para cálculo

O cálculo do CNPJ alfanumérico continua sendo realizado utilizando Módulo 11.

Antes da multiplicação pelos pesos, cada caractere deverá ser convertido em valor numérico.

A regra é:

```text
valor = código ASCII do caractere - 48
```

---

## 6.8 Conversão dos números

Para números:

| Caractere | ASCII | Valor utilizado |
| --------- | ----: | --------------: |
| 0         |    48 |               0 |
| 1         |    49 |               1 |
| 2         |    50 |               2 |
| 3         |    51 |               3 |
| 4         |    52 |               4 |
| 5         |    53 |               5 |
| 6         |    54 |               6 |
| 7         |    55 |               7 |
| 8         |    56 |               8 |
| 9         |    57 |               9 |

Portanto, para caracteres numéricos:

```text
valor calculado = próprio valor numérico
```

---

## 6.9 Conversão das letras

Para letras maiúsculas:

| Caractere | ASCII | Valor utilizado |
| --------- | ----: | --------------: |
| A         |    65 |              17 |
| B         |    66 |              18 |
| C         |    67 |              19 |
| D         |    68 |              20 |
| E         |    69 |              21 |
| ...       |   ... |             ... |
| Z         |    90 |              42 |

Exemplo:

```text
A → 65 - 48 = 17
B → 66 - 48 = 18
C → 67 - 48 = 19
```

Essa conversão deverá ser centralizada em uma função reutilizável.

Exemplo conceitual:

```text
characterToValue('0') → 0
characterToValue('9') → 9
characterToValue('A') → 17
characterToValue('B') → 18
characterToValue('Z') → 42
```

---

# 6.10 Primeiro dígito verificador — DV1

O primeiro dígito verificador será calculado utilizando as 12 primeiras posições do CNPJ.

Os pesos aplicados, da esquerda para a direita, são:

```text
5 4 3 2 9 8 7 6 5 4 3 2
```

Representação:

```text
CNPJ:  X X X X X X X X X X X X
Peso:  5 4 3 2 9 8 7 6 5 4 3 2
```

Cada caractere deverá:

1. ser convertido em valor numérico;
2. ser multiplicado pelo peso correspondente;
3. ter o resultado somado aos demais.

Depois:

```text
resto = soma % 11
```

O DV será determinado conforme a regra do Módulo 11 aplicável ao CNPJ.

Se:

```text
resto < 2
```

então:

```text
DV1 = 0
```

caso contrário:

```text
DV1 = 11 - resto
```

---

# 6.11 Segundo dígito verificador — DV2

Para o segundo dígito, utiliza-se:

```text
12 caracteres da base + DV1 calculado
```

Total:

```text
13 valores
```

Pesos:

```text
6 5 4 3 2 9 8 7 6 5 4 3 2
```

Representação:

```text
CNPJ:  X X X X X X X X X X X X D
Peso:  6 5 4 3 2 9 8 7 6 5 4 3 2
```

Depois:

```text
resto = soma % 11
```

Se:

```text
resto < 2
```

então:

```text
DV2 = 0
```

caso contrário:

```text
DV2 = 11 - resto
```

---

# 6.12 Validação completa

Um CNPJ somente será considerado válido quando:

```text
tamanho == 14
```

e:

```text
posições 1–12 contêm apenas 0-9 ou A-Z
```

e:

```text
posições 13–14 contêm apenas números
```

e:

```text
DV1 informado == DV1 calculado
```

e:

```text
DV2 informado == DV2 calculado
```

---

# 6.13 Exemplo oficial alfanumérico

Exemplo utilizado pela documentação técnica da Receita Federal:

```text
12ABC34501DE35
```

Separação:

```text
Base = 12ABC34501DE
DV   = 35
```

Esse exemplo deverá ser mantido como vetor de teste da biblioteca.

---

# 6.14 Compatibilidade com CNPJ numérico

A mesma estrutura de cálculo deverá continuar funcionando para:

```text
12345678000195
```

Isso é possível porque:

```text
ASCII('1') - 48 = 1
ASCII('2') - 48 = 2
```

e assim sucessivamente.

Portanto, o algoritmo alfanumérico permite uma implementação unificada para CNPJ numérico e alfanumérico.

A biblioteca deverá evitar manter:

```text
um algoritmo para CNPJ antigo
+
outro algoritmo para CNPJ novo
```

quando uma implementação única puder representar corretamente os dois formatos.

---

# 6.15 Regras de formato inválido

Deverão ser rejeitados:

```text
CNPJ com menos de 14 posições
CNPJ com mais de 14 posições
caracteres especiais
letras fora de A-Z
letras nas duas posições de DV
DV incorreto
```

Exemplos inválidos estruturalmente:

```text
12ABC34501DE3
12ABC34501DE355
12ABC34501D#35
12ABC34501DE3A
```

---

# 6.16 Códigos de erro sugeridos

Formato inválido:

```text
INVALID_CNPJ_FORMAT
```

Mensagem:

```text
O CNPJ informado possui formato inválido.
```

Dígitos verificadores incorretos:

```text
INVALID_CNPJ_DV
```

Mensagem:

```text
Os dígitos verificadores do CNPJ são inválidos.
```

---

# 6.17 Casos de teste

## Estrutura

```text
✓ aceita CNPJ numérico com 14 posições
✓ aceita CNPJ alfanumérico com 14 posições
✓ aceita letras A-Z nas primeiras 12 posições
✓ aceita dois números nas posições finais
```

## Normalização

```text
✓ normaliza letras minúsculas para maiúsculas
```

## Formato inválido

```text
✗ rejeita 13 posições
✗ rejeita 15 posições
✗ rejeita caractere especial
✗ rejeita letra no DV1
✗ rejeita letra no DV2
```

## Dígitos verificadores

```text
✓ aceita CNPJ numérico com DVs corretos
✓ aceita 12ABC34501DE35
✗ rejeita DV1 incorreto
✗ rejeita DV2 incorreto
```

---

# 6.18 Relação com o DV da chave NF-e

O suporte a CNPJ alfanumérico também afeta o cálculo do `cDV` da chave de acesso.

Isso ocorre porque as posições 7–20 da chave podem conter caracteres alfabéticos.

Portanto, o algoritmo responsável pelo DV final da chave não poderá presumir que todas as primeiras 43 posições são números.

Essa regra será especificada na seção:

```text
12. Dígito verificador da chave — cDV
```

---

# 6.19 Status

```text
[FECHADO] Estrutura do CNPJ
[FECHADO] Caracteres permitidos
[FECHADO] Normalização
[FECHADO] Conversão ASCII
[FECHADO] DV1
[FECHADO] DV2
[FECHADO] Compatibilidade numérico/alfanumérico
```


Documento relacionado:

```text
doc/cnpj-alphanumeric.md
```

---

# 7. Modelo

# 7. Validação do modelo — mod

## 7.1 Definição

O campo `mod` ocupa as posições:

```text
21–22
```

da chave de acesso.

Possui:

```text
2 posições
```

e identifica o modelo do documento fiscal eletrônico.

---

## 7.2 Regra para esta biblioteca

O escopo inicial da biblioteca é exclusivamente:

```text
NF-e — modelo 55
```

Portanto, o campo deverá ser exatamente:

```text
55
```

Qualquer outro valor deverá ser considerado inválido.

---

## 7.3 Exemplos

Válido:

```text
55
```

Inválidos:

```text
54
65
57
00
5
5A
```

Observação:

O modelo `65` corresponde à NFC-e e, embora faça parte do ecossistema NF-e/NFC-e, não pertence ao escopo inicial desta biblioteca.

---

## 7.4 Regra conceitual

```text
mod == "55"
```

---

## 7.5 Código de erro sugerido

```text
INVALID_MODEL
```

Mensagem sugerida:

```text
O modelo do documento deve ser 55 para NF-e.
```

---

## 7.6 Casos de teste

```text
✓ aceita 55

✗ rejeita 65
✗ rejeita 57
✗ rejeita 00
✗ rejeita caracteres não numéricos
```

---

# 8. Validação da série — serie

## 8.1 Definição

O campo `serie` ocupa as posições:

```text
23–25
```

da chave de acesso.

Possui:

```text
3 posições na chave
```

Embora o campo correspondente no XML possa possuir entre 1 e 3 dígitos, na composição da chave o valor é representado em três posições.

Exemplos:

```text
0   → 000
1   → 001
15  → 015
120 → 120
```

---

## 8.2 Formato estrutural

Na chave de acesso, a série deverá conter:

```text
exatamente 3 caracteres numéricos
```

Exemplos estruturalmente válidos:

```text
000
001
123
889
900
980
```

Exemplos estruturalmente inválidos:

```text
1
01
0001
A01
1A0
```

---

## 8.3 Séries e processo de emissão

A série não deve ser tratada apenas como um número entre `000` e `999`.

As faixas possuem significado associado ao processo de emissão.

Entre as faixas previstas na documentação estão:

```text
000–889
```

Aplicativo do contribuinte, para determinadas situações envolvendo emitente CNPJ.

```text
890–899
```

Emissão de NF-e avulsa pelo Fisco.

```text
900–909
```

Emissão no site do Fisco para determinados emitentes CNPJ.

```text
910–919
```

Faixa relacionada a determinadas emissões por emitente CPF.

```text
920–969
```

Faixa relacionada a determinadas emissões por aplicativo do contribuinte com emitente CPF.

Documentação mais recente também prevê faixas adicionais relacionadas a processos específicos de emissão, como Provedor de Assinatura e Autorização — PAA.

---

## 8.4 Decisão arquitetural

A chave de acesso, isoladamente, contém:

```text
serie
```

mas não contém todos os dados necessários para determinar completamente o processo de emissão que originou aquela série.

Por exemplo, campos como:

```text
procEmi
```

fazem parte do XML da NF-e, mas não estão presentes na chave de acesso.

Por esse motivo, a biblioteca não deverá inicialmente rejeitar uma chave apenas porque a série pertence a uma faixa reservada para determinado processo de emissão.

A validação offline da chave deverá distinguir:

### Validação estrutural

Verificar se:

```text
serie possui 3 posições numéricas
```

e se representa um valor compatível com o domínio geral previsto para série.

### Validação contextual

Verificar se determinada série é compatível com:

```text
procEmi
tipo de emitente
processo de emissão
```

Essa validação exige informações externas à chave e fica fora do escopo inicial do validador de chave isolada.

---

## 8.5 Faixa estrutural

Para a validação exclusivamente baseada na chave, será aceita uma série numérica de:

```text
000 até 999
```

desde que possua exatamente três posições.

Importante:

Isso não significa que toda combinação série/processo de emissão seja fiscalmente válida.

Significa apenas que a chave isolada não fornece contexto suficiente para rejeitar determinadas faixas reservadas.

---

## 8.6 Exemplos válidos estruturalmente

```text
000
001
010
120
889
890
900
920
969
980
999
```

---

## 8.7 Exemplos inválidos estruturalmente

```text
-01
A01
1A2
1000
01
```

---

## 8.8 Código de erro sugerido

```text
INVALID_SERIES
```

Mensagem sugerida:

```text
A série da NF-e deve possuir três caracteres numéricos.
```

---

## 8.9 Observação futura

Uma API expandida poderá receber contexto adicional:

```text
ValidationContext
```

contendo, por exemplo:

```text
procEmi
tipoEmitente
```

e executar validações mais específicas sobre a faixa da série.

Essa funcionalidade não pertence ao escopo da primeira versão.

---

## 8.10 Casos de teste

```text
✓ aceita 000
✓ aceita 001
✓ aceita 889
✓ aceita 890
✓ aceita 920
✓ aceita 980
✓ aceita 999

✗ rejeita A01
✗ rejeita 1A0
✗ rejeita tamanho 2
✗ rejeita tamanho 4
```

---

# 9. Validação do número da NF-e — nNF

## 9.1 Definição

O campo `nNF` ocupa as posições:

```text
26–34
```

da chave de acesso.

Possui:

```text
9 posições
```

e representa o número do documento fiscal.

---

## 9.2 Faixa permitida

A numeração da NF-e é sequencial e deve estar compreendida entre:

```text
1
```

e:

```text
999999999
```

A numeração deve ser reiniciada após atingir o limite máximo, observadas as regras aplicáveis ao estabelecimento e à série.

---

## 9.3 Representação na chave

Como o campo da chave possui nove posições, valores menores são preenchidos com zeros à esquerda.

Exemplos:

```text
NF-e nº 1
→ 000000001
```

```text
NF-e nº 150
→ 000000150
```

```text
NF-e nº 123456789
→ 123456789
```

---

## 9.4 Valor zero

O valor:

```text
000000000
```

deverá ser considerado inválido.

---

## 9.5 Formato

O campo deverá possuir:

```text
exatamente 9 caracteres numéricos
```

e, após interpretação numérica:

```text
1 <= nNF <= 999999999
```

---

## 9.6 Exemplos válidos

```text
000000001
000000002
000000150
123456789
999999999
```

---

## 9.7 Exemplos inválidos

```text
000000000
00000000
0000000000
00000000A
ABCDEFGHI
```

---

## 9.8 Regra conceitual

A validação deverá verificar:

```text
length == 9
```

e:

```text
todos os caracteres são numéricos
```

e:

```text
int(nNF) >= 1
```

---

## 9.9 Código de erro sugerido

Formato inválido:

```text
INVALID_NNF_FORMAT
```

Mensagem:

```text
O número da NF-e deve possuir nove caracteres numéricos.
```

Valor inválido:

```text
INVALID_NNF_VALUE
```

Mensagem:

```text
O número da NF-e deve estar entre 1 e 999999999.
```

---

## 9.10 Casos de teste

```text
✓ aceita 000000001
✓ aceita 000000150
✓ aceita 999999999

✗ rejeita 000000000
✗ rejeita tamanho menor que 9
✗ rejeita tamanho maior que 9
✗ rejeita caracteres alfabéticos
```

---

# 8. Série

A série não deve ser tratada apenas como um número entre 000 e 999.

As faixas possuem significado associado ao processo de emissão.

Entre as faixas previstas na documentação estão:

000–889

Aplicativo do contribuinte, para determinadas situações envolvendo emitente CNPJ.

890–899

Emissão de NF-e avulsa pelo Fisco.

900–909

Emissão no site do Fisco para determinados emitentes CNPJ.

910–919

Faixa relacionada a determinadas emissões por emitente CPF.

920–969

Faixa relacionada a determinadas emissões por aplicativo do contribuinte com emitente CPF.

Documentação mais recente também prevê faixas adicionais relacionadas a processos específicos de emissão, como Provedor de Assinatura e Autorização — PAA.

---

# 9. Número da NF-e — nNF

Status:

O campo nNF ocupa as posições:

26–34

da chave de acesso.

Possui:

9 posições

e representa o número do documento fiscal.

---

# 10. Tipo de emissão — tpEmis

10. Validação do tipo de emissão — tpEmis
10.1 Definição

O campo tpEmis ocupa a posição:

35

da chave de acesso.

Possui:

1 posição

e identifica a forma utilizada para emissão da NF-e.

10.2 Formato

O campo deverá possuir exatamente:

1 caractere numérico
10.3 Valores conhecidos

Os códigos previstos atualmente incluem:

Código	Significado
1	Emissão normal
2	Contingência FS-IA
3	Regime Especial NFF / histórico SCAN
4	Contingência EPEC
5	Contingência FS-DA
6	Contingência SVC-AN
7	Contingência SVC-RS
9	Contingência offline, conforme hipóteses previstas

O valor:

8

não pertence ao domínio atualmente previsto.

10.4 Observação sobre tpEmis = 9

Historicamente, o código 9 esteve associado principalmente à contingência offline da NFC-e.

Com as alterações mais recentes, esse código também pode ocorrer em NF-e modelo 55 em situações específicas relacionadas à emissão offline e ao DANFE Simplificado Tipo 2.

Portanto, a biblioteca não deverá rejeitar automaticamente:

tpEmis = 9

apenas porque o modelo é 55.

10.5 Decisão para validação offline da chave

Como a chave isolada não contém todos os elementos necessários para verificar o contexto completo da emissão, a primeira versão da biblioteca deverá aceitar estruturalmente:

1
2
3
4
5
6
7
9

e rejeitar:

0
8

ou qualquer outro valor fora do domínio conhecido.

10.6 Regra conceitual
tpEmis ∈ {1, 2, 3, 4, 5, 6, 7, 9}
10.7 Exemplos válidos
1
2
4
6
7
9
10.8 Exemplos inválidos
0
8
A
10
10.9 Código de erro sugerido
INVALID_EMISSION_TYPE

Mensagem:

O tipo de emissão informado não é válido para a NF-e.
10.10 Casos de teste
✓ aceita 1
✓ aceita 2
✓ aceita 3
✓ aceita 4
✓ aceita 5
✓ aceita 6
✓ aceita 7
✓ aceita 9

✗ rejeita 0
✗ rejeita 8
✗ rejeita A
✗ rejeita tamanho maior que 1

---

# 11. Código numérico — cNF

11. Validação do código numérico — cNF
11.1 Definição

O campo cNF ocupa as posições:

36–43

da chave de acesso.

Possui:

8 posições

e corresponde ao código numérico que compõe a chave de acesso.

11.2 Contexto

O campo cNF originalmente possuía nove posições.

Com a inclusão do campo tpEmis na chave de acesso, o cNF passou a possuir oito posições para que a chave continuasse mantendo o tamanho total de 44 posições.

11.3 Formato

O campo deverá possuir:

exatamente 8 caracteres numéricos

Exemplos estruturalmente válidos:

00000000
00000001
12345678
99999999
11.4 Regra de conteúdo

Na primeira versão da biblioteca, não será criada uma regra impondo:

cNF > 0

O requisito documental confirmado para a chave é a existência de oito posições numéricas.

Portanto:

00000000

não será considerado inválido exclusivamente pelo valor zero.

Uma restrição adicional somente deverá ser adicionada caso exista regra oficial específica aplicável ao escopo da biblioteca.

11.5 Regra conceitual
length == 8

e:

todos os caracteres são numéricos
11.6 Exemplos válidos
00000000
00000001
12345678
99999999
11.7 Exemplos inválidos
1234567
123456789
1234A678
ABCDEFGH
11.8 Código de erro sugerido
INVALID_CNF

Mensagem:

O código numérico da NF-e deve possuir oito caracteres numéricos.
11.9 Casos de teste
✓ aceita 00000000
✓ aceita 00000001
✓ aceita 12345678
✓ aceita 99999999

✗ rejeita 7 posições
✗ rejeita 9 posições
✗ rejeita letras
✗ rejeita caracteres especiais

---

# 12. Dígito verificador da chave — cDV

12. Validação do dígito verificador — cDV
12.1 Definição

O campo cDV ocupa:

posição 44

da chave de acesso.

Possui:

1 posição numérica

e tem a função de verificar a integridade da chave.

12.2 Base de cálculo

O DV será calculado utilizando as:

43 primeiras posições

da chave.

O cDV informado na posição 44 não participa do próprio cálculo.

Representação:

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX D
|--------------- 43 --------------------| |
                                           cDV
12.3 Normalização dos caracteres para cálculo

Como a chave poderá conter letras nas posições correspondentes ao CNPJ alfanumérico, o algoritmo não poderá assumir que todos os caracteres são algarismos.

Cada caractere das 43 posições deverá ser convertido em valor numérico pela regra:

valor = código ASCII - 48

Exemplos:

'0' → 48 - 48 = 0
'1' → 49 - 48 = 1
'9' → 57 - 48 = 9

'A' → 65 - 48 = 17
'B' → 66 - 48 = 18
'C' → 67 - 48 = 19
...
'Z' → 90 - 48 = 42

Essa mesma estratégia permite que o algoritmo funcione tanto para:

chaves totalmente numéricas

quanto para:

chaves contendo CNPJ alfanumérico
12.4 Pesos

Os pesos são aplicados:

da direita para a esquerda

sobre as 43 posições utilizadas no cálculo.

Sequência:

2, 3, 4, 5, 6, 7, 8, 9

Após o peso 9, a sequência reinicia em 2.

Assim:

posição mais à direita → peso 2
posição anterior       → peso 3
posição anterior       → peso 4
...
12.5 Somatório

Para cada posição:

valorConvertido × peso

Os resultados são somados:

soma = Σ(valor × peso)
12.6 Resto

Calcular:

resto = soma % 11
12.7 Determinação do DV

Se:

resto == 0

ou:

resto == 1

então:

DV = 0

Nos demais casos:

DV = 11 - resto
12.8 Regra resumida
se resto < 2:
    DV = 0
senão:
    DV = 11 - resto
12.9 Validação

Após calcular o DV:

DV calculado == cDV informado

Se forem iguais:

cDV válido

Caso contrário:

cDV inválido
12.10 Exemplo conceitual

Considere:

43 caracteres da chave

O algoritmo deverá:

1. percorrer da direita para a esquerda;
2. converter cada caractere;
3. aplicar pesos de 2 a 9;
4. somar os produtos;
5. obter o resto da divisão por 11;
6. calcular o DV;
7. comparar com a posição 44.
12.11 Compatibilidade com chaves antigas

Para caracteres numéricos:

ASCII('0') - 48 = 0
ASCII('1') - 48 = 1
...
ASCII('9') - 48 = 9

Portanto, a nova estratégia permanece compatível com as chaves numéricas existentes.

Não será necessário manter:

algoritmo antigo
+
algoritmo alfanumérico

A implementação poderá utilizar um único mecanismo.

12.12 Código de erro sugerido
INVALID_ACCESS_KEY_DV

Mensagem:

O dígito verificador da chave de acesso é inválido.
12.13 Casos de teste
✓ aceita chave numérica com DV correto
✓ aceita chave contendo CNPJ alfanumérico com DV correto

✗ rejeita chave numérica com DV alterado
✗ rejeita chave alfanumérica com DV alterado

Também deverão existir testes específicos para:

resto = 0
resto = 1
resto > 1

garantindo cobertura das duas ramificações do algoritmo.

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
[FECHADO] CNPJ 
[FECHADO] modelo 
[FECHADO] série 
[FECHADO] nNF 
[FECHADO] tpEmis 
[FECHADO] cNF 
[FECHADO] cDV
```
