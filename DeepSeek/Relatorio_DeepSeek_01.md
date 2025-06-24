# Relatório 01 Deep Seek

# Especificação do Sistema para Geração de Apostas da Mega-Sena

## 1. Visão Geral
O sistema proposto tem como objetivo gerar sugestões de apostas para a Mega-Sena, utilizando estratégias estatísticas e dinâmicas baseadas em dados históricos dos sorteios. O sistema será desenvolvido em Java e consistirá em duas fases principais: documentação e implementação.

## 2. Requisitos Funcionais
- **RF01**: Gerar apostas aleatórias baseadas em índices lexicográficos.
- **RF02**: Avaliar todas as combinações possíveis de apostas.
- **RF03**: Processar listas de apostas candidatas a partir de arquivos TXT.
- **RF04**: Aplicar estratégias estatísticas e dinâmicas para ranquear apostas.
- **RF05**: Persistir os resultados em um banco de dados SQLite.
- **RF06**: Suportar execução multithread para melhor desempenho.
- **RF07**: Configurar o sistema via linha de comando (POSIX) ou arquivo `.properties`.
- **RF08**: Gerar relatórios de desempenho das apostas sugeridas.

## 3. Requisitos Não Funcionais
- **RNF01**: Desempenho - O sistema deve processar grandes volumes de dados eficientemente.
- **RNF02**: Usabilidade - Interface de linha de comando intuitiva e documentada.
- **RNF03**: Portabilidade - Funcionar em qualquer sistema com Java 19+.
- **RNF04**: Manutenibilidade - Código bem documentado e seguindo boas práticas.
- **RNF05**: Segurança - Uso de conexões seguras e validação de dados.

## 4. Arquitetura do Sistema
### 4.1. Diagrama de Componentes
- **Módulo de Geração de Apostas**: Responsável por criar apostas aleatórias ou ler de arquivos.
- **Módulo de Estratégias**: Implementa as estratégias estatísticas e dinâmicas.
- **Módulo de Persistência**: Gerencia a conexão com o banco de dados SQLite.
- **Módulo de Relatórios**: Gera análises de desempenho das apostas.

### 4.2. Diagrama de Classes Principais
- **Aposta**: Representa uma aposta candidata.
- **Estrategia**: Classe abstrata para implementação de estratégias.
- **GerenciadorApostas**: Coordena a geração e avaliação de apostas.
- **BancoDeDados**: Gerencia a persistência dos dados.

## 5. Estrutura de Dados
- **Tabela FAT_APOSTAS**: Armazena as apostas geradas e seus rankings.
- **Tabela DEZ_OCORRENCIAS**: Contém estatísticas de ocorrência de dezenas.
- **Tabela AGREG_DIS_DEZ_POSICAO**: Estatísticas de dezenas por posição.

## 6. Fluxo de Processamento
1. **Entrada**: Parâmetros de linha de comando ou arquivo de configuração.
2. **Geração**: Criação de apostas conforme o modo especificado.
3. **Avaliação**: Aplicação das estratégias para ranquear as apostas.
4. **Persistência**: Armazenamento dos resultados no banco de dados.
5. **Saída**: Relatório das apostas sugeridas e seu desempenho.

## 7. Estratégias Implementadas
- **Estratégia Estatística**: Baseada em frequência de dezenas.
- **Estratégia Dinâmica**: Usa transições de estado e probabilidades condicionais.

## 8. Configuração
- **Arquivo .properties**: Define parâmetros como número de threads e caminho do banco.
- **Linha de Comando**: Opções POSIX para controle flexível da execução.

## 9. Testes
- **Testes Unitários**: Para cada módulo do sistema.
- **Testes de Integração**: Verificar a interação entre os módulos.
- **Testes de Desempenho**: Avaliar o tempo de processamento com grandes volumes.

## 10. Entrega
- **Documentação**: Especificação completa e EAP detalhada.
- **Código Fonte**: Implementação em Java, empacotada em um JAR.
- **Relatórios**: Análises de desempenho e sugestões de apostas.

---

# EAP (Estrutura Analítica do Projeto)

| Pacote de Trabalho          | Entregáveis                                  | Tempo Estimado (horas) | Créditos Estimados |
|-----------------------------|---------------------------------------------|-----------------------|--------------------|
| Documentação                | Especificacao.md, EAP.md                    | 10                    | 5                  |
| Módulo de Geração           | Classes para geração de apostas             | 15                    | 10                 |
| Módulo de Estratégias       | Implementação das estratégias               | 20                    | 15                 |
| Módulo de Persistência      | Conexão com SQLite e queries                | 15                    | 10                 |
| Módulo de Relatórios        | Geração de relatórios de desempenho         | 10                    | 5                  |
| Integração e Testes         | Testes unitários e de integração            | 20                    | 15                 |
| Empacotamento               | Criação do JAR                              | 5                     | 5                  |
| **Total**                   |                                             | **95**                | **65**             |

--- 

Esta especificação atende aos requisitos da Fase 1, fornecendo uma base sólida para a implementação na Fase 2. Aguardo sua aprovação para prosseguir com a construção do sistema.