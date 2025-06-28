
# Histórico de Versões
| versão |  Data      | O que mudou                                           | 
| ------ | ---------- | ----------------------------------------------------- |  
| 1.0    | 11/05/2025 | Criação                                               |
| 1.5    | 01/06/2025 | Atualizado em respostas aos questionamentos das IAs   |
| 1.52   | 20/06/2025 | Mais ajustes para atender aos questionamentos das IAs |
| 2.00   | 21/06/2025 | Ajustes finais.                                       |
| 2.50   | 22/06/2025 | Mais ajustes sugeridos pelas IAs.                     |
| 2.75   | 27/06/2025 | Melhorias sugeridas pelas IAs.                        |
| 2.90   | 28/06/2025 | Continuação das melhorias sugeridas pelas IAs.        |

### Para Fazer:


# O Prompt 
Trata-se de um exemplo de padrão de solicitação de tarefas às IAs, com objetivo de promover um Benchmark entre elas, e diante disso, podermos avaliar qual delas é a melhor para apoiar no Desenvolvimento de Software. 

Vários aspectos serão avaliados em relação as entregas de cada IA.

# Objetivo
Gerar uma aplicação com base em dados públicos, mantidos no Site [Mega Power - Loterias](https://megapower-loterias.com.br), cujo o propósito da aplicação `MegaPowerX` será gerar apostas postas massivas para a sorteios futuros da `Mega-Sena`. 

Este desafio consistem em duas etapas muito bem definidas:

## **Fase 1**

Criar toda a documentação do projeto incluindo uma especificação completa do sistema e não a geração de códigos-fontes, ou  arquivos de configurações, ou outros artefatos do projeto necessários à criação de do sistema. O sistema deve ser escrito em Java 19+, para projeto de natureza Maven, capaz de gerar e avaliar sugestões de jogos para sorteios da `Mega-Sena`, com uso de recursos de paralelização e persistência dos dados para análise futura em banco de dados SQLite 3, fazendo uso de pool de conexão para evitar contensões entre as threads, configuração via linha de comando, unsando padrão POSIX e arquivo .properties, e deverá gerar apostas rankeadas conforme as várias estratégias usadas, gerando ums saida em formato CSV, em formato UTF-8, com separador de linha usando apenas \n.

O sistema se baseará em `ESTRATÉGIAS ESTATÍSTICAS` e em `ESTRATÉGIAS DINÂMICAS`, aquelas baseadas em dados do banco de dados do Site [Mega Power - Loterias](https://megapower-loterias.com.br), dará suporte a geração e avaliação das apostas de forma massiva, obedecendo os seguintes requisitos:

	1. O documento da especificação, deve ser gerado, sem gerar arquivos intermediários não solicitados, com o nome Especificacao.md. Respeitando as regras de nomeação de arquivo definidas em capítulo oportuno.

	2. Uma `EAP` detalhada, indicando claramente os pacotes de trabalho e seus entregáveis, o tempo estimado para tarefa e o número de créditos estimado para a realização do pacote de trabalho pela plataforma. Este documento não substitui outros artefatos de gerencia de projetos (desejáveis), que serão  conferidos, antes de autorizar a execução da `Fase 2`; 

## **Fase 2**

Executada somente após analise e aprovação da `Fase 1` e tem por objetivo construir o sistema proposto na `Fase 1`, conforme pré-requisitos definidos aqui.

### Definições:

##### `ESTRATÉGIA`
O conceito de `ESTRATEGIA` nesse sistema é um componente do software que avalia `APOSTAS CANDIDATAS` e soma o ranking (positivo ou negativo), se os calculas sobre a aposta entiverentrem entre os valores minimos e máximos, que, juntamente com os valores dos ranking (positivo ou negativo) serão passados como parâmetros na construção da classe. 

Cada implementação de `ESTRATEGIA` terá seus próprios critérios implementados para gerar o `Valor de Referencia`, normalmente calculado / criado / arbitrado, na chamada do método init(), assim que o objeto for criado e antes de chamar pela primeira vez o método `process ( ApostaCandidata aposta)`. Em cada iteração de `estrategiaX.process ( ApostaCandidata aposta)`, se o `Valor de Referencia` >= `VALOR MÍNIMO` e `VALOR DE REFERENCIA` <= `VALOR MÁXIMO`, o `VALOR SE VERDADE` é somado ao ranking da `ApostaCandidata` sendo avaliada. E, se a condição de avaliação for falsa, é somado ao ranking da `ApostaCandidata` o valor `VALOR SE FALSO`. Tanto os parametros `VALOR SE VERDADE`, quanto `VALOR SE FALSO` são definidos na instanciação da classe, como valor mínimos e máximos aceitáveis para os cálculos. Mais dois outros parâmetros, usados na instanciação da classe, indicam o número mínimo e máximo de dezenas em que a verdade, ou não, se aplica, conforme o exemplo:

```Java
	package br.com.megapowerx.filtros;
	
	import br.com.megapowerx.ApostaCandidata;
	import br.com.megapowerx.Estrategia;
	import java.util.List;
	
	/**
	* Filtra dezenas que estão nas bordas ou no centro da cartela.
	* Consideradas como bordas as dezenas:
	* 1 a 10, 11, 21, 31, 41, 20, 30, 40, 50, 51 a 60.
	*/
	public class FiltraBordasCentro extends Estrategia {
	
		private static final String NAME = "Filtro Bordas e Centro";
		private static final String DESCRIPTION = "Filtra p/ dezenas na bordas :1–10,11,21,31,41,20,30,40,50,51–60.";
		private static final String TAG_ID = "FiltroBordasCentro";
		
		// Constantes para cálculos usadas no init()
		private static final double QTD_BORDAS = 20.0;
		private static final double MIN_BORDA = 1.0;
		private static final double MEDIA_BORDAS = 20.5;
		private static final double MAX_BORDA = 60.0;
		private static final double DESVIO_PADRAO = 16.0;
		
		public FiltraBordasCentro() {
			super();
			setNAME (NAME);
			setDESCRIPTION (DESCRIPTION);
			setTAG_ID (TAG_ID);
		}
	
		public FiltraBordasCentro(float addRankIfTrue, float addRankIfFalse, Double minLimit, Double maxLimit) {
			super(addRankIfTrue, addRankIfFalse, minLimit, maxLimit);
			setNAME (NAME);
			setDESCRIPTION (DESCRIPTION);
			setTAG_ID (TAG_ID);
		}
	
		@Override
		protected void init() {
			this.calcQtd  = QTD_BORDAS;       // Qtd de números nas bordas
			this.calcMin  = MIN_BORDA;        // O Menor número nas bordas
			this.calcAvg  = MEDIA_BORDAS;     // A média dos números nas bordas
			this.calcMax  = MAX_BORDA;        // O Maior número nas bordas
			this.calcStdV = DESVIO_PADRAO;    // O Desvio Padrão Médio dos números nas bordas
		}
		
		private boolean isBorda(int dezena) {
			if (dezena >= 1 && dezena <= 10) return true;
			if (dezena >= 51 && dezena <= 60) return true;
			return dezena == 11 || dezena == 21 || dezena == 31 || dezena == 41
				|| dezena == 20 || dezena == 30 || dezena == 40 || dezena == 50;
		}
	
		@Override
		public void process(ApostaCandidata aposta) {
			List<Integer> dezenas = aposta.parseDezenas();
			// Um jeito
			long ValorComparacaoCountBorda = dezenas.stream().filter(this::isBorda).count();
			aposta.addRanking(isDentroDosLimites(ValorComparacaoCountBorda) ? addRankIfTrue : addRankIfFalse);
		}
	}
	
	...
	FiltraBordasCentro X = new FiltraBordasCentro( 100.00, -80.00, 2, 3);
	X.ini();
	ApostaCandidata apostaCand1 = new ApostaCandidata("05 13 27 33 45 59");
	X.process (apostaCand1);
	System.out.println(apostaCand1);
	// Provável saida: {"aposta": "05 13 27 33 45 59", "ranking": -80.0}

	// Gera aposta aleatória
	ApostaCandidata apostaCand2 = new ApostaCandidata();
	X.process (apostaCand2);
	System.out.println(apostaCand1);
	// Provável saida: {"aposta": "01 17 30 53 55 60", "ranking": 100.0}
	...
	
```

Cada vez que uma `APOSTAS CANDIDATAS` vai sendo avaliada, por uma estratégia, ou um filtro, da `CADEIA DE ESTRATÉGIAS`, seu ranking vai acumulando, para baixo ou para cima, dependendo da condição que ocorrer em `X.process ( ApostaCandidata aposta)`, podendo eliminar a aposta da escolha entre aquelas do topo do Ranking entre.

##### `VALOR DE REFERENCIA`

Valor calculado, normalmente pelo método `init()`, antes processamento das `APOSTAS CANDIDATAS` que pode ser obtido fazendo consultas ao banco de dados, fazendo cálculos estatísticos, cálculos exotéricos, consultas às APIs na internet, usar o Google, IAs, rodar scripts, sortear números aleatórios usando o Randon forte do SSL e até usar bruxaria digital, para se chegar a um valor de ponto flutuante chamado de `VALOR DE REFERENCIA`.

##### `VALOR DE COMPARAÇÃO`

Valor calculado, normalmente pelo método`.process ( ApostaCandidata aposta)` com base na `APOSTAS CANDIDATAS` que pode ser obtido fazendo consultas ao banco de dados, fazendo cálculos estatísticos, cálculos exotéricos, consultas às APIs na internet, usar o Google, IAs, rodar scripts, sortear números aleatórios usando o Randon forte do SSL e até usar bruxaria digital, para se chegar a um valor de ponto flutuante chamado de `VALOR DE COMPARAÇÃO`.

##### `CADEIA DE ESTRATÉGIAS`
A `CADEIA DE ESTRATÉGIAS` é uma estrutura de dados thread-safe, isto é, deve ser acessada com o mínimo de contenção a outras threads, pelo sistema, para executar as respectivas tarefas definidas em `process ( ApostaCandidata aposta)`. Pensem sempre numa solução para aplicação com o mínimo de regiões críticas, para evitar gargalos da aplicação, ou disputas dead-lock. 

###### `APOSTA GERADA`
A `APOSTA GERADA` é uma , `APOSTAS CANDIDATA`, é criada por algum mecanismo (`aleatório`, `lista`, `full`). As do tipo `lista`, são criada por qualquer mecanismo fora do sistema em uma arquivo TXT, contendo uma aposta por linha, separadas por \n, em arquivos de formato UTF-8, podendo ser a sua geração aleatória, por dicas de amigos, sonhos, frases bíblicas, cálculos com base no seu biorritmo, com base em fotos da NASA, observação de estatísticas de anteriores jogos e até física quântica, geradas no Site [Mega Power - Loterias](https://megapower-loterias.com.br) . Que estão mantidas em um arquivo contendo uma ou mais `APOSTAS CANDIDATAS`  conforme, como um elemento da `LISTA DE APOSTAS CANDIDATAS`.

	Vide: `APOSTAS CANDIDATAS`
	
##### `LISTA DE APOSTAS CANDIDATAS`
É uma coleção de `APOSTAS CANDIDATAS` a serem avaliadas.

	Vide: `APOSTAS CANDIDATAS`, `APOSTA GERADA`

##### `APOSTAS CANDIDATAS`
São textos contendo 6 dezenas de 01 à 60, separados por branco ou rifem, que representam uma intenção de aposta para jogo da `Mega-Sena`. O texto deve estar em conjunto de caracteres no formato UTF-8, contendo 6 dezenas, no formato NN NN NN NN NN NN ou NN-NN-NN-NN-NN-NN, por exemplo:`03 05 07 11 13 17` ou `23-31-47-53-57-60`, devendo cada dezena sempre duas casas, com zero a esquerda para números menores que 10, tendo as dezenas separadas por branco ou hífen e fim e sem o fim de linha \n, mantidos no arquivo de sua persistência. Vide `item 8` deste documento.

Ranking da Aposta: soma dos rankings dados por todas as estratégias.

### Aspectos relativos à implementação do sistema

#### Anexos que devem ser considerados
1. Todos estes anexos precisam ser lidos e avaliados para calculo das estimativas de tempo da `Fase 1` e para as implementações na `Fase 2`:
		1.0 O banco de dados deve ser no formato SQLite 3, cuja  cópia extraída e compactada encontra-se em:[https://megapower-loterias.com.br/](https://github.com/nosredna33/DesafioIAs/blob/main/MegaPower.zip) para download e também em formato SQL:
		1.1. DDL: [Script de Criação do banco](https://github.com/nosredna33/DesafioIAs/blob/main/exportacao.sql)
		1.2. DML: [Dados atualizados até o Concurso `2877` de `17/06/2025`(https://github.com/nosredna33/DesafioIAs/blob/main/exportacao_dados.sql)
		1.3. O documento detalhamento da [Especificação do banco de dados](https://github.com/nosredna33/DesafioIAs/blob/main/Documentacao_Banco.md) encontra-se aqui.
		1.4. Esqueleto do projeto Java que define os objetos raízes do sistema, que devem ser respeitados fielmente na implementação do sistema, podendo sofrer modificações necessárias somente nas implementações das classes derivadas, desde que não afetam a arquitetura do aqui proposta. O pacote `megapowerx-estrategias.zip` encontra-se nesse [Link](https://github.com/nosredna33/DesafioIAs/blob/main/megapowerx-estrategias.zip), para ser usado e avaliado na construção do sistema ao final da `Fase 2`.

#### Considerações complementares

2. O sistema (1 ou mais programas), escritos **TODOS**  em linguagem em Java, para gerar sugestões de jogos, cujo comportamento, em tempo de execução, seja controlado tanto por  parâmetros, na linha de comandos, no formato POSIX, quanto por arquivo de configuração no formato `.properties` do Java. 

3. O programa deverá exibir as mensagens usando data, hora, valores, com NLS compatível com a do ambiente operacional, ou Português Brasil, caso seja impossível detectar automaticamente a NLS do sistema hospedeiro.

4. As apostas sugeridas para o próximo concurso da **Mega-Sena** deverão ser calculadas baseados nas estatísticas dos sorteios disponíveis no site especilizado [*_Mega Power - Loterias_*](https://megapower-loterias.com.br/app/index.php),ou calculadas com base em todos os dados da tabela fornecida e, não somente sobre amostras.

5. As apostas sugeridas, no final, serão rankeadas da maior para a menor no ranking, conforme a soma da pontuação alcançada da soma obtidas de todas as `ESTRATÉGIAS`, para as quais as apostas forem submetidas para à avaliação.

6. As `ESTRATÉGIAS` deverão ser implementadas com base numa classe abstrata ou de uma interface.

7. Cada `APOSTA GERADA` é submetida à `CADEIA DE ESTRATÉGIAS`, cujo o ranking final  da `APOSTA GERADA` é soma dos resultados de todas as `ESTRATÉGIAS` aplicada sobre a `APOSTA GERADA` da `CADEIA DE ESTRATÉGIAS`. 

8. As `APOSTAS GERADAS` poderão ser de uma das três formas a seguir, definidas em parâmetro na linha de comandos próprios, ou por arquivo de configuração na execução do programa.
		8.1. **`RANDOM`** - Obtidas baseado na escolha aleatória, pelo índice lexicográfico entre 1 e as 50.063.860 combinações possíveis, onde o índice 1 representa a aposta `[01 - 02 - 03 - 04 - 05 - 06]` e de índice 50.063.860 representa a aposta `[55 - 56 - 57 - 58 - 59 - 60]`.
		
		8.2 **`FULL`** - Informado em parâmetro próprio na chamada do programa, indicando que todas as combinações serão avaliadas (submetidas à `CADEIA DE ESTRATÉGIAS`, isto é da `[01 - 02 - 03 - 04 - 05 - 06]` à `[55 - 56 - 57 - 58 - 59 - 60]`).
		
		8.3. **`FILE`** - Informado em parâmetro próprio na chamada do programa, que indica que as  `APOSTAS CANDIDATAS` deverão ser lidas de um arquivo TXT, em formato UTF-8, com numa aposta de 6 dezenas, por linha, no formato: `03 05 07 11 13 17` ou `23-31-47-53-57-60`, devendo cada sugestão de aposta ter as suas dezenas separadas por branco ou hífen e fim de linha indicado apenas com o caráter \n.

9. Este programa deverá ser Multithread e usar pool de conexões com o SQLITE 3, para evitar gargalos entre as threads durante as persistências transitórias das `APOSTAS CANDIDATAS` .
 
10. Como ainda não existe exposta a API para consulta ao SGBD  no Site [Mega Power Loterias](https://megapower-loterias.com.br/), Uma amostra, permanentemente atualizada do banco de dados, ficará disponível no GitHub deste projeto, em formato binário do banco SQLITE 3, e também formato SQL DDL e DML, cujas referencias estão nos links desta documentação, contendo as principais estatísticas aplicadas por ETL sobre a tabela `CONCURSOS`, o que deverá simplificar o trabalho dos geradores de código do sistema, evitando gerar código para obter estatísticas para utilização nas `ESTRATÉGIAS`.

11. Este banco de dados contém todas as informações granulares e agregadas sobre todos os sorteios já realizados, desde o primeiro sorteio da `Mega-Sena` até o concurso `2877` de `17/06/2025`:
	11.1.  Deve-se documentar todas as tabelas e views, como parte da documentação gerada ao final!

12. Algumas estatísticas já estão prontas, o que não impede que novas sejam criadas para análises sugeridas, desde que o código  fonte faça parte do sistema e os dados decorrentes delas estejam na MEGAPOWER.DB resultante.

13. A abordagem inicial e simplista, já implementada e que deve ser mantida, sobre as `ESTRATÉGIAS` não impede a criação de estratégias mais sofisticadas pelas IAs, que podem , por exemplo incluir:
    
     - **Ranking gaussiano** - das apostas baseado em múltiplos critérios.
       
     - **Análise de transição de estados** - usando a tabela EST_MUD_ESTADO
       
     - **Probabilidades condicionais** - por posição baseadas no histórico de ocorrências.
       
     - **Sistema de scoring mais robusto** - com pesos estatísticos, e
       
     - **Outras** - Outras que Julgar interessantes

14. Para avaliar o desempenho das últimas sugestões para apostas, além do arquivo mantidas no banco de dados, na tabela **FAT_APOSTAS**, persistidas juntamente com a data da aposta, a data do sorteio, o concurso, a soma do ranking de estratégias, e a comparação do ranking do resultado real do último concurso.

15. **Parâmetros POSIX** - Siga este exemplo de documentação dos parâmetros da linha de comandos para o formato POSIX:
    
| Parâmetro | Descrição                                    | Valores Aceitos            | Obrigatório | 
|-----------|----------------------------------------------|----------------------------|-------------| 
| -c        | Caminho arquivo de configuracao^9^           | Caminho válido             | Não         | 
| -d        | Caminho do banco SQLite                      | Caminho válido             | Não         | 
| -e        | Número de linhas^1^ lidas/geradas na entrada | k:r Inteiros > 0 e r > k   | Não         | 
| -i        | Caminho do apostas.txt^2^ leitura            | Adiciona ao arquivo        | Não         | 
| -l        | Caminho do megapowerx.log^5^ logs            | Adiciona ao arquivo        | Não         | 
| -m        | Modo de geração                              | RANDOM, FILE, FULL         | Sim         | 
| -n        | Número de apostas filtradas ao final         | Inteiro > 0                | Sim^3^      | 
| -o        | Caminho do resultados.txt^4^ resultados      | Adiciona ao arquivo        | Não         | 
| -t        | Número de threads                            | Inteiro > 0                | Não         | 
| -v        | Nível de verbosidade                         | SILENCE, DEBUG, WARN, ERRO | Não         |
| -x        | Lista Dezenas excluídas^6^                   | 06,22,47,51,               | Não         |
| -y        | Lista Dezenas fixas^7^                       | 03,13,24                   | Não         |
| -z        | Arquivo de regras.json^8^                    | Caminho do arquivo         | Não         |
| ...       | parametros adicionais                        | ...                        | ...         |

^1^ - Se o -e não for informado o valor dele será igual a 10 x o valor -n. -e 13, serão gerados ou lidos apenas 13 linhas do arquivo de apostas ou gerados aleatoriamente apenas 13 apostas candidatas. Se a notação for -e k:r, serão lidas as linhas da posição k à posição r, se -m FILE. E para o modo FULL (-m FULL), serão escolhidos as combinações da posição lexicográfica de k à r. Em todas as demais somente k será considerado.
^2^ - Se o `apostas.txt` não existir, ou for inpossível ler, gera-se as `Apostas Candidatas` em modo RANDOM.
^3^ - Sempre obrigatório independentemente do modo.
^4^ - Se o `resultados.txt` já existir adiciona-se linhas ao final do arquivo. Se o parametro não for informado o resultado será jogado na saída padrão STDOUT.
^5^ - Se o `megapowerx.log` já existir adiciona-se linhas ao final do arquivo. Se o parametro não for informado o resultado será jogado na saída padrão de erros STDERR.
^6^ - Se as `Apostas Candidatas` tiverem qualquer uma destas dezenas da lista, elas serão excluídas. Isto é, será adcionado ao ranking delas -100,00, para cada dezena excluída encontrada.
^7^ - Se -y estiver prezente, as dezenas geradas, serão sempre incluídas quando a opção de entrada -m for RANDOM. Isto é, as `Apostas Candidatas` terão adcionadas ao ranking delas 100,00 para cada dezena da lista encontrada na aposta.
^8^ - Se presente não carrega todas as regras contidas no .JAR do executável ou do .JAR de extenções. Carregará somente as regrs listadas no arquivo em formato .json, instanciando os objetos conforme os parametros definidos no .json, sem caracteres TAB, em formato UTF-8, com \n indicando fim de linha.
^9^ - Aruivo do tipo .properties do Java que, se informado, deverá ler de lá os parametros não informados na linha de comandos e ter ao final da execução do SIstema seus valores atualizados com os ultimos parametros informados e data e a hora, minuto e segundo da útima execução, representada na forma YYYY-MM-DDTHH:MI:SS.

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
