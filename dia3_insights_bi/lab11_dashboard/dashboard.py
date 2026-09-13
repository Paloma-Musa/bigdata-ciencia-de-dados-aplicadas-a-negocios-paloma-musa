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
# >>> colunas = ['segment', 'total_transacoes', 'valor_total', 'ticket_medio',
# ...            'qtd_fraudes', 'taxa_fraude_pct', 'valor_em_risco']
# >>> fraud_risk = pd.read_csv('fraud_risk_export.csv', header=None, names=colunas)
# >>> print(fraud_risk)
#      segment  total_transacoes   valor_total  ticket_medio  qtd_fraudes  taxa_fraude_pct  valor_em_risco
# 0  High-Risk              9154  1.664577e+06        181.84          705             7.70   126451.063813
# 1    Premium             61155  1.123502e+07        183.71          473             0.77    81308.434197
# 2   Standard             29687  5.478680e+06        184.55          655             2.21   106828.440390
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

# >>> fig = make_subplots(
# ...     rows=2, cols=2,
# ...     specs=[[{"type":"indicator"}, {"type":"indicator"}],
# ...            [{"type":"bar"}, {"type":"table"}]],
# ...     subplot_titles=("", "", "Taxa de fraude por segmento", "Detalhe por segmento")
# ... )
# >>>
# >>> # 1) KPI — total de transações
# >>> fig.add_trace(go.Indicator(
# ...     mode="number", value=fraud_risk['total_transacoes'].sum(),
# ...     title={"text": "Total de Transações"}
# ... ), row=1, col=1)
# Figure({
#     'data': [{'domain': {'x': [0.0, 0.45], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'title': {'text': 'Total de Transações'},
#               'type': 'indicator',
#               'value': np.int64(99996)}],
#     'layout': {'annotations': [{'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Taxa de fraude por segmento',
#                                 'x': 0.225,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'},
#                                {'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Detalhe por segmento',
#                                 'x': 0.775,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'}],
#                'template': '...',
#                'xaxis': {'anchor': 'y', 'domain': [0.0, 0.45]},
#                'yaxis': {'anchor': 'x', 'domain': [0.0, 0.375]}}
# })
# >>>
# >>> # 2) KPI — taxa de fraude geral
# >>> taxa_geral = 100 * fraud_risk['qtd_fraudes'].sum() / fraud_risk['total_transacoes'].sum()
# >>> fig.add_trace(go.Indicator(
# ...     mode="number", value=round(taxa_geral, 2),
# ...     number={"suffix": "%"},
# ...     title={"text": "Taxa de Fraude Geral"}
# ... ), row=1, col=2)
# Figure({
#     'data': [{'domain': {'x': [0.0, 0.45], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'title': {'text': 'Total de Transações'},
#               'type': 'indicator',
#               'value': np.int64(99996)},
#              {'domain': {'x': [0.55, 1.0], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'number': {'suffix': '%'},
#               'title': {'text': 'Taxa de Fraude Geral'},
#               'type': 'indicator',
#               'value': np.float64(1.83)}],
#     'layout': {'annotations': [{'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Taxa de fraude por segmento',
#                                 'x': 0.225,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'},
#                                {'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Detalhe por segmento',
#                                 'x': 0.775,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'}],
#                'template': '...',
#                'xaxis': {'anchor': 'y', 'domain': [0.0, 0.45]},
#                'yaxis': {'anchor': 'x', 'domain': [0.0, 0.375]}}
# })
# >>>
# >>> # 3) Composição — barras por segmento
# >>> fig.add_trace(go.Bar(
# ...     x=fraud_risk['segment'], y=fraud_risk['taxa_fraude_pct'],
# ...     marker_color=['#2ecc71','#f5a623','#e5484d']
# ... ), row=2, col=1)
# Figure({
#     'data': [{'domain': {'x': [0.0, 0.45], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'title': {'text': 'Total de Transações'},
#               'type': 'indicator',
#               'value': np.int64(99996)},
#              {'domain': {'x': [0.55, 1.0], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'number': {'suffix': '%'},
#               'title': {'text': 'Taxa de Fraude Geral'},
#               'type': 'indicator',
#               'value': np.float64(1.83)},
#              {'marker': {'color': ['#2ecc71', '#f5a623', '#e5484d']},
#               'type': 'bar',
#               'x': array(['High-Risk', 'Premium', 'Standard'], dtype=object),
#               'xaxis': 'x',
#               'y': {'bdata': 'zczMzMzMHkCkcD0K16PoP65H4XoUrgFA', 'dtype': 'f8'},
#               'yaxis': 'y'}],
#     'layout': {'annotations': [{'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Taxa de fraude por segmento',
#                                 'x': 0.225,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'},
#                                {'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Detalhe por segmento',
#                                 'x': 0.775,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'}],
#                'template': '...',
#                'xaxis': {'anchor': 'y', 'domain': [0.0, 0.45]},
#                'yaxis': {'anchor': 'x', 'domain': [0.0, 0.375]}}
# })
# >>>
# >>> # 4) Detalhe — tabela navegável
# >>> fig.add_trace(go.Table(
# ...     header=dict(values=list(fraud_risk.columns)),
# ...     cells=dict(values=[fraud_risk[c] for c in fraud_risk.columns])
# ... ), row=2, col=2)
# Figure({
#     'data': [{'domain': {'x': [0.0, 0.45], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'title': {'text': 'Total de Transações'},
#               'type': 'indicator',
#               'value': np.int64(99996)},
#              {'domain': {'x': [0.55, 1.0], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'number': {'suffix': '%'},
#               'title': {'text': 'Taxa de Fraude Geral'},
#               'type': 'indicator',
#               'value': np.float64(1.83)},
#              {'marker': {'color': ['#2ecc71', '#f5a623', '#e5484d']},
#               'type': 'bar',
#               'x': array(['High-Risk', 'Premium', 'Standard'], dtype=object),
#               'xaxis': 'x',
#               'y': {'bdata': 'zczMzMzMHkCkcD0K16PoP65H4XoUrgFA', 'dtype': 'f8'},
#               'yaxis': 'y'},
#              {'cells': {'values': [['High-Risk', 'Premium', 'Standard'], [9154,
#                                    61155, 29687], [1664576.8214797974,
#                                    11235017.883358955, 5478679.74229908], [181.84,
#                                    183.71, 184.55], [705, 473, 655], [7.7, 0.77,
#                                    2.21], [126451.06381320952, 81308.43419742584,
#                                    106828.44038963318]]},
#               'domain': {'x': [0.55, 1.0], 'y': [0.0, 0.375]},
#               'header': {'values': [segment, total_transacoes, valor_total,
#                                     ticket_medio, qtd_fraudes, taxa_fraude_pct,
#                                     valor_em_risco]},
#               'type': 'table'}],
#     'layout': {'annotations': [{'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Taxa de fraude por segmento',
#                                 'x': 0.225,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'},
#                                {'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Detalhe por segmento',
#                                 'x': 0.775,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'}],
#                'template': '...',
#                'xaxis': {'anchor': 'y', 'domain': [0.0, 0.45]},
#                'yaxis': {'anchor': 'x', 'domain': [0.0, 0.375]}}
# })
# >>>
# >>> fig.update_layout(height=650, title_text="Dashboard — Risco de Fraude", showlegend=False)
# Figure({
#     'data': [{'domain': {'x': [0.0, 0.45], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'title': {'text': 'Total de Transações'},
#               'type': 'indicator',
#               'value': np.int64(99996)},
#              {'domain': {'x': [0.55, 1.0], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'number': {'suffix': '%'},
#               'title': {'text': 'Taxa de Fraude Geral'},
#               'type': 'indicator',
#               'value': np.float64(1.83)},
#              {'marker': {'color': ['#2ecc71', '#f5a623', '#e5484d']},
#               'type': 'bar',
#               'x': array(['High-Risk', 'Premium', 'Standard'], dtype=object),
#               'xaxis': 'x',
#               'y': {'bdata': 'zczMzMzMHkCkcD0K16PoP65H4XoUrgFA', 'dtype': 'f8'},
#               'yaxis': 'y'},
#              {'cells': {'values': [['High-Risk', 'Premium', 'Standard'], [9154,
#                                    61155, 29687], [1664576.8214797974,
#                                    11235017.883358955, 5478679.74229908], [181.84,
#                                    183.71, 184.55], [705, 473, 655], [7.7, 0.77,
#                                    2.21], [126451.06381320952, 81308.43419742584,
#                                    106828.44038963318]]},
#               'domain': {'x': [0.55, 1.0], 'y': [0.0, 0.375]},
#               'header': {'values': [segment, total_transacoes, valor_total,
#                                     ticket_medio, qtd_fraudes, taxa_fraude_pct,
#                                     valor_em_risco]},
#               'type': 'table'}],
#     'layout': {'annotations': [{'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Taxa de fraude por segmento',
#                                 'x': 0.225,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'},
#                                {'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Detalhe por segmento',
#                                 'x': 0.775,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'}],
#                'height': 650,
#                'showlegend': False,
#                'template': '...',
#                'title': {'text': 'Dashboard — Risco de Fraude'},
#                'xaxis': {'anchor': 'y', 'domain': [0.0, 0.45]},
#                'yaxis': {'anchor': 'x', 'domain': [0.0, 0.375]}}
# })
# >>> fig.write_html("dashboard_fraude.html")
# >>> print("Salvo em dashboard_fraude.html — abra no navegador")
# Salvo em dashboard_fraude.html — abra no navegador
# >>>

