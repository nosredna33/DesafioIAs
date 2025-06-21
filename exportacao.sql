CREATE TABLE DUAL
-- Tabela..: DUAL
--
-- Status..: OK 
-- Objetivo: Tabela especial usada pra forçar a seleção de uma única
--           linha em joins.
--
-- Detalhes:
--
(
    COLX CHAR(1)  
    -- Coluna especial usada pra forçar a seleção de uma única coluna.
);
CREATE TABLE ETL0_CARGAS
-- Tabela..: ETL0_CARGAS
--
-- Status..: OK 
-- Objetivo: Mantém informações sobre o processo de carga no
--           banco de dados durante o processo de ETL.
--
-- Detalhes: 
--
(
   CO_CARGA           INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
   -- Código sequencial que identifica únivocamente cada carga de 
   -- extraída do arquivo de resultados gerados pela CAIXA. Este 
   -- código é gerado pelo programa para cada carga realizada no 
   -- Banco de Dados.
   DT_PROCESSAMENTO   DATE    NOT NULL ,                          
   -- Data em que o arquivo de resultados da CAIXA foi carregado 
   -- no Banco de Dados.
   DT_ARQ_CAIXA       DATE    NOT NULL ,                          
   -- Data do arquivo ZIP gerado pela CAIXA. Isso ajudará na 
   -- verificação do processo de ETL.
   QT_BYTES_ARQ_CAIXA INTEGER NOT NULL ,                          
   -- Tamanho do arquivo gerado pela CAIXA (em bytes) com os 
   -- resultados da MEGA-SENA, com as dezenas ordenadas de forma 
   -- crescente.
   QT_CONCURSOS       INTEGER NOT NULL                            
   -- Quantidade de Concursos processados durante a carga do arquivo 
   -- gerado pela CAIXA. Isso ajudará na verificação do processo de ETL.
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE CONCURSOS
-- Tabela..: CONCURSOS
--
-- Status..: OK 
-- Objetivo: Tabela temporária usada para carga dos dados do Excel,
--           nova forma de obtenção dos dados já sorteado pela CAIXA,
--           visto que agora setembro/2022 os dados só estão disponíveis
--           por Web Service. Então um excel manualmente é completado
--           antes que todo o processo rode. banco de dados durante o 
--           processo de ETL.
--
-- Detalhes: 
--
(
    CONCURSO        integer   not null primary key,
    DATA            date      not null,
    DEZE1           char(2)   not null,
    DEZE2           char(2)   not null,
    DEZE3           char(2)   not null,
    DEZE4           char(2)   not null,
    DEZE5           char(2)   not null,
    DEZE6           char(2)   not null,
    TUDO            char(17)  not null,
    SEMANA          text      not null,
    SOMA            integer   not null,
    ES1             text          null,
    ESQ1            integer       null,
    ES2             text          null,
    ESQ2            integer       null,
    ES3             text          null,
    ESQ3            integer       null,
    ES4             text          null,
    ESQ4            integer       null,
    ES5             text          null,
    ESQ5            integer       null,
    ES6             text          null,
    ESQ6            integer       null
);
CREATE TABLE DEZ_OCORRENCIAS 
-- Tabela..: DEZ_OCORRENCIAS
--
-- Status..: OK 
-- Objetivo: Reúne todas as ocorrências de cada DEZENA, por posição,
--           incluindo a data de ocorrência, a posição onde ela ocorre
--           e dia da semana quando ela ocorreu, onda reside a maior parte
--           da inteligência do negócio MEGA POWER!
--
-- Detalhes: 
-- 
(
    CONCURSO          INTEGER     NOT NULL,
    DATA              DATE        NOT NULL,
    DEZENA            char(2)     NOT NULL,
    POS               CHAR(2)     NOT NULL,
    SEMANA            VARCHAR(20) NOT NULL,
    MAXCONCURSO       INTEGER     NOT NULL,
    DEPARA_PADRAO_POS CHAR(9)     NOT NULL,
    DEPARA_PADRAO     CHAR(6)     NOT NULL
);
CREATE TABLE FAT_DEPARA(
  ID_DE_PARA,
  POS,
  DEZDE,
  DEZPARA,
  DE_PARA,
  QTD_OCO_DEPARA,
  MIN_MUD_DEZ,
  MED_MUD_DEZ,
  MAX_MUD_DEZ,
  DES_MUD_DEZ,
  MAX_DEZ_PARA,
  SOM_QTD_DEPARA_POS,
  PCT_DEZ_DE_PARA_POS,
  PCT_DEZ_DE_PARA_TOT,
  PCT_PROB_POR_PARA,
  TOT_OCOR_PARA_POS,
  TOT_OCOR_PARA,
  MAXCONCURSO,
  MIN_QTD_OCOR_AGR_DEZ,
  MED_QTD_OCOR_AGR_DEZ,
  DES_QTD_OCOR_AGR_DEZ,
  PROB_VOLTAR_SAIR_PARA,
  MEDPOISSONPARA
);
CREATE VIEW VW_ULTIMO_CONCURSO as  
 SELECT A.POS, 
        A.DEZENA, 
        A.CONCURSO,
        A.DATA,
        A.SEMANA,
        A.DEPARA_PADRAO_POS,
        A.DEPARA_PADRAO
   FROM DEZ_OCORRENCIAS as A
  WHERE A.MAXCONCURSO = A.CONCURSO
/* VW_ULTIMO_CONCURSO(POS,DEZENA,CONCURSO,DATA,SEMANA,DEPARA_PADRAO_POS,DEPARA_PADRAO) */;
CREATE VIEW VW_ANALISE_ULTIMO as  
select 
       S.ID_DE_PARA            ,
       S.POS                   ,
       S.DEZDE                 ,
       S.DEZPARA               ,
       S.DE_PARA               ,
       S.QTD_OCO_DEPARA        ,
       S.MIN_MUD_DEZ           ,
       S.MED_MUD_DEZ           ,
       S.MAX_MUD_DEZ           ,
       S.DES_MUD_DEZ           ,
       S.MAX_DEZ_PARA          ,
       S.SOM_QTD_DEPARA_POS    ,
       S.PCT_DEZ_DE_PARA_POS   ,
       S.PCT_DEZ_DE_PARA_TOT   ,
       S.PCT_PROB_POR_PARA     ,
       S.TOT_OCOR_PARA_POS     ,
       S.TOT_OCOR_PARA         ,
       S.MAXCONCURSO           ,
       S.MIN_QTD_OCOR_AGR_DEZ  ,
       S.MED_QTD_OCOR_AGR_DEZ  ,
       S.DES_QTD_OCOR_AGR_DEZ  ,
       S.PROB_VOLTAR_SAIR_PARA ,
       S.MEDPOISSONPARA        ,
       printf("%d",
           ((S.PCT_DEZ_DE_PARA_POS +
             S.PCT_DEZ_DE_PARA_TOT +
             S.PCT_PROB_POR_PARA   +
             S.PROB_VOLTAR_SAIR_PARA +
             S.MEDPOISSONPARA
            ) * 100.0))                         RANKING
  FROM FAT_DEPARA         as S,
       VW_ULTIMO_CONCURSO as B
 WHERE S.POS    = B.POS
   AND S.DEZDE  = B.DEZENA
/* VW_ANALISE_ULTIMO(ID_DE_PARA,POS,DEZDE,DEZPARA,DE_PARA,QTD_OCO_DEPARA,MIN_MUD_DEZ,MED_MUD_DEZ,MAX_MUD_DEZ,DES_MUD_DEZ,MAX_DEZ_PARA,SOM_QTD_DEPARA_POS,PCT_DEZ_DE_PARA_POS,PCT_DEZ_DE_PARA_TOT,PCT_PROB_POR_PARA,TOT_OCOR_PARA_POS,TOT_OCOR_PARA,MAXCONCURSO,MIN_QTD_OCOR_AGR_DEZ,MED_QTD_OCOR_AGR_DEZ,DES_QTD_OCOR_AGR_DEZ,PROB_VOLTAR_SAIR_PARA,MEDPOISSONPARA,RANKING) */;
CREATE TABLE EST_ATRASOS
-- Tabela..: EST_ATRASOS
--
-- Status..: OK 
-- Objetivo:
--           Manter uma ocorrência de cada dezena sorteada
--           indicando onde (posição na) ela apareceu, com
--           uma desnormalização que indica o dia da semana
--           quando ela apareceu. Mantem tambémn os dados
--           da próxima ocorrência sorteda na mesma posição,
--           cujo objetico é colher estatísticas de mudança
--           de estado das dezenas por posição.
--
-- Nota....:
--           Esta tabela deveria ser uma View temporária e
--           descartada após alimentar a FATO correspondência
--
-- Detalhes: 
-- 
(
    CONCURSO          INTEGER         NOT NULL,
    CONCURSOB         INTEGER         NOT NULL,
    DATA              DATE            NOT NULL,
    DATAB             DATE            NOT NULL,
    POS               CHAR(2)         NOT NULL,
    DEZENA            char(20)        NOT NULL,
    SEMANA            char(20)        NOT NULL,
    SEMANAB           char(20)        NOT NULL,
    ATRASO            INTEGER         NOT NULL);
CREATE VIEW VW_AGREG_ATRASOS_POISSON_ATRASAR as 
-- Objetivo..: Esta view faz contagem de trasos de cada dezena
--             desde a sua última aparição em um concurso.
--             ela também calcula a problidade de Poisson de a
--             Dezena continuar a trasada após o último sorteio.
--             Logo, as DEZENAScom maior probabilidade de sair 
--             são aquelas cuja coluna PROBPOISSON_ATRASAR é 0.00
--
-- Observação: Ainda não cheguei a nenhuma conclusão, exceto de
--             os números sorteados no sorteio seguinte estão sempre
--             entre aqueles com 0.00% de probabiidade de atrasar.
--
-- Depende de: TABELA EST_ATRASOS
--
-- Considerar: double e = Math.E;
--             double lambda = [média];
--             double numerator = Math.pow(e, -lambda) * Math.pow(lambda, k);
--             double denominator = factorial(k);
--             double result = numerator / denominator;
--             Na falta de fatorial(k) a fórmula de Stirling e Abraham de Moivre 
--             chegará muito próximo k! ≈ sqrt(2πk) * (k/e)^k
--             sqrt(2*pi*k) * pow((k/e), k)
--
--             Comparada com o valor obtido com a formuma do Excel
--             = Poisson(k, média, FALSO) foi muito próximo.
--             Logo, na falta de Fatorial(k) a fórmula de Stirling e
--             Moivre atende.
select 
       ROW_NUMBER () 
          OVER ( ORDER BY X.PROBPOISSON_ATRASAR desc )      POS_RANKING,
       X.*
  from (
        select E.DEZENA                                     DEZENA,
               E.ULT_CONCURSO                               ULT_CONCURSO,
               E.ULT_SAIDA                                  ULT_SAIDA,
               printf("%d", E.ARRASO_ATUAL)                 ARRASO_ATUAL,
               printf("%d", E.MED_ATRASO)                   MED_ATRASO,
               printf("%d", E.MAX_ATRASO)                   MAX_ATRASO,
               printf("%d", E.MED_POR_DEZENA)               MED_POR_DEZENA,
               printf("%8.5f",
               coalesce 
               ( (
                   exp( (-1.0 * E.MED_POR_DEZENA) ) *
                   pow((1.0 * E.MED_POR_DEZENA), ATRASAR_MAIS) 
                 ) / 
                 ( -- Na falta de fatorial a fórmula de Abraham Moivre 
                   -- chega muito próximo n! ≈ sqrt(2πn) * (n/e)^n
                   -- sqrt(2*pi*n) * pow((n/e), n)
                   sqrt(2.0 * pi() * E.ATRASAR_MAIS) * 
                   pow((E.ATRASAR_MAIS / exp(1)),  E.ATRASAR_MAIS)
                 )
               , 0.0))                                                    PROBPOISSON_ATRASAR
          from (
                   select B.MED_ATRASO,
                          D.*,
                          JULIANDAY('now') - JULIANDAY(ULT_SAIDA)         ARRASO_ATUAL,
                          (4.0 + JULIANDAY('now') - JULIANDAY(ULT_SAIDA)) ATRASAR_MAIS
                     from ( select avg(A.atraso) MED_ATRASO from EST_ATRASOS as A) as B,
                          ( select C.DEZENA           DEZENA, 
                                   max(C.CONCURSOB)   ULT_CONCURSO,
                                   max(C.DATAB)       ULT_SAIDA,
                                   avg(C.atraso)      MED_POR_DEZENA,
                                   max(C.ATRASO)      MAX_ATRASO
                              from EST_ATRASOS as C
                              -- where C.CONCURSO < (select max(y.concurso) - 1 from concursos as y)
                          group by 1      
                          ) AS D
                ) as E 
       order by PROBPOISSON_ATRASAR
    ) as X
/* VW_AGREG_ATRASOS_POISSON_ATRASAR(POS_RANKING,DEZENA,ULT_CONCURSO,ULT_SAIDA,ARRASO_ATUAL,MED_ATRASO,MAX_ATRASO,MED_POR_DEZENA,PROBPOISSON_ATRASAR) */;
CREATE VIEW VW_EST_DEZENAS
-- View....: EST_ATRASOS
--
-- Status..: OK 
-- Objetivo:
--           Manter uma ocorrência para cada dezena indicando
--           a primeira ocorrência dela, a última ocorência dela,
--           uma desnormalização que indica o dia da semana
--           a quantidade média de atrasos (dias entre uma e outra
--           ocorrência dela), o total de vezs em que ela ocorreu
--           em todos os concursos carregados e total de atrasos em
--           todos os concursos carregados, que é, por óbvio, o
--           número total de ocorrências - 1.
--
-- Depende.: CONCURSOS e DEZ_OCORRENCIAS
--
-- Detalhes: 
-- 
(
    DEZENA,
    MIN_CONC,
    MAX_CONC,
    MIN_ATRASO,
    MED_ATRASO,
    MAX_ATRASO,
    ULT_OCOR,
    TOTAL_CONCURSOS,
    QTD_OCOR_ATRASOS,
    TOTAL_OCOR_DEZ,
    TOT_DIAS_ATRASADOS_DEZ,
    DIAS_ATRASADOS) AS
  SELECT A.dezena                                      DEZENA,
         min(B.MIN_CONC)                               MIN_CONC,
         max(B.MAX_CONC)                               MAX_CONC,
         min(A.atraso)                                 MIN_ATRASO,
         printf("%2.0f", avg(A.atraso))                MED_ATRASO,
         max(A.atraso)                                 MAX_ATRASO,
         max(B.ULT_OCOR)                               ULT_OCOR,
         max(B.total)                                  TOTAL_CONCURSOS,
         count(1)                                      QTD_OCOR_ATRASOS,
         max(B.total)                                  TOTAL_OCOR_DEZ,
         sum(A.atraso)                                 TOT_DIAS_ATRASADOS_DEZ,
         max(printf("%2.0f",(JULIANDAY('now') - JULIANDAY(B.ULT_OCOR)))) DIAS_ATRASADOS
    from (    select DEZENA,
                     count(1)         total,
                     min(CONCURSO)    MIN_CONC,
                     max(CONCURSO)    MAX_CONC,
                     min(data)        inicio,
                     max(DATA)        ULT_OCOR
                from dez_ocorrencias as C
               where CONCURSO > 0
            group by 1 
            order by 1 
         ) as B,
         EST_ATRASOS as A 
   where A.DEZENA = B.DEZENA
group by 1 order by 1
/* VW_EST_DEZENAS(DEZENA,MIN_CONC,MAX_CONC,MIN_ATRASO,MED_ATRASO,MAX_ATRASO,ULT_OCOR,TOTAL_CONCURSOS,QTD_OCOR_ATRASOS,TOTAL_OCOR_DEZ,TOT_DIAS_ATRASADOS_DEZ,DIAS_ATRASADOS) */;
CREATE TABLE EST_MUD_ESTADO 
-- Table...: EST_MUD_ESTADO
--
-- Status..: OK 
-- Objetivo:
--           Mais uma tabela temporária para coleta de estatísticas.
--           Manter uma ocorrência para cada mudança de estado em uma
--           posição. Isto é, a cada dois concursos o par sorteado (DE-PARA),
--           numa posição pode mudar. O que se pretende é obter estatísticas
--           sobre estas mudanças, afim de detectar algum padrão e com base
--           nele estabelecer qual seria a probabilidades deste padrão DE-PARA
--           voltar a ocorrer nos próximos sorteios.
--
-- Depende.: CONCURSOS
--
-- Nota....: Já existe uma tabela fato com estes mesmo dados e por questões
--           de compatibilidade os dados deveria vir de lá tornando este
--           objeto em view.
-- 
-- Vide....: FAT_DEPARA
-- 
-- Detalhes: 
-- 
( 
    CONCURSO          INTEGER         NOT NULL,
    DATA              DATE            NOT NULL,
    POS               CHAR(2)         NOT NULL,
    DEZ_DE            char(2)         NOT NULL,
    DEZ_PARA          char(2)         NOT NULL,
    MUD_ESTADO        char(8)         NOT NULL,
    QTD               INTEGER         NOT NULL
);
CREATE VIEW VW_MUD_EST_PARA_POISSON
-- View....: VW_MUD_EST_PARA_POISSON
--
-- Status..: OK 
-- Objetivo:
--           Mais uma view temporária para coleta de estatísticas.
--           Manter uma ocorrência para cada mudança de estado em uma
--           posição. Isto é, a cada dois concursos o par sorteado 
--           (DE-PARA), numa posição pode mudar. O que se pretende é obter
--           estatísticassobre estas mudanças, afim de detectar algum
--           padrão e com base nele estabelecer qual seria a  
--           probabilidades deste padrão DE-PARA voltar a ocorrer nos 
--           próximos sorteios com uso do teorema de Poisson
--           Prob(QTD + 1) = (((QTD + 1)*e^(MEDIA)) / QTD!))
--
-- Depende.: EST_MUD_ESTADO, CONCURSOS 
--
--
-- Nota....: Já existe uma tabela fato com estes mesmo dados e por questões
--           de compatibilidade os dados vêem da tabela FAT_DEPARA, mantido 
--           este objeto para que poisson.java possa rodar sem impactos.
-- 
-- Vide....: FAT_DEPARA
-- 
-- Detalhes: 
--           Falta Poisson
--           Rank (Soma dos PCTs + Poisson)
--           Desvio padrao das quantidas
--              para em relação à media
--           Posião das quantidas PARA no RANK
--           Distancia das QtdsPara em relação à média de QtdsPara
--           Indicador se é ou não uma dezena provável
-- 
(
        MUD_ESTADO_GRP,
        MUD_ESTADO,
        QTD_OCOR,
        MIN_QTD,
        MED_QTD,
        MAX_QTD_PARA,
        SOMA_PARA,
        TOTAL_PARA,
        PCT_SOB_SOMA,
        PCT_SOB_QTD
) AS
  select  
            A.ID_DEZ_ORIGEM            MUD_ESTADO_GRP, 
            substr(A.ID_P1N1,4,5)      MUD_ESTADO, 
            A.QTD_MUD_P1               QTD_OCOR, 
            A.MIN_MUD_DEZ_POS          MIN_QTD, 
            A.MED_MUD_DEZ_POS          MED_QTD, 
            A.MAX_MUD_DEZ_POS          MAX_QTD_PARA, 
            A.TOT_MUD_DEZ_POS_N3       SOMA_PARA, 
            A.QTD_MUD_DEZ_POS          TOTAL_PARA, 
            A.PCT_OCOR_DEZ_DE          PCT_SOB_SOMA, 
            A.PCT_OCOR_DEZ_DEPARA      PCT_SOB_QTD 
    from FAT_DEPARA AS A 
