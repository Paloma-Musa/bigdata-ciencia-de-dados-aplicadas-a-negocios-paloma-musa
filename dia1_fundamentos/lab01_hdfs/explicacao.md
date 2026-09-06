# Lab 01 — HDFS: estrutura, upload e replicação

Segui a Rota A do lab, utilizando um ambiente Hadoop pseudo-distribuído configurado no WSL (Ubuntu dentro do Windows).

## Preparação do ambiente e Passo 1 - Confirmar que o HDFS está de pé

Antes de iniciar o lab propriamente dito, precisei resolver um problema de pré-requisito: o Hadoop depende do serviço SSH para subir seus processos internos, e esse serviço não estava ativo no meu ambiente WSL. O pacote já estava instalado, mas o serviço em si não estava rodando. Como o WSL não utiliza o systemd como sistema de inicialização por padrão, iniciei o serviço SSH através do comando alternativo de inicialização de serviços do Ubuntu, o que resolveu o problema. Após isso, confirmei que os três processos essenciais do HDFS — NameNode, DataNode e SecondaryNameNode — estavam em execução.

## Passo 2 — Criar a estrutura de camadas e Passo 3 — Conferir a estrutura

Criei a estrutura de pastas dentro do HDFS que será utilizada ao longo de todo o curso: uma camada de dados brutos (raw), subdividida por dataset (clientes, transações e rótulos de fraude), e as camadas de processamento subsequentes — bronze, silver e gold — que serão preenchidas nos próximos labs à medida que os dados forem sendo tratados e refinados.

## Passo 4 — Subir os 3 datasets

Enviei os três arquivos CSV originais (clientes, transações e rótulos de fraude) para dentro das respectivas pastas da camada raw. A conferência da estrutura mostrou os três arquivos armazenados com os tamanhos esperados, confirmando que o envio ocorreu sem perda de dados.

## Passo 5 — Verificar a replicação 3×

Ao verificar a saúde do arquivo de transações no HDFS, o sistema reportou o arquivo como íntegro (status HEALTHY), sem blocos corrompidos ou ausentes. No entanto, o fator de replicação observado foi de 1×, e não de 3× como seria esperado em um cluster de produção. Isso provavemente ocorreu porque meu ambiente possui apenas um único DataNode: a replicação distribuída em múltiplas cópias só é possível quando existem pelo menos três nós de dados distintos, já que o objetivo da replicação é a tolerância a falhas entre máquinas diferentes. Com apenas um nó disponível, o próprio Hadoop ajustou automaticamente o fator de replicação para 1, pois não há onde armazenar cópias adicionais.

## Passo 6 — Contar as linhas direto do HDFS

Por fim, contei as linhas dos arquivos de clientes e transações diretamente a partir do conteúdo armazenado no HDFS. Os valores obtidos ficaram muito próximos do esperado, com uma diferença de exatamente uma linha a mais em cada arquivo. Ao inspecionar o final dos arquivos, identifiquei que essa linha extra corresponde a uma linha em branco ao final do CSV e não a um erro de importação ou de contagem.

## Conclusão

O lab foi concluído com a estrutura de camadas criada, os três datasets armazenados corretamente no HDFS e verificados quanto à integridade. A principal aprendizagem prática foi entender, na prática e não apenas na teoria, por que a replicação distribuída depende diretamente do número de nós disponíveis no cluster.
