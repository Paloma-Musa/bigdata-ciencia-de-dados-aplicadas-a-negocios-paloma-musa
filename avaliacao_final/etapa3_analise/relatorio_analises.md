# 📋 Relatório da Avaliação Final
**Instituição:** UFC

**Curso:** Introdução à Análise em Big Data

**Professor responsável:** Luiz Alexandre Moreira Barros

**Alunas:** Paloma Musa Mendes Pereira e Larissa Rocha Fonteles Vieira

**Link do repositório:** https://github.com/Paloma-Musa/bigdata-ciencia-de-dados-aplicadas-a-negocios-paloma-musa.git

# Atividade Final

## 3. Análise dos riscos de fraude

Após o processo de tratamento e organização dos dados nas camadas Bronze e Silver, foram realizadas análises exploratórias com o objetivo de identificar padrões relacionados à ocorrência de fraudes nas transações da TechPay. As análises foram organizadas em três dimensões: canal da transação, categoria do estabelecimento e período do dia.

Para cada dimensão, foram consideradas a quantidade total de transações, a quantidade de transações identificadas como fraudulentas e a respectiva taxa de fraude. A taxa de fraude foi calculada pela razão entre o número de transações fraudulentas e o total de transações de cada grupo.

### 3.1 Risco por canal

A análise por canal permite identificar quais meios de pagamento apresentam maior concentração proporcional de transações fraudulentas.

As análises realizadas foram, Risco por canal (`channel`), Risco por categoria de estabelecimento (`merchant_category`) e Padrão temporal (dia, hora, ou dia da semana).

|Canal |	Transações | Fraudes | Taxa de fraude|
|-------|-------|-------|-------| 
|app | 11.198 | 417 | 3,72%|
|web | 8.377 | 147 | 1,75%|
|atm | 2.813 | 49 | 1,74%|
|pos | 5.552 | 75 | 1,35%|

O principal resultado observado é que o canal app apresenta taxa de fraude de 3,72%, sendo superior às taxas observadas nos demais canais. A taxa registrada no aplicativo é mais que o dobro da observada nos canais web, ATM e POS.

Esse resultado indica que as transações realizadas pelo aplicativo representam um ponto de atenção para a área de risco, pois apresentam maior incidência proporcional de fraude. Diferentemente das transações realizadas em um POS ou ATM, as transações realizadas pelo aplicativo ocorrem em um ambiente digital e podem estar mais expostas a situações como comprometimento de credenciais, acesso indevido à conta ou uso de dispositivos não reconhecidos.

Diante desse resultado, recomenda-se priorizar mecanismos adicionais de detecção e autenticação para as transações realizadas pelo app, como autenticação em duas etapas, biometria, análise do dispositivo e regras de detecção baseadas no comportamento do cliente. A adoção dessas medidas deve ser direcionada principalmente às situações classificadas como de maior risco, evitando aumentar desnecessariamente a fricção para transações legítimas.

### 3.2 Risco por categoria de estabelecimento

A segunda análise considera a categoria do estabelecimento em que a transação foi realizada. Essa dimensão permite verificar se determinados segmentos apresentam maior incidência proporcional de fraude.

|Categoria | Transações | Fraudes | Taxa de fraude|
|-------|-------|-------|-------|
|viagem | 2.825 | 146 | 5,17%|
|saude | 2.714 | 68 | 2,51%|
|varejo | 8.447 | 189 | 2,24%|
|alimentacao | 5.546 | 124	2,24%|
|servicos | 4.278 | 83 | 1,94%|
|eletronico | 4.130 | 78 | 1,89%|

A categoria viagem apresenta a maior taxa de fraude, com 5,17%, ficando significativamente acima das demais categorias analisadas. Em seguida aparecem saúde, com 2,51%, varejo e alimentação, ambas com 2,24%.

O resultado indica que o risco de fraude não está distribuído de forma uniforme entre as categorias de estabelecimento. A diferença observada na categoria viagem sugere que esse segmento merece atenção específica nas estratégias de monitoramento.

Uma possível explicação está nas características das transações relacionadas a viagens, que podem envolver valores mais elevados, compras realizadas com antecedência e transações em diferentes localidades. Entretanto, os dados analisados não permitem afirmar que essas características sejam a causa da maior taxa de fraude. Dessa forma, o resultado deve ser interpretado como um padrão identificado nos dados, que pode orientar análises posteriores.

Como ação, recomenda-se que a área de risco avalie a criação ou o reforço de regras específicas para transações relacionadas à categoria viagem, considerando conjuntamente fatores como valor da transação, canal utilizado, localização, histórico do cliente e comportamento anterior. Essa abordagem permite evitar que a categoria seja tratada isoladamente como indicativo de fraude.

### 3.3 Padrão temporal

A terceira análise busca verificar se existe variação na ocorrência de fraudes de acordo com o período do dia em que as transações são realizadas.

|Período| Transações | Fraudes | Taxa de fraude|
|-------|-------|-------|-------|
|madrugada | 7.041 | 227 | 3,22%|
|noite | 6.989 | 164 | 2,35%|
|manhã | 6.952 | 155 | 2,23%|
|tarde | 6.958 | 142 | 2,04%|

A maior taxa de fraude foi observada durante a madrugada, com 3,22%, seguida pelo período da noite, com 2,35%. Os menores valores foram registrados durante a manhã, com 2,23%, e à tarde, com 2,04%.

Esse resultado mostra a existência de uma diferença no risco proporcional de fraude entre os períodos do dia. As transações realizadas durante a madrugada apresentam a maior taxa de fraude entre os períodos analisados, o que pode representar um sinal adicional para os mecanismos de monitoramento.

Uma possível explicação é que transações realizadas em horários de menor atividade possam apresentar maior desvio em relação ao comportamento habitual de determinados clientes. No entanto, assim como ocorre na análise por categoria, esse resultado não permite estabelecer uma relação causal apenas com os dados disponíveis.

Como ação, recomenda-se utilizar o horário da transação como uma variável adicional nos mecanismos de detecção de fraude. Transações realizadas durante a madrugada poderiam receber uma avaliação de risco adicional, especialmente quando combinadas com outros sinais, como valor elevado, canal de maior risco, dispositivo desconhecido ou comportamento atípico do cliente.

### 3.4 Síntese dos principais achados

As três análises permitem identificar diferentes dimensões associadas ao risco de fraude na base da TechPay. O canal app apresentou a maior taxa de fraude entre os canais, com 3,72%, enquanto a categoria viagem apresentou a maior taxa entre os estabelecimentos, com 5,17%. Na dimensão temporal, a madrugada apresentou a maior taxa de fraude, com 3,22%.

Os resultados sugerem que a identificação de transações potencialmente fraudulentas pode ser aprimorada pela combinação dessas dimensões. Em vez de considerar apenas uma característica isoladamente, a área de risco pode utilizar conjuntamente informações sobre canal, categoria e horário para construir regras de monitoramento mais específicas.

Por exemplo, uma transação realizada durante a madrugada pelo aplicativo e associada à categoria viagem poderia receber uma avaliação de risco mais elevada caso também apresente outros sinais de comportamento atípico. Esse tipo de combinação representa uma evolução em relação à análise individual dos indicadores e pode servir de base para uma etapa posterior de modelagem ou classificação de risco.