order by 1,2;
CREATE TABLE FAT_SORTEIOS
-- Tabela..: FAT_SORTEIOS
--
-- Status..: OK 
-- Objetivo:
--           Mantem todos os resultados dos concursos realizados pela Caixa
--           para a loteria da MEGA-SENA. As dezenas são obtidas por ordem 
--           crescente em cada concurso e não por ordem de sorteio.
-- 
-- Depende.: 41 queries na formação de views. Um DELETE CASCADE dela 
--           praticamente elimina quase todas as tabelas e views do sistema. 
--           CUIDADO!
-- 
-- Nota....: Um programa em Java deve carregá-la. 
-- 
-- Vide....: CONCURSOS
-- 
-- Detalhes: 
-- 
(
 ICONCURSO           int           not null , 
 -- Identificador Único para cada concurso da mega sena gerado pela Caixa.
 Q25                 int           not null , 
 -- Cadeia de caracteres com as DEZENAS sorteadas no concurso separados 
 -- por um hífem (-).
 Q50                 int           not null , 
 -- Numero inteiro variando entre 0 e 5, indicando a quantidade de números 
 -- seguidos num sorteio.
 Q100                int           not null , 
 -- Número da 1ª dezena ordenada de forma crescente no sorteio.
 Q200                int           not null , 
 -- Número da 2ª dezena ordenada de forma crescente no sorteio.
 Q400                int           not null , 
 -- Número da 3ª dezena ordenada de forma crescente no sorteio.
 DEZENAS             varchar(20)   not null , 
 -- Número da 4ª dezena ordenada de forma crescente no sorteio.
 NUMSEGUIDOS         int           not null , 
 -- Número da 5ª dezena ordenada de forma crescente no sorteio.
 POS1                char(2)       not null , 
 -- Número da 6ª dezena ordenada de forma crescente no sorteio.
 POS2                char(2)       not null , 
 -- Inteiro com o valor da MENOR DEZENA no sorteio.
 POS3                char(2)       not null , 
 -- Real com o valor da MÉDIA das DEZENA no sorteio.
 POS4                char(2)       not null , 
 -- Inteiro com o valor da MAIOR DEZENA no sorteio.
 POS5                char(2)       not null , 
 -- Inteiro com o valor da SOMA das DEZENA no sorteio.
 POS6                char(2)       not null , 
 -- Inteiro com o valor da MENOR das distâncias entre as DEZENA no sorteio.
 MINDEZ              int           not null , 
 -- Real com o valor da MÉDIA das distâncias entre as DEZENA no sorteio.
 MEDDEZ              numeric(18,3) not null ,  
 -- Inteiro com o valor da MAIOR das distâncias entre as DEZENA no sorteio.
 MAXDEZ              int           not null,  
 -- Inteiro com o valor da SOMA das distâncias entre as DEZENA no sorteio.
 SUMDEZ              int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem do lado DIREITO
 -- da CARTELA.
 MINDIS              int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem do lado ESQUERDO
 -- da CARTELA.
 MEDDIS              numeric(18,3) not null,  
 -- Um padrão de textos com Es e Ds (p.e.: E-E-D-E-E-E) indicando por posição 
 -- do sorteio onde cada dezena aparece na cartela.
 MAXDIS              int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que são ÍMPARES no sorteio.
 SUMDIS              int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que são PARES no sorteio.
 DIR                 int           not null,  
 -- Um padrão de textos com Is e Ps (p.e.: P-I-P-I-I-P), indicando por posição 
 -- do sorteio, onde cada dezena é PAR ou ÍMPAR.
 ESQ                 int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem do lado INFERIOR 
 -- da CARTELA, i.e., menor que 31.
 MASCLATERALIDADE    varchar(40)   not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem do lado SUPERIOR 
 -- da CARTELA, i.e., maior que 30.
 IMP                 int           not null,  
 -- Um padrão de textos com Is e Ss (p.e.: I-I-I-S-S-S), indicando por posição
 -- do sorteio, onde cada dezena aparece na posição SUPEIOR ou INFERIOR.
 PAR                 int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que SÃO NÚMEROS PRIMOS.
 MASCPARIMPAR        varchar(40)   not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que NÃO SÃO NÚMEROS PRIMOS.
 INF                 int           not null,  
 -- Um padrão de textos com Ps e Ns (p.e.: P-N-N-P-N-N), indicando por posição
 -- do sorteio, onde cada dezena É ou NÃO NÚMERO PRIMO.
 SUP                 int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem no 1º QUADRANTE
 -- da CARTELA.
 MASCALTURA          varchar(40)   not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem no 2º QUADRANTE
 -- da CARTELA.
 PRI                 int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem no 3º QUADRANTE
 -- da CARTELA.
 NPR                 int           not null,  
 -- Inteiro com o valor da quantidade de DEZENAS que aparecem no 4º QUADRANTE
 -- da CARTELA.
 MASCPARIMO          varchar(40)   not null,  
 -- Um padrão de textos com Q1s a Q4s (p.e.: Q1-Q2-Q4-Q4-Q3-Q4), indicando 
 -- por posição do sorteio, onde cada dezena aparece no respectivo QUADRANTES
 -- da CARTELA.
 QQ1                 int           not null,  
 -- Data em formato para banco de dados em que o sorteio foi realizado.
 QQ2                 int           not null,  
 -- Data em formato curto, legível por humanos (p.e.: 08/07/1996). Trata-se
 -- de uma desnormalização da mesma data DATABDSORTEIO usada paara performance 
 -- no D.W.
 QQ3                 int           not null,  
 -- Inteiro contendo apenas o ANO da data DATABDSORTEIO para possíveis 
 -- agregações e anaálises por períodos anuais. Trata-se de desnormalização 
 -- para efeito de performance.
 QQ4                 int           not null,  
 -- Inteiro contendo valores entre 1 e 365(6) que represnta o DIA JULIANO, 
 -- no ano do SORTEIO, em que o sorteio ocorreu. Trata-se de desnormalização 
 -- para efeito de performance.
 MASCQUADRANTE       varchar(40)   not null,  
 -- Inteiro contendo valores entre 1 e 53(4) que represnta o número do SEMANA,
 -- no ano do SORTEIO, em que o sorteio ocorreu. Trata-se de desnormalização 
 -- para efeito de performance.
 MASCLINHA           varchar(40)   not null,  
 -- Texto contendo o nome do MÊS, no ano do SORTEIO, em que o sorteio ocorreu.
 -- Trata-se de desnormalização para efeito de performance.
 MASCBORDA           varchar(40)   not null,  
 -- Inteiro contendo valores entre 1 e 2 que represnta o número do SEMESTTRE,
 -- no ano do SORTEIO, em que o sorteio ocorreu. Trata-se de desnormalização
 -- para efeito de performance.
 MASCBRANCOPETRO     varchar(40)   not null,  
 -- Texto contendo o nome do SEMESTTRE, no ano do SORTEIO, em que o sorteio
 -- ocorreu. Trata-se de desnormalização para efeito de performance.
 MASCCOLUNA          varchar(40)   not null,  
 -- Texto contendo o nome do DIA DA SEMANA, no ano e no mês do SORTEIO, em
 -- que ele ocorreu. Trata-se de desnormalização para efeito de performance.
 MASCNUMESPELHO      varchar(40)   not null,  
 -- Número de ganhadores do prêmio principal (SENA).
 DATASORTEIO         varchar(40)   not null,  
 -- Número de ganhadores da 2ª faixa de premição (QUINA).
 DATABDSORTEIO       date          not null,  
 -- Número de ganhadores da 3ª faixa de premição (QUADRA).
 ANOSORTEIO          int           not null,  
 -- Valor Decimal Monetário do rateio do prêmio principal (SENA) por ganhador
 -- dessa faixa de premiação.
 DIAJULSORTEIO       int           not null,  
 -- Valor Decimal Monetário do rateio da (QUINA) por ganhador dessa faixa de
 -- premiação.
 SEMANOSORTEIO       int           not null,  
 -- Valor Decimal Monetário do rateio da (QUADRA) por ganhador dessa faixa de
 -- premiação.
 MESSORTEIO          varchar(20)   not null,  
 -- Valor Decimal Monetário que ficou acumulado no concurso por não haver 
 -- ganhadores na faixa de premiação principal (SENA).
 SEMMESSORTEIO       int           not null,  
 -- Texto contendo Sim ou Não para indicar se o prêmio ficou acumulada, por 
 -- falta de acertadores, na faixa de premiação principal.
 SEMSORTEIO          varchar(20)   not null,
 DIASEMSORTEIO       varchar(20)   not null,
 ACERTQUINA          int           not null,
 RATEIOQUINA         numeric(18,3) not null,
 ACERTQUADRA         int           not null,
 RATEIOQUADRA        numeric(18,3) not null,
 ACERTSENA           int           not null,
 RATEIOSENA          numeric(18,3) not null,
 VALACUMULADO        numeric(18,3) not null,
 INDACUMULADO        char(3)       not null,
        CONSTRAINT pk_fat_dezenas PRIMARY KEY (ICONCURSO)

);
CREATE TABLE FAT_DEZENAS_OCORRENCIAS
-- Tabela..: FAT_DEZENAS_OCORRENCIAS
--
-- Status..: OK 
-- Objetivo: Para cada CONCURSO são carregados os valores acumulados de cada
--           uma das 60 DEZENAS, indicando quantas vezes cada uma saiu, bem 
--           como a sua posição no RANKING GERAL e no RANKING das MAIS/MENOS 
--           sai, até última carga.
--
-- Depende.: Método Java (br.com.UNISoft.Mega2016Console.GenerateDezAcum) 
--           Para carregar:
--           Tabela FAT_SORTEIOS       - Usada para obter total pelo ETL
--           View vw_dezenas_sorteadas - Usada para obter o RANKING.
--           Tabele DIM_DEZENA         - Usada para estabelecer o RANKING.
--
--           View vw_fato_dezenas - Para gerar a View FATO com detalhes para
--           a fotografia de cada uma das dezenas como por exemplo a posição
--           deleas na ordem das DEZENAS, entre outras.
--
-- 20181211: Acrescentado novas colunas:
--              ID_ULTIMOCONCURSO       INTEGER NOT NULL,
--              DT_ULTIMOCONCURSO       DATE    NOT NULL,
--              DT_PRIMEIROCONCURSO     DATE    NOT NULL);
-- 
-- Nota....: Um programa em Java deve carregá-la. 
-- 
-- Vide....: CONCURSOS
-- 
-- Detalhes: 
-- 
(
    CONCURSO                INTEGER NOT NULL,   
    -- Código do concurso gerado pela CAIXA, identifica cada uma das 60
    -- DEZENAS descritas aqui.
    DEZENA                  CHAR(2) NOT NULL,   
    -- Código que identifica cada uma das 60 DEZENAS descritas aqui.
    VEZES                   INTEGER NOT NULL,   
    -- Valor Inteiro que representa quantas vezes a DEZENA descrita por esta
    -- tupla já ocorreu até este concurso.
    SINAL                   CHAR(1) NOT NULL,   
    -- Um Sinal (+/-) indicando com (+) se a DEZENA encontra-se entre as 30
    -- DEZENAS que mais sairam até este concurso. E, com o sinal (-) as 30 
    -- que menos sairam.
    RANKING_POSICAO         INTEGER NOT NULL,   
    -- Um valor Inteiro variando de 5 em 5, até 60 para indicar o RANKING 
    -- crescente de atrasos de cadea DEZENA até este concurso. Isto é, quanto 
    -- maior o número mais atrasada estará a DEZENA até este concurso.
    RANKING                 INTEGER NOT NULL,   
    -- Um valor Inteiro que varia de -30 a +30 indicando a posição de cada
    -- DEZENA classificada entre as -30 (mais atrasadas) e as +30 (mais saem).
    ID_ULTIMOCONCURSO       INTEGER NOT NULL,   
    -- ID CONCURSO última vez que a dezena saiu.
    DT_ULTIMOCONCURSO       DATE    NOT NULL,   
    -- Data do CONCURSO na última vez que a dezena saiu.
    DT_PRIMEIROCONCURSO     DATE    NOT NULL
    -- Data do CONCURSO da primeira vez que a dezena saiu.
);
CREATE INDEX idx2_DEZENAS_OCORRENCIAS ON FAT_DEZENAS_OCORRENCIAS (CONCURSO, DEZENA);
CREATE TABLE AGREG_SIGMAS_DEZENA 
-- Tabela..: AGREG_SIGMAS_DEZENA
--
-- Status..: OK 
-- Objetivo: Com base nos totais de ocorrências de padrões DE-PARA, 
--           avalia a distribuição de ocorrências por VARIÂNCIA.
--
-- Depende.: Progema em Java (br.com.UNISoft.Mega2016Console.????) 
--           Para carregar:
--           Tabela FAT_SORTEIOS       - Usada para obter total pelo ETL
--           View vw_dezenas_sorteadas - Usada para obter o RANKING.
--           Tabele DIM_DEZENA         - Usada para estabelecer o RANKING.
--
--           View vw_fato_dezenas - Para gerar a View FATO com detalhes para
--           a fotografia de cada uma das dezenas como por exemplo a posição
--           deleas na ordem das DEZENAS, entre outras.
--
-- 20181211: Acrescentado novas colunas:
--              ID_ULTIMOCONCURSO       INTEGER NOT NULL,
--              DT_ULTIMOCONCURSO       DATE    NOT NULL,
--              DT_PRIMEIROCONCURSO     DATE    NOT NULL);
-- 
-- Nota....: Um programa em Java deve carregá-la. Rever o algorítmo destes
--           cálculos.
-- 
-- Vide....: CONCURSOS
-- 
-- Detalhes: 
-- 
(
    CODIGO              INTEGER                 NOT NULL PRIMARY KEY AUTOINCREMENT,
    ATE_CONCURSO        INTEGER                 ,
    SG_DEZENA           CHARACTER(2)            NOT NULL,
    ULTIMOSIGMA         INTEGER                 NOT NULL,
    TOTAL               INTEGER                 NOT NULL,
    S1TOTAL             INTEGER                 NOT NULL,
    S1_P1               INTEGER                 NOT NULL,
    S1_P2               INTEGER                 NOT NULL,
    S1_P3               INTEGER                 NOT NULL,
    S1_P4               INTEGER                 NOT NULL,
    S1_P5               INTEGER                 NOT NULL,
    S1_P6               INTEGER                 NOT NULL,
    S2TOTAL             INTEGER                 NOT NULL,
    S2_P1               INTEGER                 NOT NULL,
    S2_P2               INTEGER                 NOT NULL,
    S2_P3               INTEGER                 NOT NULL,
    S2_P4               INTEGER                 NOT NULL,
    S2_P5               INTEGER                 NOT NULL,
    S2_P6               INTEGER                 NOT NULL,
    S3TOTAL             INTEGER                 NOT NULL,
    S3_P1               INTEGER                 NOT NULL,
    S3_P2               INTEGER                 NOT NULL,
    S3_P3               INTEGER                 NOT NULL,
    S3_P4               INTEGER                 NOT NULL,
    S3_P5               INTEGER                 NOT NULL,
    S3_P6               INTEGER                 NOT NULL,
    S4TOTAL             INTEGER                 NOT NULL,
    S4_P1               INTEGER                 NOT NULL,
    S4_P2               INTEGER                 NOT NULL,
    S4_P3               INTEGER                 NOT NULL,
    S4_P4               INTEGER                 NOT NULL,
    S4_P5               INTEGER                 NOT NULL,
    S4_P6               INTEGER                 NOT NULL,
    S5TOTAL             INTEGER                 NOT NULL,
    S5_P1               INTEGER                 NOT NULL,
    S5_P2               INTEGER                 NOT NULL,
    S5_P3               INTEGER                 NOT NULL,
    S5_P4               INTEGER                 NOT NULL,
    S5_P5               INTEGER                 NOT NULL,
    S5_P6               INTEGER                 NOT NULL,
    S6TOTAL             INTEGER                 NOT NULL,
    S6_P1               INTEGER                 NOT NULL,
    S6_P2               INTEGER                 NOT NULL,
    S6_P3               INTEGER                 NOT NULL,
    S6_P4               INTEGER                 NOT NULL,
    S6_P5               INTEGER                 NOT NULL,
    S6_P6               INTEGER                 NOT NULL,
    CONSTRAINT uk_agreg_sigmas_dezena UNIQUE (ATE_CONCURSO, SG_DEZENA)
    );
