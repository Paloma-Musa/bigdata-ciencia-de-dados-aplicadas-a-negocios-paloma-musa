## Usando ROTA B — Sem admin (Plotly, dashboard HTML standalone)

### Passo 1 — Instalar

```bash
pip install plotly pandas --user
```

### Passo 2 — Carregar os dados exportados no Lab 9

```python
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

fraud_risk = pd.read_csv('fraud_risk_export.csv')
print(fraud_risk)
```

# >>> import pandas as pd
# >>> import plotly.graph_objects as go
# >>> from plotly.subplots import make_subplots
# >>>


### Passo 3 — Montar as 4 seções do template de dashboard

```python
fig = make_subplots(
    rows=2, cols=2,
    specs=[[{"type":"indicator"}, {"type":"indicator"}],
           [{"type":"bar"}, {"type":"table"}]],
    subplot_titles=("", "", "Taxa de fraude por segmento", "Detalhe por segmento")
)

# 1) KPI — total de transações
fig.add_trace(go.Indicator(
    mode="number", value=fraud_risk['total_transacoes'].sum(),
    title={"text": "Total de Transações"}
), row=1, col=1)

# 2) KPI — taxa de fraude geral
taxa_geral = 100 * fraud_risk['qtd_fraudes'].sum() / fraud_risk['total_transacoes'].sum()
fig.add_trace(go.Indicator(
    mode="number", value=round(taxa_geral, 2),
    number={"suffix": "%"},
    title={"text": "Taxa de Fraude Geral"}
), row=1, col=2)

# 3) Composição — barras por segmento
fig.add_trace(go.Bar(
    x=fraud_risk['segment'], y=fraud_risk['taxa_fraude_pct'],
    marker_color=['#2ecc71','#f5a623','#e5484d']
), row=2, col=1)

# 4) Detalhe — tabela navegável
fig.add_trace(go.Table(
    header=dict(values=list(fraud_risk.columns)),
    cells=dict(values=[fraud_risk[c] for c in fraud_risk.columns])
), row=2, col=2)

fig.update_layout(height=650, title_text="Dashboard — Risco de Fraude", showlegend=False)
fig.write_html("dashboard_fraude.html")
print("Salvo em dashboard_fraude.html — abra no navegador")
```

### Passo 4 — Abrir e conferir

```bash
# Linux
xdg-open dashboard_fraude.html
# ou simplesmente abra o arquivo manualmente no navegador
```

### Passo 5 — Adicionar interatividade (hover já vem de graça no Plotly)

```python
fig.update_traces(hovertemplate="%{x}: %{y:.2f}%", row=2, col=1)
fig.write_html("dashboard_fraude.html")
```
