
# Histórico de Versões
| versão |  Data             | O que mudou | 
| --- | --- | --- |  
| 1.0    | 11/05/2025 | Criação           |
| 1.5    | 01/06/2025 | Atualizado em respostas aos questionamentos das IAs |
| 1.52   | 20/06/2025 | Mais ajustes para atender aos questionamentos das IAs |
| 2.00   | 21/06/2025 | Ajustes finais. |

### TODO:
- Especificar `ESTRATEGIA`, `CADEIA DE ESTRATÉGIAS`, `APOSTA GERADA`,  `APOSTAS CANDIDATAS`, 


# O Prompt 
Trata-se de um exemplo padrão de solicitação de tarefas às IAs, com objetivo de promover um Benchmark entre elas, e podermos avaliar qual delas é a melhor para apoiar no Desenvolvimento de Software. Vários aspectos serão avaliados em relação as entregas de cada IA.

# Objetivo
Escrever uma aplicação com base em dados públicos, mantidos no Site [Mega Power - Loterias](https://megapower-loterias.com.br), para gerar apostas postas massivas para a sorteios futuros da `Mega-Sena`. Este desafio consistem em duas etapas muito bem definidas:
- **Fase 1**:   Criar toda a documentação do projeto incluindo a especificação completa do sistema e não os códigos fontes, ou  arquivos de configurações ou outros artefatos do projeto, para a criação de um sistema em Java, capaz de gerar sugestões de jogos para sorteios da `Mega-Sena`, com base em `ESTRATÉGIAS ESTATÍSTICAS` e `ESTRATÉGIAS DINÂMICAS` (baseadas em dados do banco de dados de resultados dos sorteios) , com suporte a geração massiva de apostas, paralelização e persistência dos dados para análise futura.
	1. O documento da especificação, deve ser gerado, sem gerar arquivos intermediários não solicitados, com o nome Especificacao.md. Respeitando as regras de nomeação de arquivo definidas em capítulo oportuno.

	2. Uma `EAP` detalhada, indicando claramente os pacotes de trabalho e seus entregáveis, o tempo estimado para tarefa e o número de créditos estimado para a realização do pacote de trabalho pela plataforma. Este documento não substitui outros artefatos de gerencia de projetos (desejáveis), que serão  conferidos, antes de autorizar a execução da `Fase 2`; 

- **Fase 2**: Executada somente após analise e aprovação da `Fase 1` com objetivo de construir o sistema proposto na `Fase 1`, conforme pré-requisitos definidos aqui.

## Definições para Fase 2

### Definições:

##### `ESTRATEGIA`
É uma classe abstrata, cujas as implementações servem de filtro e para e calculo do ranking das `APOSTAS CANDIDATAS` submetidas para avaliação dela. A classe abstrata tem como membros:

	public abstract class {
		String name;
		String description;
		String uniqueTagId;
		float rank_true  = 100.0;
		float rank_false = -10.00;
		int dez_filter_min = 3;
		int dez_filter_max = 3;
		  
	}


### Aspectos relativos à implementação do sistema

1. O banco de dados deve ser no formato SQLite 3, cuja  cópia extraída e compactada de [https://megapower-loterias.com.br/](https://github.com/nosredna33/DesafioIAs/blob/main/MegaPower.zip) encontra-se aqui para download e também em formatos SQL:
		- DDL: [Script de Criação do banco](https://github.com/nosredna33/DesafioIAs/blob/main/exportacao.sql)
		- DML: [Dados atualizados até o Concurso `2877` de `17/06/2025`()
		- O documento detalhamento da [Especificação do banco de dados](https://github.com/nosredna33/DesafioIAs/blob/main/Documentacao_Banco.md) encontra-se aqui.
  
2. O sistema (1 ou mais programas), escritos **TODOS**  em linguagem em Java, para gerar sugestões de jogos, cujo comportamento, em tempo de execução, seja controlado tanto por  parâmetros, na linha de comandos, no formato POSIX, quanto por arquivo de configuração no formato `.properties` do Java. 

3. O programa deverá exibir as mensagens usando data, hora, valores, com NLS compatível com a do ambiente operacional, ou Português Brasil, caso seja impossível detectar automaticamente a NLS do sistema hospedeiro.

4. As apostas sugeridas para o próximo concurso da **Mega-Sena*" deverão ser calculadas baseados nas estatísticas dos sorteios disponíveis no site especilizado [*_Mega Power- Loterias_*](https://megapower-loterias.com.br/app/index.php),ou calculadas com base em todos os dados da tabela fornecida e, não somente sobre amostras.

5. As apostas sugeridas, no final, serão rankeadas da maior para a menor no ranking, conforme a soma da pontuação alcançada da soma obtidas de todas as `ESTRATÉGIAS`, para as quais as apostas forem submetidas para à avaliação.

6. As `ESTRATÉGIAS` deverão ser implementadas com base numa classe abstrata ou de uma interface.

7. Cada `APOSTA GERADA` é submetida à `CADEIA DE ESTRATÉGIAS`, cujo o ranking final  da `APOSTA GERADA` é soma dos resultados de todas as `ESTRATÉGIAS` aplicada sobre a `APOSTA GERADA` da `CADEIA DE ESTRATÉGIAS`. 

8. As `APOSTAS GERADAS` poderão ser de uma das três formas a seguir, definidas em parâmetro na linha de comandos próprios, ou por arquivo de configuração na execução do programa.
		8.1. **Apostas geradas aleatoriamente** - Obtidas baseado na escolha aleatória, pelo índice lexicográfico entre 1 e as 50.063.860 combinações possíveis, onde o índice 1 representa a aposta `[01 - 02 - 03 - 04 - 05 - 06]` e de índice 50.063.860 representa a aposta `[55 - 56 - 57 - 58 - 59 - 60]`.
		
		8.2 **Todas as Combinações possíveis** - Informado em parâmetro próprio na chamada do programa, indicando que todas as combinações serão avaliadas (submetidas à `CADEIA DE ESTRATÉGIAS`, isto é da `[01 - 02 - 03 - 04 - 05 - 06]` à `[55 - 56 - 57 - 58 - 59 - 60]`).
		
		8.3. **Lista de `APOSTAS CANDIDATAS`** - Informado em parâmetro próprio na chamada do programa, que indica que as  `APOSTAS CANDIDATAS` deverão ser lidas de um arquivo TXT, em formato UTF-8, com numa aposta de 6 dezenas, por linha, no formato: `03 05 07 11 13 17` ou `23-31-47-53-57-60`, devendo cada sugestão de aposta ter as suas dezenas separadas por branco ou hífen e fim de linha indicado apenas com o caráter \n.

9. Este programa deverá ser Multithread e usar pool de conexões com o SQLITE 3, para evitar gargalos entre as threads durante as persistências transitórias das `APOSTAS CANDIDATAS` .
 
10. Como ainda não existe exposta a API para consulta ao SGBD  no Site [Mega Power Loterias](https://megapower-loterias.com.br/), Uma amostra, permanentemente atualizada do banco de dados, ficará disponível no GitHub deste projeto, em formato binário do banco SQLITE 3, e também formato SQL DDL e DML, cujas referencias estão nos links desta documentação, contendo as principais estatísticas aplicadas por ETL sobre a tabela `CONCURSOS`, o que deverá simplificar o trabalho dos geradores de código do sistema, evitando gerar código para obter estatísticas para utilização nas `ESTRATÉGIAS`.

11. Este banco de dados contém todas as informações granulares e agregadas sobre todos os sorteios já realizados, desde o primeiro sorteio da `Mega-Sena` até o concurso `2877` de `17/06/2025`:
	- **DEZ_OCORRENCIAS** : Contem informação desnormalizadas, por `ETL` e de forma granular  sobre todas as ocorrência de cada dezena já sorteada, desde o primeiro SORTEIO;

	- **AGREG_DIS_DEZ_POSICAO** : Mantém uma linha para cada dezena exibindo a quantidade de ocorrências da dezena, por posição no SORTEIO;

	- Além destas citadas sugiro  documentar todas as demais tabelas e views, como parte da documentação gerada ao final!

12. Algumas estatísticas já estão prontas, o que não impede que novas sejam criadas para análises sugeridas, desde que o código  fonte faça parte do sistema e os dados decorrentes delas estejam na MEGAPOWER.DB resultante.

13. A abordagem inicial e simplista, sobre as ESTRATÉGIAS não impede a criação de estratégias mais sofisticada em Java que incluem:
    
     - **Ranking gaussiano** das apostas baseado em múltiplos critérios.
       
     - **Análise de transição de estados** usando a tabela EST_MUD_ESTADO
       
     - **Probabilidades condicionais** por posição baseadas no histórico de ocorrências.
       
     - **Sistema de scoring mais robusto** com pesos estatísticos, e
       
     - **Outras que Julgar interessantes**

14. Com base no resultado  do último sorteio analisar o desempenho das nossas sugestões de apostas, mantidas no banco de dados, na tabela **FAT_APOSTAS**, persistidas juntamente com a data da aposta, a data do sorteio, o concurso, a soma do ranking de estratégias, e a comparação do ranking do resultado real do último concurso.

15. **Parâmetros POSIX** - Siga este exemplo de documentação dos parâmetros da linha de comandos para o formato POSIX:
    
| Parâmetro | Descrição | Valores Aceitos | Obrigatório | 
|-----------|-----------|-----------------|-------------| 
| -n | Número de apostas filtradas do resultado gerado | Inteiro > 0 | Sim* | 
| -m | Modo de geração | RANDOM, FILE, FULL | Sim | 
| -t | Número de threads | Inteiro > 0 | Não | 
| -d | Caminho do banco SQLite | Caminho válido | Não | 
| -v | Nível de verbosidade | 0-3 | Não |
| ... | ... | ... | ... |

\*Obrigatório exceto no modo FULL

16. Preservar a estrutura do banco de dados, sugerindo alterações para serem aplicadas durante o processo de instalação da aplicação nova, em arquivo DDL separado, compatível com SQLite 3;

17. As consultas devem ser sem uso de `select *`, ou sem uso clausulas `where`, e paginação dos valores para evitar grande movimentação de dados desnecessárias;

18. A aplicação deverá no host do usuário interessado em testar a aplicação, rodando com Java 19+. 

19. Toda a documentação disponível está entregue ou disponível nos links deste documento para análise;

20. Não haverá migração do Banco de dados. no banco de dados existente.

21. Tudo deverá rodar empacotado num `.JAR` no host do usuário contendo a JVM especificada no `item 18`, A aplicação deverá ser criada num único `.JAR`, no modo `Fat Jar`, contendo todas as dependências diretas e indiretas dentro de único  `.JAR` da aplicação.

22. O estilo de codificação, comentários e nomeação de métodos, classe, funções, variáveis, identação devem usar as melhores práticas de codificação, sem TABS! Todos os espaçamentos devem ser TAB, com 3 espaços. Todo arquivo de codificação deve ter final de linha com \n, e em formato UTF-8;
 
23. A codificação deverá seguir as melhores práticas de codificação, identação, nomenclatura de classes, variáveis, constantes, métodos, procedimentos, queries, funções, estilo de código e comentários.

24. Não serão admitidos comentários com PLACE HOLDERS para códigos do tipo: // Inclua isso ou aquilo aqui, # Cole aqui configuração X, ou -- Clausula where. Códigos contendo esta prática serão descartados e os créditos para gerar o pacote de serão glosados...

25. Todos os arquivos, sejam eles de `documentação` ou de `código-fonte`, ao serem alterados para novas atualizações e versões, deverão seguir a seguinte regra de formação de nomes na forma `<nome-do-arquivo>_V00n.<extensão>` onde _**_V00n**_ é o identificador da ultima versão renomeada, antes de alterar o arquivo original. Medida para simplificar a subida no GitHub, mantendo o histórico de atualização. `NÃO INVENTEM NOMES` para versões distintas do mesmo arquivo.

26. Arquivos de documentação devem ter, logo na página seguinte a página de rosto, uma tabela contendo:
	
| Data               | Versão  | O que foi trocado | porque foi mudado                |
| ---                | ---     | ---               | ---                              |
| ano-mês-Dia HH24:MI| x.y.z.w | Poucas palavras   | descrição das razões da mudançca |
| ....               | ....    | .....             | ....                             |


26. Arquivos de código-fonte devem manter um bloco de comentário, seguindo a notação `Markdown` seguindo a mesma tabela de histórico de atualização.
	