CREATE INDEX indx_agreg_sigs_dez ON agreg_sigmas_dezena  ( SG_DEZENA );
CREATE TABLE DIM_DEZENA
-- Tabela..: DIM_DEZENA
--
-- Status..: OK 
-- Objetivo: Descreve em detalhes todos os atributos mensuráveis de uma
--           dezena sob a óptica dos concursos da MEGA-SENA, realizados
--           pela CAIXA.
--
-- Depende.:  
-- 
-- Nota....:  
-- 
-- Vide....:  
-- 
-- Usada em: reldezenas.php
-- 
-- Detalhes: 
-- 
(
   CO_DEZENA    NUMERIC(2)    NOT NULL, 
   -- Código sequencial vriando de 1 à 60 usado nas circunstâncias onde se
   -- necessite de um identificador númerico para a dezena detahada por 
   -- esta dimensão.
   SG_DEZENA    CHAR(2)       NOT NULL, 
   -- Sigla da dezena preenchida com zero à esquerda para aqueas dezenas 
   -- menosres 10, e que será usada como chave primária para identiicar 
   -- cada uma das tuplas desta dimensão que descreve em detalhes os 
   -- atributos de uma dimensão DEZENA.
   DS_DEZENA    VARCHAR(100)  NOT NULL, 
   -- Descrição da dezena por extenso.
   CO_EH_PRIMO  NUMERIC(2)    NOT NULL, 
   -- Código para indicação se a dezena é ou não um número primo, onde
   -- 1 indica que a dezena associada a este código É UM NÚMERO PRIMO,
   -- isto é, só pode ser divisível por eles mesmo, além de UM. o Valor
   -- default para este atributo é -1, que indica não ter sido informada
   -- se é ou não um número primo.
   SG_EH_PRIMO  VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação se a dezena é ou não um número primo, onde o texto
   -- "É Primo" indica que a dezena associada a este código É UM NÚMERO PRIMO,
   -- isto é, só pode ser divisível por eles mesmo, além de UM. O Valor
   -- default para este atributo é o texto "Não é Primo" , que indica não ser
   -- um número primo.
   DS_EH_PRIMO  VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação se a dezena é ou não um número primo, onde o
   -- texto "Dezena é um número Primo" indicará que a dezena associada a 
   -- este texto É UM NÚMERO PRIMO, isto é, só pode ser divisível por eles
   -- mesmo, além de UM. O texto "Dezena não é um número Primo" indicará o
   -- contrário.O Valor default para este atributo é o texto "Dezena sem
   -- valor informado para este atributo", indica não ser um número primo.
   CO_PAR_IMPAR NUMERIC(2)    NOT NULL, 
   -- Código para indicação se a dezena é ou não um número par, onde o código
   -- 1 indicará que a dezena associada a este código É UM NÚMERO ÍMPAR.Se o
   -- valor for 2 indicará que trata-se de um número PAR. O Valor default
   -- para este atributo é o código -1, que indica ser um número sem a 
   -- paridade inforada.
   SG_PAR_IMPAR VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação se a dezena é ou não um número par, onde o texto
   -- "Ímpar" indicará que a dezena associada a este código É UM NÚMERO
   -- ÍMPAR. Se o valor texto for "Par" indicará que trata-se de um número
   -- PAR. O Valor default para este atributo é o código "Não Informada", 
   -- que indica ser um número é sem a paridade inforada.
   DS_PAR_IMPAR VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação se a dezena é ou não um número par, onde o
   -- texto "Dezena é um número Ímpar" indicará que a dezena associada a 
   -- este texto,  É UM NÚMERO ÍMPAR. Se o valor texto for "Dezena é um 
   -- número Par" indicará que trata-se de um número PAR. O Valor default
   -- para este atributo é o código "Dezena não tem paridade Informada",
   -- que indica ser um número é sem a paridade inforada.
   CO_EH_ESPELH NUMERIC(2)    NOT NULL, 
   -- Código para indicação se a dezena é ou não um número em ESPELHO,
   -- isto é, 11, 22 ...., 55, de modo que o código 1 indicará que a dezena
   -- associada a este código, É UM NÚMERO EM ESPELHO. Se o valor for 2
   -- indicará o contrário. O Valor default para este atributo é o código
   -- -1, que indicará ser um número sem este dado informado.
   SG_EH_ESPELH VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação se a dezena é ou não um número em ESPELHO,
   -- isto é, 11, 22 ...., 55, de modo que o texto "É Espelho" indicará
   -- que a dezena associada a este texto É UM NÚMERO EM ESPELHO.Se o valor
   -- for para este atributo for "Não é Espelho" indicará o contrário.
   -- O Valor default para este atributo é o texto "Não Informado", que
   -- indicará ser um número sem este dado inforado.
   DS_EH_ESPELH VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação se a dezena é ou não um númerovem ESPELHO,
   -- isto é, 11, 22 ...., 55. Logo, o texto "Dezena tem numeros em Espelho"
   -- indicará que a dezena associada a este texto É UM NÚMERO EM ESPELHO.
   -- Se o valor para este atributo for "Dezena não tem numeros em Espelho"
   -- indicará o contrário. O Valor default para este atributo é o texto 
   -- "Dado Não Informado", que indicará ser um número sem este dado inforado.
   CO_EH_BORDA  NUMERIC(2)    NOT NULL, 
   -- Código para indicação se a dezena é ou não um número da BORDA da 
   -- cartela, isto é, 1, 2, ... 59, e 60, de modo que o código 1 indicará que
   -- a dezena associada a este código É UM NÚMERO DA BORDA da cartela. Se o
   -- valor for 2 indicará o contrário. O Valor default para -- este atributo 
   -- é o -1, que indicará ser um número sem este dado inforado.
   SG_EH_BORDA  VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação se a dezena é ou não um número da BORDA da cartela,
   -- isto é, 1, 2, 3, 4 , ... 59, e 60, de modo que o texto "É da Borda" 
   -- indicará que a dezena associada a este código É UM NÚMERO DA BORDA.
   -- Se o valor for "Não é da Borda" indicará o contrário. O Valor default 
   -- para este atributo é o texto "Não Informado", que indicará ser um 
   -- número sem este dado inforado.
   DS_EH_BORDA  VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação se a dezena é ou não um número da BORDA da 
   -- cartela, isto é, 1, 2, 3,  ....  59, e 60, de modo que o texto 
   -- "Dezena esta na Borda" indicará que a dezena associada a este texto,
   -- É UM NÚMERO DA BORDA. Se o valor for "Dezena não esta na Borda" indicará
   -- o contrário. O Valor default para este atributo é o texto 
   -- "Não Informado", que indicará ser um número sem este dado inforado.
   CO_COLUNA    NUMERIC(2)    NOT NULL, 
   -- Código para indicação em qual das 10 COLUNAS na cartela a dezena está, 
   -- isto é, 1, 2, 3, 4 , 5, 6, 7, 8, 9, ou 10, de modo que o código 1 
   -- indicará que a dezena associada a este código ESTA NA COLUNA 1, e assim
   -- sucessivamente. O Valor default para este atributo é o código -1, que
   -- indicará ser uma dezena sem este dado inforado.
   SG_COLUNA    VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação em qual das 10 COLUNAS na cartela a dezena está,
   -- isto é, "1ª Coluna", ...,  ou "10ª Col.", de modo que o texto 
   -- "1ª Coluna" indicará que a dezena associada a este código
   -- ESTA NA COLUNA 1, e assim sucessivamente. O Valor default para este
   -- atributo é o Texto "Não Informado", que indicará ser uma dezena sem
   -- este dado inforado.
   DS_COLUNA    VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação em qual das 10 COLUNAS na cartela a dezena
   -- está, isto é, uma dscrição por exenso, de modo que o texto 
   -- "Dezena está na Coluna Quatro" indicará que a dezena associada a este
   -- código ESTA NA COLUNA 4, e assim respectivamente. O Valor default
   -- para este atributo é o Texto "Não Informado para esta dezena", que
   -- indicará ser uma dezena sem este dado inforado. 
   CO_LINHA     NUMERIC(2)    NOT NULL, 
   -- Código para indicação em qual das 6 LINHAS na cartela a dezena está,
   -- isto é, 1, 2, 3, 4 , 5,  ou 6, de modo que o código 1 indicará que a
   -- dezena associada a este código ESTA NA LINHA 1, e assim sucessivamente.
   -- O Valor default para este atributo é o código -1, que indicará ser
   -- uma dezena sem este dado inforado.
   SG_LINHA     VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação em qual das 6 LINHAS na cartela a dezena está,
   -- isto é, 1, 2, 3, 4 , 5,  ou 6, de modo que o texto "1ª Linha" indicará
   -- que a dezena associada a este texto ESTA NA LINHA 1, e assim
   -- sucessivamente. O Valor default para este atributo é o texto 
   -- "Não Informado", que indicará ser uma dezena sem este dado inforado.
   DS_LINHA     VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação em qual das 6 LINHAS nabcartela a dezena está,
   -- isto é, 1, 2, 3, 4 , 5,  ou 6, de modo que o texto
   -- "Dezena está na Linha Um" indicará que a dezena associada a este texto
   -- ESTA NA LINHA 1, e assim sucessivamente. O Valor default para este
   -- atributo é o texto "Dezena não tem este dado Informado", que indicará
   -- ser uma dezena sem este dado inforado.
   CO_METADE    NUMERIC(2)    NOT NULL, 
   -- Código para indicação se a dezena é ou não da 1ª metade da cartela,
   -- isto é, MENOR que 31, onde 1 indica que a dezena associada a este
   -- código É UM NÚMERO DA PRIMEIRA METADE DA CARTELA, e o valor 2 indica o
   -- contrário, ou seja, da 2ª metade cartela. O Valor default para este
   -- atributo é -1, que indica não ter sido informada um valor para este
   -- atributo.
   SG_METADE    VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação se a dezena é ou não da 1ª metade da cartela,
   -- isto é, tem valor MENOR que 31, onde o texto "1ª Metade" indica que
   -- a dezena associada a este texto, É UM NÚMERO DA PRIMEIRA METADE DA
   -- CARTELA, e o texto "2ª Metade" indicará o contrário, ou seja,
   -- da 2ª metade cartela. O Valor default para este atributo é
   -- "Não Informado", que indica não ter sido informada um valor para este
   -- atributo.
   DS_METADE    VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação se a dezena é ou não da 1ª metade da cartela,
   -- isto é, tem valor MENOR que 31, onde o texto "Dezena está na 1ª Metade"
   -- indica que a dezena associada a este texto, É UM NÚMERO DA PRIMEIRA
   -- METADE DA CARTELA, e o texto "Dezena está na 2ª Metade" indicará o
   -- contrário, ou seja, da 2ª metade cartela. O Valor default para este
   -- atributo é "Dado não Informado para este atributo", que indica não
   --ter sido informada um valor para este atributo.
   CO_LADO      NUMERIC(2)    NOT NULL, 
   -- Código para indicação se a dezena é ou não do ESQUERDO da cartela,
   -- isto é,  com números terminados 1,2,3,4, ou 5, onde 1 indica que a
   -- dezena associada a este código ESTÁ NO LADO ESQUERDO DA CARTELA, e o
   -- valor 2 indica o contrário, ou seja, do LADO DIREITO da cartela.
   -- O Valor default para este atributo é -1, que indica não ter sido
   -- informada um valor para este atributo.
   SG_LADO      VARCHAR(15)   NOT NULL, 
   -- SIgla para indicação se a dezena é ou não do ESQUERDO da cartela,
   -- isto é, com números terminados 1,2,3,4, ou 5, onde o texto "Esquerdo"
   -- indica que a dezena associada a este código
   -- ESTÁ NO LADO ESQUERDO DA CARTELA, e o texto "Direito" indica o
   -- contrário, ou seja, do LADO DIREITO da cartela. O Valor default para
   -- este atributo é "Não Informado", que indica não ter sido informada um
   -- valor para este atributo.
   DS_LADO      VARCHAR(100)  NOT NULL, 
   -- Descrição para indicação se a dezena é ou não do ESQUERDO da cartela,
   -- isto é, com números terminados 1,2,3,4, ou 5, onde o texto
   --"Dezena está no Lado Esquerdo" indica que a dezena associada a este
   -- código ESTÁ NO LADO ESQUERDO DA CARTELA, e o texto
   -- "Dezena está no Lado Direito" indica o contrário, ou seja, do
   -- LADO DIREITO da cartela. O Valor default para este atributo é
   -- "Dado Não Informado para este atributo", que indica não ter sido
   -- informada um valor para este atributo.
   CO_QUADRANTE NUMERIC(2)    NOT NULL,
   -- Código para indicação em qual dos 4 QUADRANTES imaginários da cartela
   -- está a dezena, isto é, dezenas terminadas em 1, 2, 3, 4 , ou 5 estão
   -- no 1º QUDRANTE, se forem dezenas menores que 31, e se forem maiores que
   -- 30 estarão no 3º QUADRANTE. Por outro lado as dezenas terminadas em:
   -- 6,7,8,9 ou 0, estarão no 2º QUADRANTE, se forem menores que 31, quando
   -- forem maiores que 30 e starão no 4º Quadrante. O código 1 indicará que
   -- a dezena associada a este código ESTA NO 1º QUADRANTE, e assim
   -- sucessivamente. O Valor default para este atributo é o código -1, que
   -- indicará ser uma dezena sem este dado inforado.
   SG_QUADRANTE VARCHAR(15)   NOT NULL, 
   -- Sigla para indicação em qual dos 4 QUADRANTES imaginários da cartela
   -- está a dezena. O texto "1º Quadro" indicará que a dezena associada a
   -- este código ESTA NO 1º QUADRANTE, e assim sucessivamente. O Valor
   -- default para este atributo é o texto "Não Informado", que indicará ser
   -- uma dezena sem este dado inforado.
   DS_QUADRANTE VARCHAR(100)  NOT NULL,
   -- Descrição para indicação em qual dos 4 QUADRANTES imaginários da
   -- cartela está a dezena. O texto "Dezena está no 1º Quadrante" indicará
   -- que a dezena associada a este código ESTA NO 1º QUADRANTE, e assim
   -- sucessivamente. O Valor default para este atributo é o texto
   -- "Não Informado", que indicará ser uma dezena sem este dado inforado.
   CO_DIAGONAL  VARCHAR(100)  NOT NULL, 
   -- Código para indicar em qual das DIGONAIS imaginárias da cartela 
   -- encontra-se a dezena, sendo que o valor 1 indicará que a dezena 
   -- encontra-se na DIAGONAL superior  formada pelas seguintes dezenas: 1,
   -- 2, ... 43, e 51. o  Valor 2 indicará que a dezena encontra-se na outra
   -- DIAGONAL a INFERIOR. O valor default para este  atributo -1, que indica
   -- que não foi informado valor  para este atributo.
   SG_DIAGONAL  VARCHAR(15)   NOT NULL, 
   -- Sigla para indicar em qual das DIGONAIS imaginárias da cartela 
   -- encontra-se a dezena, sendo que o texto "1ª Diagonal" indicará que a
   -- dezena encontra-se na -- DIAGONAL superior formada pelas seguintes 
   -- dezenas: 1, 2, 3, ..., 41, 42, 43, e 51. O texto "2ª Diagonal" 
   -- indicará que a dezena encontra-se na outra DIAGONAL a INFERIOR. O 
   -- valor default para este atributo é "Não Informado", que indica que não
   -- foi informado valor para este atributo.
   DS_DIAGONAL  VARCHAR(100)  NOT NULL  
   -- Descrição para indicar em qual das DIGONAIS imaginárias da cartela
   -- encontra-se a dezena, sendo que o texto "Dezena está na 1ª Diagonal"
   -- indicará que a dezena encontra-se na DIAGONAL superior formada pelas
   -- seguintes dezenas: 1, 2, 3, ..., 42, 43, e 51. O texto:
   -- "Dezena está na 2ª Diagonal" indicará que a dezena encontra-se na 
   -- outra DIAGONAL a INFERIOR. O valor default para este atributo é: 
   -- "Não Informado", que indica que não foi informado valor para este atributo.
);
CREATE VIEW VW_DESC_DEZENAS (
     DEZENA,
     DESCRICAO
) AS
SELECT
         A.SG_DEZENA                               DEZENA,
         "<p>A Dezena <b>"        ||
         A.SG_DEZENA              || "</b> (" ||
         A.DS_DEZENA              || ") " ||
         A.SG_EH_PRIMO            || ", é " ||
         A.SG_PAR_IMPAR           || " e " ||
         A.SG_EH_ESPELH           || ". A " ||
         A.DS_EH_BORDA            || ", pois ela aparece na " ||
         A.SG_COLUNA              || ", na " ||
         A.SG_LINHA               || ", na " ||
         A.SG_METADE              || " do lado " ||
         A.SG_LADO                || ", posicionada no " ||
         A.SG_QUADRANTE           || " e também está na " ||
         A.SG_DIAGONAL            || " da cartela de apostas.</p>" ||
                                     "<table class='table  table-sm table-striped'><thead><tr><th scope='col'>" ||
                                     "Estatísitca</th><th scope='col'>Valor</th></tr>" ||
                                     "</thead><tbody><tr><th scope='row'>" ||
                                     "Primeiro concurso que saiu: </th><td>" ||
                                     B.MIN_CONC || "</td><tr><th scope='row'>" ||
                                     "Último concurso que saiu: </th><td>" ||
                                     B.MAX_CONC || " (" ||
                                     B.ULT_OCOR || ") </td><tr><th scope='row'>" ||
                                     "Total de vezes que saiu: </th><td>" ||
                                     B.TOTAL_OCOR_DEZ || "</td><tr><th scope='row'>" ||
                                     "Menor tempo sem sair: </th><td>" ||
                                     B.MIN_ATRASO || "</td><tr><th scope='row'>" ||
                                     "Média de atrasos entre saídas: </th><td>" ||
                                     B.MED_ATRASO || "</td><tr><th scope='row'>" ||
                                     "Maior número de concursos sem sair:  </th><td>" ||
                                     B.MAX_ATRASO || "</td></tr><th scope='row'>" ||
                                     "E já está sem sair ha: </th><td>" ||
                                     B.DIAS_ATRASADOS || " dias</td></tr></tbody></table>"  DESCRICAO
 from DIM_DEZENA      as A,
      VW_EST_DEZENAS  AS B
