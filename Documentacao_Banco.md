Claro! Com base no script DDL que você forneceu (`MegaPower-SQLite3-CreateDB.sql`), preparei uma **documentação acadêmica** organizada e clara do banco de dados. Abaixo está um modelo que você pode incorporar ao seu projeto acadêmico.

---

# 📘 Documentação do Banco de Dados: MegaPower

## 🎯 Objetivo Geral

O banco de dados **MegaPower** foi projetado para armazenar, processar e analisar resultados da loteria **Mega-Sena**, fornecendo bases estatísticas e projeções sobre os concursos passados e prováveis combinações futuras. O foco está na inteligência analítica baseada em comportamento das dezenas sorteadas, com forte apoio em estatísticas, variações e distribuições de Poisson.

---

## 🧱 Estrutura Geral do Banco de Dados

O banco é composto por:

* **20+ Tabelas**: entre fatos, dimensões, agregações e apoio ao processo ETL.
* **30+ Views**: para análise estatística e projeções.
* **Extensões Estatísticas e Matemáticas**: integradas ao SQLite via `.dll` (por exemplo, `stats.dll` e `math.dll`).
* **Scripts em Java**: responsáveis por alimentar dados em algumas tabelas de fato.

---

## 📂 Principais Tabelas e Objetivos

### 🟦 `DUAL`

> Tabela utilitária com uma única linha e coluna. Serve como auxiliar para consultas que exigem ao menos uma linha como resultado.

---

### 🟨 `ETL0_CARGAS`

> Armazena metadados das cargas feitas via ETL (Extração dos arquivos da Caixa Econômica Federal).

**Campos Notáveis**:

* `CO_CARGA`: identificador único da carga.
* `DT_ARQ_CAIXA`, `QT_CONCURSOS`: garantem rastreabilidade e verificação da integridade dos dados carregados.

---

### 🟨 `CONCURSOS`

> Tabela bruta dos concursos, com dezenas sorteadas, data, somas, colunas auxiliares para mudanças de estado (`ES1` a `ES6`) e semana.

---

### 🟥 `DEZ_OCORRENCIAS`

> Tabela que **normaliza** os concursos em registros por dezena, posição e data, permitindo análises detalhadas por posição e frequência.

---

### 🟥 `FAT_DEPARA`

> Tabela de **fato principal** do modelo de mudança de estado: armazena a transição de uma dezena (DE) para outra (PARA) em uma determinada posição (POS), com várias estatísticas desnormalizadas de apoio.

**Estatísticas Incluídas**:

* Quantidade de ocorrências (QTD).
* Média, mínimo, máximo, desvio padrão.
* Probabilidade percentual de mudança.
* Probabilidade Poisson para nova ocorrência da dezena “PARA”.

---

### 🟨 `FAT_SORTEIOS`

> Armazena os dados consolidados de cada sorteio. Tabela pesada e altamente desnormalizada para **Data Warehouse**.

**Inclui**:

* Todas as dezenas e suas posições.
* Informações agregadas (mínimo, máximo, soma, média das dezenas).
* Padrões por quadrantes, pares/ímpares, regiões da cartela.
* Resultado do concurso (acumulado, ganhadores, rateios).

---

### 🟨 `FAT_DEZENAS_OCORRENCIAS`

> Acumula a **ocorrência histórica de cada dezena** até um dado concurso.

**Campos**:

* `VEZES`, `RANKING_POSICAO`, `RANKING`: quantifica e classifica a frequência.
* Datas da primeira e última aparição da dezena.

---

### 🟧 `EST_ATRASOS`

> Estatísticas de **atraso entre ocorrências** da mesma dezena por posição. Crucial para alimentar análises com Poisson e visualização de padrões.

---

### 🟧 `EST_MUD_ESTADO`

> Captura as **mudanças de padrão** DE → PARA em cada posição ao longo dos concursos.

---

### 🟦 `AGREG_SIGMAS_DEZENA`

> Tabela de agregação baseada em **níveis sigma** para cada dezena por posição. Utilizada para avaliar variações estatísticas nos padrões.

---

### 🟩 `DIM_DEZENA`

> Tabela de **dimensão** contendo metadados das dezenas:

* Código (1-60), nome por extenso, se é número primo, etc.

---

## 🔍 Principais Views de Análise

### `VW_AGREG_PP_N1` a `N5`

> Cadeia de views que agrupam estatísticas de transição entre dezenas em concursos consecutivos. São o **núcleo estatístico** do sistema de previsão.

---

### `VW_ANALISE_ULTIMO`

> Apresenta as melhores combinações DE → PARA com base no **último concurso** e rankeia com base em múltiplos critérios estatísticos.

---

### `VW_AGREG_ATRASOS_POISSON_ATRASAR`

> Analisa a **chance de uma dezena continuar atrasada**, usando distribuições de Poisson, baseada em histórico e distância da última aparição.

---

### `VW_EST_DEZENAS`

> Fornece estatísticas por dezena, incluindo:

* Total de concursos que participou.
* Quantidade de atrasos.
* Total de dias de atraso acumulado.

---

## 🧠 Inteligência Estatística Incorporada

O sistema incorpora conceitos como:

* **Distribuição de Poisson** para prever o retorno de dezenas.
* **Sigma e Desvio Padrão** para medir estabilidade de padrões.
* **Rankings Percentuais e Absolutos** para determinar as "melhores" dezenas.
* **Agregações Multinível** (POS → DEZENA → TRANSIÇÃO) para alimentar tabelas de fato.

---

## 🚀 Processos Automatizados

* **Carga**: via shell script e Java.
* **Estatísticas**: calculadas com extensões para SQLite3 (`stats.dll`, `math.dll`).
* **Importação**: via arquivos `.txt` padronizados da Caixa.

---

## 📌 Conclusão

O banco de dados MegaPower não apenas armazena concursos da Mega-Sena, mas estrutura e transforma esses dados com rigor estatístico, habilitando análises avançadas, previsões e insights baseados em ciência de dados e teoria das probabilidades.

---

Se quiser, posso gerar esse conteúdo em PDF ou DOCX formatado para você colar diretamente no projeto acadêmico. Deseja isso?
