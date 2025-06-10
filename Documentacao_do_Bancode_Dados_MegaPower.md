# Documentação do Banco de Dados Mega Power

## Resumo Executivo

O banco de dados **MegaPower.db** contém um histórico completo dos sorteios da Mega Sena desde 1996, com **2.872 concursos** analisados e **17.232 registros** de ocorrências de dezenas.

## Estrutura Principal

### 📊 Tabelas Principais

#### 1. **DEZ_OCORRENCIAS**
- **Propósito**: Histórico granular de cada dezena por posição
- **Registros**: 17.232 ocorrências
- **Período**: Concursos 1 a 2.872 (1996-2025)
- **Campos principais**:
  - `CONCURSO`: Número do concurso
  - `DATA`: Data do sorteio
  - `DEZENA`: Número sorteado (01-60)
  - `POS`: Posição no sorteio (P1-P6)
  - `SEMANA`: Dia da semana

#### 2. **AGREG_DIS_DEZ_POSICAO**
- **Propósito**: Distribuição de cada dezena por posição
- **Registros**: 60 dezenas
- **Campos principais**:
  - `DEZENA`: Número da dezena
  - `QTD1` a `QTD6`: Quantidade de vezes em cada posição
  - `TOTAL_DEZENA`: Total de ocorrências

#### 3. **CONCURSOS**
- **Propósito**: Dados consolidados dos sorteios
- **Registros**: 2.872 concursos

### 📈 Views Importantes

- **VW_EST_DEZENAS**: Estatísticas das dezenas
- **VW_DEZENAS_SORTEADAS_ATRASOS**: Análise de atrasos
- **VW_ULTIMO_CONCURSO**: Último sorteio
- **VW_ANALISE_ULTIMO**: Análise do último concurso

## Descobertas Estatísticas

### Top 5 Dezenas Mais Sorteadas:
1. **Dezena 10**: 337 ocorrências
2. **Dezena 53**: 328 ocorrências  
3. **Dezena 05**: 314 ocorrências
4. **Dezena 34**: 311 ocorrências
5. **Dezena 33**: 308 ocorrências

### Top 5 Dezenas Menos Sorteadas:
1. **Dezena 26**: 237 ocorrências
2. **Dezena 07**: 245 ocorrências
3. **Dezena 09**: 248 ocorrências
4. **Dezena 21**: 250 ocorrências
5. **Dezena 13**: 252 ocorrências

### Padrões por Posição:
- **Posição 1**: Média 47,8 ocorrências por dezena
- **Posição 2**: Média 47,8 ocorrências por dezena
- **Posição 3**: Média 47,8 ocorrências por dezena
- **Posição 4**: Média 47,8 ocorrências por dezena
- **Posição 5**: Média 47,8 ocorrências por dezena
- **Posição 6**: Média 47,8 ocorrências por dezena

## Outras Tabelas Relevantes

- **AGREG_DEZ_DIA_SEMANA**: Ocorrências por dia da semana
- **AGREG_DEZ_DIA_MES**: Ocorrências por dia do mês
- **AGREG_SIGMAS_DEZENA**: Análise de desvios padrão
- **EST_ATRASOS**: Estatísticas de atrasos das dezenas