where A.SG_DEZENA = B.DEZENA
/* VW_DESC_DEZENAS(DEZENA,DESCRICAO) */;
CREATE TABLE FAT_MUD_EST_COM_POISSON(
  ID,
  GRPDE,
  DEZPARA,
  POS,
  DEPARAID,
  QTDOCOR,
  MINOCORPARA,
  MEDOCORPARA,
  MAXOCORPARA,
  DSVOCORPARA,
  QTDOCORDEZGRP,
  SOMAOCORPARAS,
  PCTQTDBYOCORGRP,
  PCTQTDBYSOMAGRP,
  PROBPOISSONDEZ,
  TOT_OCOR_PARA_POS,
  TOT_OCOR_PARA,
  MAXCONCURSO,
  MIN_QTD_OCOR_AGR_DEZ,
  MED_QTD_OCOR_AGR_DEZ,
  DES_QTD_OCOR_AGR_DEZ,
  PROB_VOLTAR_SAIR_PARA,
  MEDPOISSONPARAS,
  RANKDEZ,
  DISTQTDMEDGRP,
  INDDEZPROVAVEL,
  POSRANKSGRP
);
CREATE TABLE DIM_ESTATISTICA_PADROES
-- Arquivo   : Formato UTF-8
-- SGBD      : Script para HSQLDB 2.9
--
-- Por       : Anderson
-- Em        : 09/12/2018 - Criado
--           : 10/12/2018 - Adicionado padrão sequencias em espelhos 11, 
--                          22, 33, ...
--
-- Script    : Depende um programa em C++ que gera as estatísticas de
--             TODOS os Padrões. Programa em JAVA que precisa ser revisto
--             pois se refere a categorias de forma não apropriada.
--
-- Descricao : DIM_ESTATISTICA_PADROES
--             Reune todos os padões possíveis de combinações geradas a 
--             partir da posição das DEZENAS na cartela, bem como as suas 
--             respectivas estatísticas, para TODAS as cominações
-- possíveis da MEGA.
--
-- Depende de:
--
-- OBSERVACAO
--    Faltam criar as chaves
--
-- Remover a tabela??
(
   CO_PADRAO                 NUMERIC(3)              NOT NULL,  
   -- Identifica univicamente cada uma das categorias de padões onde:
   -- A - Par/Ímpar, B - Superior/Inferior, ....
   SG_CATEGORIA              CHAR(1)                 NOT NULL,  
   -- Identifica univicamente cada uma dos padões, dentro de cada CATEGORIA,
   -- formado pela presença, ou não, de DEZENAS Par/Ímpar, 
   -- B - Superior/Inferior, ....
   DS_PADRAO                 VARCHAR(100)            NOT NULL,  
   -- Identifica univicamente cada uma dos padões, EM REPRESENTAÇÃO BINÁRIA,
   -- dentro de cada.
   DS_PADRAO_BINARIO         VARCHAR(64)             NOT NULL,
   -- CATEGORIA, formado pela presença, ou não, de DEZENAS Par/Ímpar, 
   -- B - Superior/Inferior, ...
   VL_PADRAO_DECIMAL         NUMERIC(3)              NOT NULL,  
   -- Identifica univicamente cada uma dos padões, EM REPRESENTAÇÃO DECIMAL, 
   -- dentro de cada padrão.
   VL_QTD                    NUMERIC(30)             NOT NULL,
   -- CATEGORIA, formado pela presença, ou não, de DEZENAS Par/Ímpar, 
   -- B - Superior/Inferior, ....
   VL_PCT                    NUMERIC(10,5)           NOT NULL,
   -- O valor da quantidade de ocorrência deste padão.
   CONSTRAINT PK_DIM_ESTATISTICAS     PRIMARY KEY (CO_PADRAO),  
   -- O valor percentual da quantidade de ocorrência deste padão.
   CONSTRAINT UK_DIM_ESTATISTICASUNIQUE UNIQUE  (SG_CATEGORIA, DS_PADRAO)
);
CREATE VIEW VW_FATO_DEZENAS 
-- View.....: VW_FATO_DEZENAS
-- 
-- Status...: OK 
-- Objetivo.: 
--            Lista cada uma das DEZENAS, PARA cada um dos CONCURSOS, 
--            mostrsando a posição onde elas ocorrem, a data da última  
--            ocorrência, o total de ocorrências acumuladas até o CONCURSO,
--            o RANKING GERAL, o RANKING dos que MAIS/MENOS saem.
-- 
-- 2016/01/20 - Criada.
-- 
-- 2018/12/13 - Corrção para simplificar a view e funcioar com o HSQLDB. 
--            Adicionado comentários.
--      
-- Depende..: FAT_DEZENAS_OCORRENCIAS  
--      
-- Nota.....: Consulta para obter total de ocorrências por DEZENA, RANKING,
--            SINAL, VIEW VW_DEZENAS_SORTEADAS - Usada na consulta a poaição
--            onde cada DEZENA ocorreu, bem como os ciclos de ID.
-- 
-- Vide.....:  
-- 
-- Usada em.: 
-- 
-- Detalhes.: 
--  
( 
        CONCURSO,          
        -- Identifica univicamente cada ocorrência de concurso.
        DEZENA,            
        -- Identifica univicamente cada ocorrência de DEZENA.
        POS,               
        -- Posição (ordem) nos CONCURSOS onde a DEZENA já apareceu, 
        -- no CONCURSOS realizados até a última carga.
        VEZES,             
        -- Um Sinal (+/-) indicando com (+) se a DEZENA encontra-se
        -- entre as 30 DEZENAS que mais sairam até este concurso.
        -- E com o sinal (-) as 30 que menos sairam.
        SINAL,             
        -- Um valor Inteiro variando de 5 em 5, até 60 para indicar o
        -- RANKING crescente de atrasos de cadea DEZENA até este
        -- concurso. Isto é, quanto maior o número mais atrasada 
        -- estará a DEZENA até este concurso.
        RANKING_POSICAO,   
        -- Um valor Inteiro que varia de -30 a +30 indicando a posição
        -- de cada DEZENA classificada entre as -30 (mais atrasadas)
        -- e as +30 (mais saem).
        RANKING,          
        -- Data do última vez em que a DEZENA saiu.
        DATABDSORTEIO,     
        -- Módulo de 25 do ID do concurso para que se possa agrupar a
        -- cada 25 sorteios, as ocorrências de cada DEZENA.
        Q25,               
        -- Módulo de 50 do ID do concurso para que se possa agrupar a
        -- cada 50 sorteios, as ocorrências de cada DEZENA.
        Q50,               
        -- Módulo de 100 do ID do concurso para que se possa agrupar a
        -- cada 100 sorteios, as ocorrências de cada DEZENA.
        Q100,              
        -- Módulo de 200 do ID do concurso para que se possa agrupar a
        -- cada 200 sorteios, as ocorrências de cada DEZENA.
        Q200,              
        -- Módulo de 400 do ID do concurso para que se possa agrupar a
        -- cada 400 sorteios, as ocorrências de cada DEZENA.
        Q400
) as
         SELECT A.CONCURSO,
                A.DEZENA,
                B.POS,
                A.VEZES,
                A.SINAL,
                A.RANKING_POSICAO,
                A.RANKING,
                B.DATABDSORTEIO,
                B.Q25,
                B.Q50,
                B.Q100,
                B.Q200,
                B.Q400                        
           FROM FAT_DEZENAS_OCORRENCIAS  AS A
