-- 1. **Ingestão** — trazer `avaliacao_transactions.csv` para o ambiente (HDFS ou pasta local)
-- Rodando o código para gerar o arquivo CSV com os dados
python3 generate_avaliacao_dataset.py
-- palomamusa@DESKTOP-NJ8QT5E:~$ python3 generate_avaliacao_dataset.py
-- Gerando base de dados da avaliação...
-- ✓ 30000 linhas geradas
--   Taxa de fraude geral: 2.50%
--   Fraude por channel:
-- channel
-- app    3.79%
-- atm    1.80%
-- web    1.74%
-- pos    1.42%
-- Name: is_fraud, dtype: str
--   Fraude por merchant_category:
-- merchant_category
-- viagem         5.32%
-- saude          2.47%
-- alimentacao    2.31%
-- varejo         2.24%
-- servicos       1.97%
-- eletronico     1.96%
-- Name: is_fraud, dtype: str
--   Fraude por segmento:
-- segment
-- High-Risk    9.67%
-- Standard     2.93%
-- Premium      0.95%
-- Name: is_fraud, dtype: str

-- Localizando o arquivo
ls -la /tmp/avaliacao_transactions.csv
-- palomamusa@DESKTOP-NJ8QT5E:~$ ls -la /tmp/avaliacao_transactions.csv
-- -rw-r--r-- 1 palomamusa palomamusa 2742011 Sep  7 17:40 /tmp/avaliacao_transactions.csv

-- Movendo o CSV pra a home
mv /tmp/avaliacao_transactions.csv ~/
ls -la ~/avaliacao_transactions.csv
-- palomamusa@DESKTOP-NJ8QT5E:~$ mv /tmp/avaliacao_transactions.csv ~/
-- palomamusa@DESKTOP-NJ8QT5E:~$ ls -la ~/avaliacao_transactions.csv
-- -rw-r--r-- 1 palomamusa palomamusa 2742011 Sep  7 17:40 /home/palomamusa/avaliacao_transactions.csv


-- 2. **Criação de tabela raw** — schema definido, tipos corretos
-- 3. **Particionamento** — aplique a estratégia desenhada na Etapa 1
-- 4. **Bronze** — limpeza (duplicatas, tipos, valores impossíveis)
-- 5. **Silver** — enriquecimento (avalie quais colunas fazem sentido derivar — ex.: faixa de valor, período do dia)
-- 6. **Gold** — pelo menos 2 tabelas agregadas diferentes, pensando no que a Etapa 3 vai precisar
