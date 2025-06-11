
Objetivo
Escreva uma aplicação completa, incluindo dependencias JAR, incluídas todas num FATJAR, juntamente com a aplicação, incluindo os códigos fontes e outros artefatos do projeto, para a criação de um programa em Java,  usando o Eclipse, que seja capaz de gerar sugestões de jogos para sorteios da Mega-Sena, com base em ESTRATÉGIAS ESTATÍSTICAS, com suporte a geração massiva de apostas, paralelização e persistência dos dados para análise futura.

Executar a tarefa somente após analisar os arquivos:

O banco de dados SQLite 3, mantido na URL https://megapower-loterias.com.br/dados/MegaPower.db e,
O documento de Especificação do banco de dados.
o Documento da especificação, deve ser gerado, sem gerar arquivos intermediários não solicitados, com o nome Especificacao.md, gerando para novas atualizações o nome Especificacao_V00n conforme esta declaração de escopo:

Um sistema (1 ou mais programas), escrito em linguagem em Java, que seja capaz de gerar sugestões de jogos, cujo o número de apostas geradas seja informado como parâmetros, na linha de comandos, na forma POSIX.

O programa deverá exibir as mensagens usando data, hora e valores, com NLS compatível com a do ambiente operacional, ou Português Brasil, caso seja impossível detectar automaticamente a NLS do sistema hospedeiro.

As apostas sugeridas para o próximo concurso da *Mega-Sena" deverão ser calculadas baseados nas estatísticas dos sorteios disponíveis no site especializado Mega Power- Loterias,ou calculadas com base em todos os dados da tabela fornecida e, não somente sobre amostras.

As apostas sugeridas, no final, serão rankiadas da maior para a menor no ranking, conforme a soma da pontuação alcançada pa soma obtidas de todas as ESTRATÉGIAS, para as quais as apostas forem submetidas para à avaliação.

As ESTRATÉGIAS são implementações de uma classe, baseada numa classe abstrata ou de uma interface.

Cada APOSTA GERADA é submetida à cadeia de estrategias, cujo o resultado é soma dos resultados de cada ESTRATÉGIA aplicada sobre a APOSTA GERADA. poderá ser de uma das quatro formas:

6.1. Informado em parâmetro POSIX, na chamada do programa com o número de apostas geradas aleatoriamente.

6.2. Informado em parâmetro POSIX, na chamada do programa, com o número de APOSTAS OBTIDAS baseado na escolha aleatória, pelo índice lexicográfico entre 1 e as 50.063.860 combinações possíveis, onde o indice 1 representa a aposta [01 - 02 - 03 - 04 - 05 - 06] e de indice 50.063.860 representa a aposta [55 - 56 - 57 - 58 - 59 - 60].

6.3. Informado em parâmetro POSIX, na chamada do programa, que indica que todas as combinações serão avaliadas (submetidas à CADEIA DE ESTRATÉGIAS de [01 - 02 - 03 - 04 - 05 - 06] à [55 - 56 - 57 - 58 - 59 - 60]), destacando as N de maior ranking informada no parâmetro de linha de comandos próprio para isso.

6.4. Informado em parâmetro POSIX, na chamada do programa, que indica que as APOSTAS CANDIDATAS deverão ser kidas de um arquivo TXT, em formato UTF-8, com numa aposta por linha, tendo as dezenas separadas por branco ou hífen e fim de linha apenas com \n.

Este programa deverá ser Multithread e usar pool de conexões com o SQLITE 3, para evitar gargalos entre as threads durante as persistências transitórias das APOSTAS CANDIDATAS

Como ainda não existe exposta a API para consulta ao SGBD no Site Mega Power Loterias, Uma amostra, permanentemente atualizada do banco de dados, ficará disponível no site, em formato SQLITE 3, com as principais estatísticas em tabelas e views, que deverá simplificar o trabalho de quem for gerar o sistema, ao invés de tentar obter os mesmos dados fazendo um parse nos textos html do site. O banco de dados, em formato SQLITE 3, está em https://megapower-loterias.com.br/dados/MegaPower.db.

Este banco de dados contém todas as informações granulares e agregadas sobre todos os sorteios já realizados, desde o primeiro sorteio da Mega-Sena:

DEZ_OCORRENCIAS : Contem informação granulares sobre todas as ocorrência de cada dezena já sorteada, desde o primeiro SORTEIO;

AGREG_DIS_DEZ_POSICAO : Mantém uma linha para cada dezena exibindo a quantidade de ocorrências da dezena, por posição no SORTEIO;

Além destas citadas sugiro documentar todas as demais tabelas e views, como parte da documentação gerada ao final!

Algumas estatísticas já estão prontas, o que não impede que novas sejam criadas para análises sugeridas, desde que o código fonte faça parte do sistema e os dados decorrentes delas estejam na MEGAPOWER.DB resultante.

A abordagem inicial e simplista, sobre as ESTRATÉGIAS não impede a criação de estratégias mais sofisticada em Java que incluem:

Ranking gaussiano das apostas baseado em múltiplos critérios.

Análise de transição de estados usando a tabela EST_MUD_ESTADO

Probabilidades condicionais por posição baseadas no histórico de ocorrências.

Sistema de scoring mais robusto com pesos estatísticos, e

Outras que Julgar interessantes

Com base no resultado do último sorteio analisar o desempenho das nossas sugestões de apostas, mantidas no banco de dados, na tabela FAT_APOSTAS, persistidas juntamente com a data da aposta, a data do sorteio, o concurso, a soma do ranking de estratégias, e a comparação do ranking do resultado real do último concurso.

Parâmetros POSIX Siga este exemplo de documentação dos parâmetros da linha de comandos para o formato POSIX:

Parâmetro	Descrição	Valores Aceitos	Obrigatório
-n	Número de apostas a gerar	Inteiro > 0	Sim*
-m	Modo de geração	RANDOM, LEXICO, FULL	Sim
-t	Número de threads	Inteiro > 0	Não
-d	Caminho do banco SQLite	Caminho válido	Não
-v	Nível de verbosidade	0-3	Não
*Obrigatório exceto no modo FULL			
Como requisitos essenciais da aplicação fazem necessários:
Pool de Conexões: Uso do Apache Commons DBCP para gerenciar conexões, evitando "host busy" com limite de conexões ativas; Timeout configurável (5 segundos);
Paralelização: Cálculos estatísticos distribuídos em múltiplos núcleos;
Streams paralelos para processamento eficiente;
ExecutorService para gerenciamento de threads;
Sistema de Retry: Tentativas automáticas para falhas temporárias;
Backoff exponencial: entre tentativas;
Failover: após 3 tentativas;
Cache Inteligente: Armazenamento local de scores calculados; Validade de 1 minuto para atualizações;
Gerenciamento de Recursos: Fechamento adequado de conexões e threads; AwaitTermination para desligamento gracioso;
Tratamento robusto de exceções.