LEFT OUTER JOIN VW_DEZENAS_SORTEADAS     AS B 
             ON ((A.CONCURSO = B.ID) AND (A.DEZENA = B.DEZENA) AND (B.POS <> 0)) 
       ORDER BY A.DEZENA, B.POS, A.VEZES DESC
/* VW_FATO_DEZENAS(CONCURSO,DEZENA,POS,VEZES,SINAL,RANKING_POSICAO,RANKING,DATABDSORTEIO,Q25,Q50,Q100,Q200,Q400) */;
CREATE VIEW VW_DEZENAS_SORTEADAS
-- OK - Seleciona todas as DEZENAS de cada concurso, indicando a posição
--      onde ela ocorre, bem como a data do sorteio. 
--
-- Objetivo : Objetivo Script de criação dos objetos do Mega2019
-- Por      : Anderson Luis Oliveira e Silva
-- Em       : 2015/12/18
-- Conexão  : Em desenvolvimento usar: 
--            jdbc:hsqldb:.\Dados\Mega2015DB
-- Histórico:
-- 2015/12/18 Adicição desta view após a criação do banco
-- 2016/01/20 Adidicionado mais uma UNIONS para servir de ponto de 
--            partida de todas as dezenas_ocorrencias contendo 0 (ZERO) 
--            para ID  do CONCURSO, POSICAO, Q25, Q50, Q100, Q200, e Q400,
--            e preservando a data do primeiro CONCURSO para servir no
--            calculo ds atrasos.
-- 2018/12/13 Alteração do nome da tabela de DEZENAS_OCORRENCIAS para
--            FAT_DEZENAS_OCORRENCIAS
--
-- View.....: vw_dezenas_sorteadas
--
-- Objetivo.:
--            UNIONS com select de cada uma das 6 posicoes da tabela
--            SORTEIOS para representar todas as DEZENAS sorteadas até o
--            último sorteio registrado
--
-- 2016/01/20 REMOVIDO adicionado de mais uma UNION ESPECIAL, para servir
--            de ponto de partida para cada uma das DEZENAS trazidas da 
--            TABELA DIM_DEZENA, contendo 0 (ZERO) para ID do CONCURSO, 
--            POSICAO, Q25, Q50, Q100, Q200, e Q400, preservando a data do
--            primeiro CONCURSO para servir no cálculo ds atrasos.
--
-- 2018/12/10 Corrigida a view, removendo o calculo de faixas: 
--            (50,100, ...), pois ele já se encontra na tabela
--            FAT_SORTEIOS, e adicionados os comentários.
--
-- 2018/12/13 - Alteração da tabela SORTEIOS para FAT_SORTEIOS.
--
-- Depende..: Tabela FAT_SORTEIOS - Consulta para obter total de sorteios
--            duranto o ETL Tabele DIM_DEZENA - Usada na consulta para 
--            gerar a UNION ESPECIAL que servirá de ponto de partida.
--
-- Dependem
--     Dela : VIEW VW_OCORRENCIAS_DEZENAS            
--            VIEW dist_ocor_dezenas_por_posicao     
--            VIEW vw_ocorrencias_dezenas_dia_semana 
--            VIEW vw_fato_dezenas                   
--            VIEW vw_agreg_pct_dezenas_posicao      
--
--
(
  Q25,             
  -- Identifica univicamente cada ocorrência de concurso.
  Q50,             
  -- Módulo de 25 do ID do concurso para que se possa agrupar a
  -- cada 25 sorteios, as ocorrências de cada DEZENA.
  Q100,            
  -- Módulo de 50 do ID do concurso para que se possa agrupar a
  -- cada 50 sorteios, as ocorrências de cada DEZENA.
  Q200,            
  -- Módulo de 100 do ID do concurso para que se possa agrupar a
  -- cada 100 sorteios, as ocorrências de cada DEZENA.
  Q400,            
  -- Módulo de 200 do ID do concurso para que se possa agrupar a
  -- cada 200 sorteios, as ocorrências de cada DEZENA.
  DATABDSORTEIO,   
  -- Módulo de 400 do ID do concurso para que se possa agrupar a
  -- cada 400 sorteios, as ocorrências de cada DEZENA.
  ID,              
  -- Data da ocorrências de cada DEZENA. Útil para calcular os
  -- atrazos de cada DEZENA.
  POS,             
  -- Identifica a posição (ordem) de cada ocorrência de DEZENA,
  -- por concurso.
  DEZENA           
  -- Identifica univicamente cada uma das ocorrência DEZENAS no concurso.
)
AS
SELECT  Q25,
        Q50,
        Q100,
        Q200,
        Q400,
        DATABDSORTEIO DATABDSORTEIO,
        ICONCURSO     ID,
        1             POS,
        POS1        DEZENA
   FROM FAT_SORTEIOS
   UNION ALL
