# 📋 Relatório da Avaliação Final
**Instituição:** UFC

**Curso:** Introdução à Análise em Big Data

**Professor responsável:** Luiz Alexandre Moreira Barros

**Aluno(a):** Paloma Musa Mendes Pereira

**Link do repositório:** https://github.com/Paloma-Musa/bigdata-ciencia-de-dados-aplicadas-a-negocios-paloma-musa.git

# Atividade Final

## 3. Análise

As análises realizadas foram, Risco por canal (`channel`), Risco por categoria de estabelecimento (`merchant_category`) e Padrão temporal (dia, hora, ou dia da semana).

Finding (o número, direto): "O canal app apresenta taxa de fraude de 3,72%, mais que o dobro dos demais canais (web 1,75%, atm 1,74%, pos 1,35%)."

Insight (por que isso importa, o contexto de negócio por trás do número): "Isso é esperado, dado que transações via app não passam por nenhuma verificação presencial ou física, ao contrário do pos — o que reduz as barreiras naturais contra fraude nesse canal."

Ação (o que a área de risco faz com essa informação): "Recomenda-se priorizar regras de detecção adicionais (ex.: biometria, autenticação em duas etapas) especificamente para transações via app, já que é o canal que concentra o maior risco proporcional."

Risco por canal (`channel`)

|Canal |	Transações | Fraudes | Taxa de fraude|
|-------|-------|-------|-------| 
|app | 11.198 | 417 | 3,72%|
|web | 8.377 | 147 | 1,75%|
|atm | 2.813 | 49 | 1,74%|
|pos | 5.552 | 75 | 1,35%|

Risco por categoria de estabelecimento (`merchant_category`) 

|Categoria | Transações | Fraudes | Taxa de fraude|
|-------|-------|-------|-------|
|viagem | 2.825 | 146 | 5,17%|
|saude | 2.714 | 68 | 2,51%|
|varejo | 8.447 | 189 | 2,24%|
|alimentacao | 5.546 | 124	2,24%|
|servicos | 4.278 | 83 | 1,94%|
|eletronico | 4.130 | 78 | 1,89%|

Padrão temporal (dia, hora, ou dia da semana)

|Período| Transações | Fraudes | Taxa de fraude|
|-------|-------|-------|-------|
|madrugada | 7.041 | 227 | 3,22%|
|noite | 6.989 | 164 | 2,35%|
|manhã | 6.952 | 155 | 2,23%|
|tarde | 6.958 | 142 | 2,04%|
