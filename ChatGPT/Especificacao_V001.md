# Especificacao.md

## 1. Visao Geral do Sistema

O sistema MegaPowerX tem por objetivo principal gerar apostas otimizadas para a Mega-Sena, com base em estratégias estatísticas e dinâmicas, utilizando dados históricos reais e mecanismos de ranking configuráveis. O sistema será totalmente escrito em Java, com suporte a execução multithread, acesso a banco de dados SQLite e parametrização por linha de comando POSIX e arquivos `.properties`.

## 2. Requisitos Funcionais

1. **Geração de Apostas**:
   - Aleatória (modo RANDOM)
   - Todas as combinações possíveis (modo FULL)
   - Lidas de arquivo (modo FILE)

2. **Cadeia de Estratégias**:
   - Aplicar sequencialmente estratégias estatísticas/dinâmicas.
   - Interface unificada com método `process(ApostaCandidata)`.
   - Estratégias são configuráveis por limites mín/máx e pesos.

3. **Ranking das Apostas**:
   - Soma ponderada das avaliações por estratégia.
   - Ordem decrescente de pontuação.

4. **Persistência**:
   - Banco de dados SQLite 3.
   - Tabelas: `FAT_APOSTAS`, `EST_MUD_ESTADO`, `AGREG_DIS_DEZ_POSICAO`, etc.
   - Conexões em pool e acesso concorrente seguro.

5. **Execução**:
   - Compatível com Java 19+.
   - Interface de linha de comando POSIX-compliant.
   - Fat-JAR com todas dependências inclusas.

## 3. Estrutura de Classes

### Classe Abstrata: `Estrategia`
```java
public abstract class Estrategia {
   protected double addRankIfTrue;
   protected double addRankIfFalse;
   protected double minLimit;
   protected double maxLimit;

   public abstract double process(ApostaCandidata aposta);
}
```

### Classe: `ApostaCandidata`
- Representa uma aposta gerada, com 6 dezenas de 01 a 60.
- Armazena ranking atual e histórico de avaliações.

### Classe: `CadeiaEstrategias`
- Thread-safe.
- Executa `process()` de cada estratégia sobre a aposta.

## 4. Formatos de Entrada

### Linha de Comando (POSIX)
| Parâmetro | Descrição                            | Valores Aceitos    | Obrigatório |
| --------- | ------------------------------------ | ------------------ | ----------- |
| `-n`      | Nº de apostas filtradas do resultado | Inteiro > 0        | Sim*        |
| `-m`      | Modo de geração                      | RANDOM, FILE, FULL | Sim         |
| `-t`      | Nº de threads                        | Inteiro > 0        | Não         |
| `-d`      | Caminho do banco SQLite              | String             | Não         |
| `-v`      | Verbosidade                          | 0 a 3              | Não         |

* Obrigatório exceto no modo FULL.

### Arquivo `.properties`
```properties
modo=RANDOM
num_apostas=10
num_threads=4
caminho_db=./megapower.db
verbose=2
```

## 5. Banco de Dados

- Utiliza-se `SQLite 3` com base de dados `megapower.db`.
- Tabelas de apoio já agregam informações:
  - `DEZ_OCORRENCIAS`
  - `AGREG_DIS_DEZ_POSICAO`
  - `EST_MUD_ESTADO`
  - `FAT_APOSTAS`

## 6. Geração de Apostas

- Aleatória: sorteio por índice lexicográfico.
- Total: todas as 50.063.860 combinações.
- Arquivo: lista UTF-8 de apostas linha a linha.

## 7. Execução e Empacotamento

- Empacotado em `.jar` único (fat jar).
- Inclui todas as dependências.
- Rodável em Java 19+.
- Arquivo gerado: `megapowerx.jar`

## 8. Conformidade e Estilo de Código

- Identadores: 3 espaços (sem TABs).
- Codificação UTF-8.
- Comentários em Markdown.
- Sem placeholders ou TODOs pendentes.

## 9. Versão

| Data             | Versão | O que foi trocado         | Por quê              |
| ---------------- | ------ | ------------------------- | -------------------- |
| 2025-06-22 20:00 | 0.1.0  | Documento inicial         | Início da Fase 1     |
| 2025-06-22 20:55 | 0.1.1  | Geração para download     | Avaliação externa    |