SELECT  Q25,
        Q50,
        Q100,
        Q200,
        Q400,
        DATABDSORTEIO DATABDSORTEIO,
        ICONCURSO     ID,
        2             POS,
        POS2          DEZENA
   FROM FAT_SORTEIOS
   UNION ALL
SELECT  Q25,
        Q50,
        Q100,
        Q200,
        Q400,
        DATABDSORTEIO DATABDSORTEIO,
        ICONCURSO     ID,
        3             POS,
        POS3          DEZENA
   FROM FAT_SORTEIOS
   UNION ALL
SELECT  Q25,
        Q50,
        Q100,
        Q200,
        Q400,
        DATABDSORTEIO DATABDSORTEIO,
        ICONCURSO     ID,
        4             POS,
        POS4          DEZENA
   FROM FAT_SORTEIOS
   UNION ALL
SELECT  Q25,
        Q50,
        Q100,
        Q200,
        Q400,
        DATABDSORTEIO DATABDSORTEIO,
        ICONCURSO     ID,
        5             POS,
        POS5          DEZENA
   FROM FAT_SORTEIOS
   UNION ALL
SELECT  Q25,
        Q50,
        Q100,
        Q200,
        Q400,
        DATABDSORTEIO DATABDSORTEIO,
        ICONCURSO     ID,
        6             POS,
        POS6          DEZENA
   FROM FAT_SORTEIOS