### Passo 4 — Abrir e conferir

```bash
# Linux
xdg-open dashboard_fraude.html
# ou simplesmente abra o arquivo manualmente no navegador
```

# >>> exit()
# palomamusa@DESKTOP-NJ8QT5E:~$ explorer.exe dashboard_fraude.html

### Passo 5 — Adicionar interatividade (hover já vem de graça no Plotly)

```python
fig.update_traces(hovertemplate="%{x}: %{y:.2f}%", row=2, col=1)
fig.write_html("dashboard_fraude.html")
```
# >>> fig.update_traces(hovertemplate="%{x}: %{y:.2f}%", row=2, col=1)
# Figure({
#     'data': [{'domain': {'x': [0.0, 0.45], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'title': {'text': 'Total de Transações'},
#               'type': 'indicator',
#               'value': np.int64(99996)},
#              {'domain': {'x': [0.55, 1.0], 'y': [0.625, 1.0]},
#               'mode': 'number',
#               'number': {'suffix': '%'},
#               'title': {'text': 'Taxa de Fraude Geral'},
#               'type': 'indicator',
#               'value': np.float64(1.83)},
#              {'hovertemplate': '%{x}: %{y:.2f}%',
#               'marker': {'color': ['#2ecc71', '#f5a623', '#e5484d']},
#               'type': 'bar',
#               'x': array(['High-Risk', 'Premium', 'Standard'], dtype=object),
#               'xaxis': 'x',
#               'y': {'bdata': 'zczMzMzMHkCkcD0K16PoP65H4XoUrgFA', 'dtype': 'f8'},
#               'yaxis': 'y'},
#              {'cells': {'values': [['High-Risk', 'Premium', 'Standard'], [9154,
#                                    61155, 29687], [1664576.8214797974,
#                                    11235017.883358955, 5478679.74229908], [181.84,
#                                    183.71, 184.55], [705, 473, 655], [7.7, 0.77,
#                                    2.21], [126451.06381320952, 81308.43419742584,
#                                    106828.44038963318]]},
#               'domain': {'x': [0.55, 1.0], 'y': [0.0, 0.375]},
#               'header': {'values': [segment, total_transacoes, valor_total,
#                                     ticket_medio, qtd_fraudes, taxa_fraude_pct,
#                                     valor_em_risco]},
#               'type': 'table'}],
#     'layout': {'annotations': [{'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Taxa de fraude por segmento',
#                                 'x': 0.225,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'},
#                                {'font': {'size': 16},
#                                 'showarrow': False,
#                                 'text': 'Detalhe por segmento',
#                                 'x': 0.775,
#                                 'xanchor': 'center',
#                                 'xref': 'paper',
#                                 'y': 0.375,
#                                 'yanchor': 'bottom',
#                                 'yref': 'paper'}],
#                'height': 650,
#                'showlegend': False,
#                'template': '...',
#                'title': {'text': 'Dashboard — Risco de Fraude'},
#                'xaxis': {'anchor': 'y', 'domain': [0.0, 0.45]},
#                'yaxis': {'anchor': 'x', 'domain': [0.0, 0.375]}}
# })
# >>> fig.write_html("dashboard_fraude.html")
# >>>
