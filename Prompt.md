# O Prompt 
Trata-se de um exempo padrão de solicitação de tarefas às IAs, para testar o comportamento e as entregas de cada IA.

# o Pedido
Escreva uma especificação completa, não os códigos fontes, após analisar os arquivos: 
- O banco de dados SQLite 3, mamtido na URL [https://megapower-loterias.com.br/dados/MegaPower.db](https://megapower-loterias.com.br/dados/MegaPower.db) e,
- O documento de [Especificação do banco de dados](https://github.com/nosredna33/DesafioIAs/blob/8db640eab318ca0edde2acb0a679ce3bc9a7686c/Documentacao_do_Bancode_Dados_MegaPower.md)
informada, sem gerar arquivos intermediários não solicitados, com o nome Especificacao.md, gerando para novas atualizações o nome Especificacao_V00n conforme esta declaração de escopo:

1. Quero um programa, escrito linguagem em Java, que seja capaz de gerar sugestões de jogos, cujo o número de apostas geradas seja informado como parâmetros, na forma POSIX. 

2. O programa deverá exibar as mensagens usando data, hora e valores, com NLS compatível com a do ambiente operacional, ou Português Brasil, caso seja impossível detectar automaticamente.

3. As apostas sugeridas para o próximo concurso da *Mega-Sena* deverão ser calculadas baseados nas estatísticas dos sorteios disponíveis no site especilizado [*_Mega Power- Loterias_*](https://megapower-loterias.com.br/app/index.php).

4. As apostas sugeridas, no final, serão as de maior ranking, conforme a soma da pontuação alcançada na soma de todas as estratégias para as quais elas forem submetidaspara cada avaliação.

5. As estratégias são implementações de uma classe, baseada numa classe abstrata ou de uma interface.

6. As apostas geradas e submetidoas a cadeia de estrategias poderão ser de uma das três formas:
   
   6.1. Informados em parâmetro POSIX, na chamada do programa com o número de apostas geradas aleatoriamente.
   
   6.2. Informados em parâmetro POSIX, na chamada do programa, com o número de apostas obtidas com base na escolha aleatória do índice lexicografico entre as 50.063.860 combinações possíveis, onde o indice 1 representa a aposta \[01 - 02 - 03 - 04 - 05 - 06\] e de indice 50.063.860 representa a aposta \[55 - 56 - 57 - 58 - 59 - 60\].
   
   6.3. Informados em parâmetro POSIX, na chamada do programa, que indica que toas combinações serão avaliadas (submetidas à cadeia de estratégias em busca de ranking) da combinação  \[01 - 02 - 03 - 04 - 05 - 06\] à \[55 - 56 - 57 - 58 - 59 - 60\].

8. Para tanto este programa deverá ser Multithread e usar pool dr conexões com o SQLITE 3, para evitar gargalos entre as threads.

9. Como eu ainda não expus a API para consulta do Site [Mega Power Loterias](https://megapower-loterias.com.br/), vou expor uma amostra do banco de dados no site, em formato SQLITE 3, com as principais estatísticas em tabelas e views, que sinplifica seu trabalho ao invés de fazer parse em textos html do site. O banco de dados, em formato SQLITE 3, está em [https://megapower-loterias.com.br/dados/MegaPower.db](https://megapower-loterias.com.br/dados/MegaPower.db).

10. Este banco de dados contém todas as informações granulares e agregadas sobre todos os sorteios já realizados, desde o primeiro sorteio da Mega-Sena:
- **DEZ_OCORRENCIAS** : Contem informação granulares da ocorrência de cada dezena, desde o primeiro sorteio;

- **AGREG_DIS_DEZ_POSICAO** : Mantém uma linha oara cada dezena exibindo a quantidade de ocorrências da dezena, por posição no sorteio;

- Além destas citadas se puder documentar as demais eu agradeço!

10. Os dados para análises estatísticas estão disponíveis para download em [https://megapower-loterias.com.br/dados/MegaPower.db](https://megapower-loterias.com.br/dados/MegaPower.db).

11. A abordagem inicial simplista sobre as estratégias não impede a criação de estratégias mais sofisticada em Java que incluem:
     - **Ranking gaussiano** das apostas baseado em múltiplos critérios.
     - **Análise de transição de estados** usando a tabela EST_MUD_ESTADO
     - **Probabilidades condicionais** por posição baseadas no histórico de ocorrências.
     - **Sistema de scoring mais robusto** com pesos estatísticos, e
     - **Outras que Julgar interessantes**

12. Com base no resultado  do último sorteio analisar o desempenho das nossas sugestões de apostas, mantidas no banco de dados, na tabela **FAT_APOSTAS**, persistidas juntamente com a data da aposta, a data do sorteio, o concurso, a soma do ranking de estratégias, e a comparação do ranking do resultado real do último concurso.

13. Como requisitos essenciais da aplicação fazem necessários:
    - Pool de Conexões: Uso do Apache Commons DBCP para gerenciar conexões, evitando _"host busy"_ com limite de conexões ativas; Timeout configurável (5 segundos);
    - Paralelização: Cálculos estatísticos distribuídos em múltiplos núcleos;
    - Streams paralelos para processamento eficiente;
    - ExecutorService para gerenciamento de threads;
    - Sistema de Retry: Tentativas automáticas para falhas temporárias;
    - Backoff exponencial: entre tentativas;
    - Failover: após 3 tentativas;
    - Cache Inteligente: Armazenamento local de scores calculados; Validade de 1 minuto para atualizações;
    - Gerenciamento de Recursos: Fechamento adequado de conexões e threads; AwaitTermination para desligamento gracioso;
    - Tratamento robusto de exceções.