/* VW_DEZENAS_SORTEADAS(Q25,Q50,Q100,Q200,Q400,DATABDSORTEIO,ID,POS,DEZENA) */;
CREATE VIEW VW_ACHA_PROXIMO
-- Tabela..: VW_ACHA_PROXIMO
--
-- Objetivo:
--           View intermediária usada no processo de ETL para calcular a
--           distância (ATRASO) ente as ocorrências de cada DEZENA.
--           OK - View intermediária usada no processo de ETL para 
--           calcular a distância (ATRASO) ente as ocorrências de cada uma
--           das DEZENA, até o CONCURSO corrente.
--
-- Depende.: TABELA DIM_DEZENA VIEW VW_FATO_DEZENAS.
--
--
(
   SEQ,                
    -- Identifica univicamente cada uma das ocorrências desta TABELA.
   DEZENA,             
   -- Identifica univicamente cada ocorrência de DEZENA.
   CONCURSO,           
   -- Identifica univicamente cada ocorrência de concurso.
   DATABDSORTEIO,      
   -- Data em que a DEZENA ocorreu ou data do CONCURSOS.
   VEZES,              
   -- Número de VEZES em que a DEZENA já apareceu, até este CONCURSO.
   POS                 
   -- Posição (ordem) nos CONCURSOS onde a DEZENA já apareceu, no
   -- CONCURSOS realizados até a última carga. 
)
AS
SELECT 
       ROW_NUMBER () OVER ( 
            ORDER BY X.DEZENA,
                     X.CONCURSO,
                     X.DATABDSORTEIO,
                     X.VEZES,
                     X.POS

       )                                  SEQ,
       X.DEZENA,
       X.CONCURSO,
       X.DATABDSORTEIO,
       X.VEZES,
       X.POS
FROM (SELECT ''||A.DEZENA                 DEZENA,
             A.CONCURSO                   CONCURSO,
             A.DATABDSORTEIO              DATABDSORTEIO,
             A.VEZES                      VEZES,
             A.POS                        POS
        FROM VW_FATO_DEZENAS              AS A
       WHERE A.DATABDSORTEIO              IS NOT NULL
      UNION ALL
      SELECT   ''|| B.SG_DEZENA           DEZENA,
               0                          CONCURSO,
               DATE('1996-03-11')         DATABDSORTEIO,
               0                          VEZES,
               0                          POS
          FROM DIM_DEZENA                   AS B
      ORDER BY 1 , 2 , 3 )                  AS X
/* VW_ACHA_PROXIMO(SEQ,DEZENA,CONCURSO,DATABDSORTEIO,VEZES,POS) */;
CREATE VIEW VW_DEZENAS_SORTEADAS_ATRASOS
--
-- View.....: VW_DEZENAS_SORTEADAS_ATRASOS
--            VW_DEZENAS_SORTEADAS_ATRASOS
-- Objetivo.: .
--
-- 2016/01/20 Criada.
--
-- 2018/12/20 Corrção para simplificar a view e funcioar com o HSQLDB.
--            Adicionado comentários.
--
-- Depende..:
--            VIEW   VW_ACHA_PROXIMO     - Usada na consulta ????.
--
--
(
  DE,
  ATE,
  DEZENA,
  CONCURSODE,
  CONCURSOATE,
  DATAINICIAL,
  DATAFINAL,
  DIAS_ATRASO,
  DIST_CONCURSOS,
  VEZES
) AS
SELECT B.SEQ                                           DE,
       ifnull(C.SEQ     , B.SEQ)                       ATE,
       ifnull(C.DEZENA  , B.DEZENA)                    DEZENA,
       CASE
          WHEN (B.CONCURSO = 0) then 1
          ELSE B.CONCURSO
        END                                            CONCURSODE,
       C.CONCURSO                                      CONCURSOATE,
       B.DATABDSORTEIO                                 DATAINICIAL,
       ifnull(C.DATABDSORTEIO,date('now'))             DATAFINAL,
       julianday(ifnull(C.DATABDSORTEIO,date('now'))) -
       julianday(B.DATABDSORTEIO)                      DIAS_ATRASO,
       ifnull(C.CONCURSO,B.CONCURSO) - B.CONCURSO      DIST_CONCURSOS,
       ifnull(C.VEZES, B.VEZES)                        VEZES
       FROM VW_ACHA_PROXIMO AS B
  LEFT JOIN VW_ACHA_PROXIMO AS C
         ON B.DEZENA = C.DEZENA
        AND C.SEQ = B.SEQ +1
ORDER BY 2, 1, 5
/* VW_DEZENAS_SORTEADAS_ATRASOS(DE,ATE,DEZENA,CONCURSODE,CONCURSOATE,DATAINICIAL,DATAFINAL,DIAS_ATRASO,DIST_CONCURSOS,VEZES) */;
CREATE VIEW VW_PARA_INDEX
AS 
select C.ULTIMO                                   ULTIMO,  
       strftime("%d/%m/%Y",B.DATA )               DATA, 
       case  
           when strftime("%w", B.DATA) = '0' then 'Domingo'  
           when strftime("%w", B.DATA) = '1' then 'Segunda-Feira' 
           when strftime("%w", B.DATA) = '2' then 'Terça-Feira' 
           when strftime("%w", B.DATA) = '3' then 'Quarta-Feira'  
           when strftime("%w", B.DATA) = '4' then 'Quinta-Feira'  
           when strftime("%w", B.DATA) = '5' then 'Sexta-Feira'  
           when strftime("%w", B.DATA) = '6' then 'Sábado'  
       end                                        DIA,
       DEZE1                                      P1,
       DEZE2                                      P2,
       DEZE3                                      P3,
       DEZE4                                      P4,
       DEZE5                                      P5,
       DEZE6                                      P6
  from ( select MAX(A.CONCURSO) ULTIMO from CONCURSOS as A) AS C,
       CONCURSOS AS B
 where B.CONCURSO = C.ULTIMO
/* VW_PARA_INDEX(ULTIMO,DATA,DIA,P1,P2,P3,P4,P5,P6) */;
CREATE TABLE AGREG_DIST_ATRASOS (
    DEZENA                  char(2)      not null,
    FAIXA_DE_DIAS_ATRASDOS  VARCHAR(15)  NOT NULL,
    QTD_GRUPO               int          NOT NULL,
    MIN_GRUPO               int          NOT NULL,
    MED_GRUPO               int          NOT NULL,
    MAX_GRUPO               int          NOT NULL,
    DESVPADRAO_GRUPO        int          NOT NULL
);
CREATE VIEW VW_TAM_BOCA (DEZENA, TAM_BOCA) 
as 
 select K.DEZENA, 
        (0 + substr(K.JUNTA,4)) TAM_BOCA
  from (
        select J.DEZENA, 
               max(printf("%02d-%02d", J.CICLOS , J.TAM_BOCA)) JUNTA
          from (
        select 
                       X.DEZENA,
                       X.CICLO_SAIDAS                CICLOS,
                       X.QTD                         QTD_SAIDA,
                       Y.QUINZENA_ATRASOS,
                       sqrt(
                           ((X.QTD - Y.QUINZENA_ATRASOS) *
                           (X.QTD - Y.QUINZENA_ATRASOS)) 
                       )                             TAM_BOCA
                 from (      
                    select                 DEZENA,
                         (CONCURSO/50)    CICLO_SAIDAS,
                         count(1)         QTD
                    from dez_ocorrencias
                    group by 1,2 
                       ) as X,
                       (
                    select B.DEZENA,
                           B.CICLO_ATRASOS                            CICLO_ATRASOS,
                           printf("%d", ((1.0*B.DIAS_ATRASOS)/15.0))  QUINZENA_ATRASOS
                      from (       
                              select  DEZENA,
                                                (A.CONCURSO/50)  CICLO_ATRASOS,
                                                sum(A.ATRASO)   DIAS_ATRASOS
                                          from EST_ATRASOS AS A
                            group by 1,2
                            ) AS B
                         ) as Y
                   where X.DEZENA = Y.DEZENA
                     and X.CICLO_SAIDAS = Y.CICLO_ATRASOS
               ) J
        group by 1
      ) K
/* VW_TAM_BOCA(DEZENA,TAM_BOCA) */;
CREATE TABLE AGREG_DIS_DEZ_POSICAO (
    DEZENA           CHAR(2) NOT NULL PRIMARY KEY,
    QTD1             INT NOT NULL,
    QTD2             INT NOT NULL,
    QTD3             INT NOT NULL,
    QTD4             INT NOT NULL,
    QTD5             INT NOT NULL,
    QTD6             INT NOT NULL,
    TOTAL_DEZENA     INT NOT NULL
);
CREATE VIEW VW_QTD_OCOR_FAIXA_DEZENAS AS
    SELECT X.DEZENA,
           X.QTD1,
           X.QTD2,                                                       
           X.QTD3,                                                       
           X.QTD4,                                                       
           X.QTD5,                                                       
           X.QTD6,
           X.TOTAL_DEZENA,
           printf("%6.3f", ((1.0 * X.QTD1) / (1.0 * X.TOTAL_DEZENA)))            PCT_POS1,
           printf("%6.3f", ((1.0 * X.QTD2) / (1.0 * X.TOTAL_DEZENA)))            PCT_POS2,
           printf("%6.3f", ((1.0 * X.QTD3) / (1.0 * X.TOTAL_DEZENA)))            PCT_POS3,
           printf("%6.3f", ((1.0 * X.QTD4) / (1.0 * X.TOTAL_DEZENA)))            PCT_POS4,
           printf("%6.3f", ((1.0 * X.QTD5) / (1.0 * X.TOTAL_DEZENA)))            PCT_POS5,
           printf("%6.3f", ((1.0 * X.QTD6) / (1.0 * X.TOTAL_DEZENA)))            PCT_POS6,
           W.MEDIA_SOMAS                                                         MEDIA_SOMAS,
           printf("%6.3f", ((1.0 * X.QTD1) / (1.0 * Z.TOTAL_CONCURSOS)))         PCT1_CONCURSOS,
           printf("%6.3f", ((1.0 * X.QTD2) / (1.0 * Z.TOTAL_CONCURSOS)))         PCT2_CONCURSOS,
           printf("%6.3f", ((1.0 * X.QTD3) / (1.0 * Z.TOTAL_CONCURSOS)))         PCT3_CONCURSOS,
           printf("%6.3f", ((1.0 * X.QTD4) / (1.0 * Z.TOTAL_CONCURSOS)))         PCT4_CONCURSOS,
           printf("%6.3f", ((1.0 * X.QTD5) / (1.0 * Z.TOTAL_CONCURSOS)))         PCT5_CONCURSOS,
           printf("%6.3f", ((1.0 * X.QTD6) / (1.0 * Z.TOTAL_CONCURSOS)))         PCT6_CONCURSOS,
           Z.TOTAL_CONCURSOS,
           printf("%6.3f", ((1.0 * X.TOTAL_DEZENA) / (1.0 * Z.TOTAL_CONCURSOS))) PCT_POR_CONC
      FROM AGREG_DIS_DEZ_POSICAO X,
           (
              SELECT count(1) TOTAL_CONCURSOS
                FROM CONCURSOS
           ) Z,
           (
              SELECT avg((1.0+K.TOTAL_DEZENA)) MEDIA_SOMAS
                FROM AGREG_DIS_DEZ_POSICAO K
           ) W
/* VW_QTD_OCOR_FAIXA_DEZENAS(DEZENA,QTD1,QTD2,QTD3,QTD4,QTD5,QTD6,TOTAL_DEZENA,PCT_POS1,PCT_POS2,PCT_POS3,PCT_POS4,PCT_POS5,PCT_POS6,MEDIA_SOMAS,PCT1_CONCURSOS,PCT2_CONCURSOS,PCT3_CONCURSOS,PCT4_CONCURSOS,PCT5_CONCURSOS,PCT6_CONCURSOS,TOTAL_CONCURSOS,PCT_POR_CONC) */;
CREATE TABLE AGREG_DEZ_DIA_SEMANA (
    DEZENA           CHAR(2) NOT NULL,
    DIA              VARCHAR(30) NOT NULL,
    QTD              INT NOT NULL,
    PRIMARY KEY (DEZENA, DIA)
);
CREATE VIEW VW_CONTA_PARES as 
select count(1) QTD, PARES
  from (
        select deze1 || '-' || DEZE2 PARES
          from CONCURSOS
        union all
        select deze2 || '-' || DEZE3 PARES
          from CONCURSOS
        union all
        select deze3 || '-' || DEZE4 PARES
          from CONCURSOS
        union all
        select deze4 || '-' || DEZE5 PARES
          from CONCURSOS
        union all
        select deze5 || '-' || DEZE6 PARES
          from CONCURSOS
       )
  group 
     by 2
  order
     by 1 desc
/* VW_CONTA_PARES(QTD,PARES) */;
CREATE TABLE AGREG_QTD_TRIOS (
    QTD              INT NOT NULL,
    TRIO             CHAR(8) NOT NULL,
    PRIMARY KEY (TRIO)
);
CREATE TABLE AGREG_DEZ_DIA_MES
(
     DEZENA           CHAR(2) NOT NULL,
     DIA_MES          CHAR(2) NOT NULL,
     QTD              INT     DEFAULT 0,
     PRIMARY KEY (DEZENA, DIA_MES)
);
CREATE TABLE AGREG_PARAM_SOMA_DEZENAS(
  TP,
  S5,
  S4,
  S3,
  S2,
  S1,
  S0,
  SD
);
CREATE VIEW VW_DISTANCIA_DEZENAS
as
select * FROM (
    select 4 QTD,
           CONCURSO,    
           printf("%02d-%02d-%02d-%02d-%02d-%02d",
           DEZE1 ,
           DEZE2 - DEZE1 ,
           DEZE3 - DEZE2 ,       
           DEZE4 - DEZE3 ,       
           DEZE5 - DEZE4 ,      
           DEZE6 - DEZE5 ) DISTANCIAS
      from CONCURSOS
)
where DISTANCIAS like '%01-01-01-01%'
union all 
select * FROM (
    select 3 QTD,
           CONCURSO,
           printf("%02d-%02d-%02d-%02d-%02d-%02d",
           DEZE1 ,
           DEZE2 - DEZE1 ,
           DEZE3 - DEZE2 ,       
           DEZE4 - DEZE3 ,       
           DEZE5 - DEZE4 ,      
           DEZE6 - DEZE5 ) DISTANCIAS
      from CONCURSOS
)
where DISTANCIAS like '%01-01-01%'
union all 
select * FROM (
    select 2 QTD,
           CONCURSO,
           printf("%02d-%02d-%02d-%02d-%02d-%02d",
           DEZE1 ,
           DEZE2 - DEZE1 ,
           DEZE3 - DEZE2 ,       
           DEZE4 - DEZE3 ,       
           DEZE5 - DEZE4 ,      
           DEZE6 - DEZE5 ) DISTANCIAS
      from CONCURSOS
)
where DISTANCIAS like '%01-01%'
/* VW_DISTANCIA_DEZENAS(QTD,CONCURSO,DISTANCIAS) */;
CREATE VIEW VW_PARA_EXCEL as 
SELECT 
        CONCURSO , 
        DATA     , 
        DEZE1    D1, 
        DEZE2    D2, 
        DEZE3    D3, 
        DEZE4    D4, 
        DEZE5    D5, 
        DEZE6    D6, 
        TUDO     , 
        SEMANA   , 
        SOMA     , 
        '"'|| ES1 || '"'  ES1, 
        ESQ1     , 
        '"'|| ES2 || '"'  ES2, 
        ESQ2     , 
        '"'|| ES3 || '"'  ES3, 
        ESQ3     , 
        '"'|| ES4 || '"'  ES4, 
        ESQ4     , 
        '"'|| ES5 || '"'  ES5, 
        ESQ5     , 
        '"'|| ES6 || '"'  ES6, 
        ESQ6,
        printf("%02d-%02d-%02d-%02d-%02d-%02d",
        DEZE1 ,
        DEZE2 - DEZE1 ,
        DEZE3 - DEZE2 ,       
        DEZE4 - DEZE3 ,       
        DEZE5 - DEZE4 ,      
        DEZE6 - DEZE5 ) DISTANCIAS      
   FROM CONCURSOS
/* VW_PARA_EXCEL(CONCURSO,DATA,D1,D2,D3,D4,D5,D6,TUDO,SEMANA,SOMA,ES1,ESQ1,ES2,ESQ2,ES3,ESQ3,ES4,ESQ4,ES5,ESQ5,ES6,ESQ6,DISTANCIAS) */;
