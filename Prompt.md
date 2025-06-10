1. Quero um programa, escrito linguagem em Java, que seja capaz de gerar sugestões de jogos, cujo o número de apostas geradas seja informado como parâmetros, na forma POSIX. 

2. O programa deverá exibar as mensagens usando data, hora e valores, com NLS compatível com a do ambiente operacional, ou Português Brasil, caso seja impossível detectar automaticamente.

3. As apostas sugeridas para o próximo concurso da *Mega-Sena* deverão ser calculadas baseados nas estatísticas dos sorteios disponíveis no site especilizado [*_Mega Power- Loterias_*](https://megapower-loterias.com.br/app/index.php).

4. As apostas sugeridas, no final, serão as de maior ranking, conforme a soma da pontuação alcançada na soma de todas as estratégias para as quais elas forem submetidaspara cada avaliação.

5. As estratégias são implementações de uma classe, baseada numa classe abstrata ou de uma interface.

6. As apostas geradas e submetidoas a cadeia de estrategias poderão ser de uma das três formas:
   6.1. Informados em parâmetro POSIX, na chamada do programa com o número de apostas geradas aleatoriamente.
   6.2. Informados em parâmetro POSIX, na chamada do programa, com o número de apostas obtidas com base na escolha aleatória do índice lexicografico entre as 50.063.860 combinações possíveis, onde o indice 1 representa a aposta \[01 - 02 - 03 - 04 - 05 - 06\] e de indice 50.063.860 representa a aposta \[55 - 56 - 57 - 58 - 59 - 60\].
   6.3. Informados em parâmetro POSIX, na chamada do programa, que indica que toas combinações serão avaliadas (submetidas à cadeia de estratégias em busca de ranking) da combinação  \[01 - 02 - 03 - 04 - 05 - 06\] à \[55 - 56 - 57 - 58 - 59 - 60\].

7. Para tanto este programa deverá ser Multithread e usar pool dr conexões com o SQLITE 3, para evitar gargalos entre as threads.

8. 
9. 

Os dados para análises estatísticas estão disponíveis para download em [https://megapower-loterias.com.br/dados/MegaPower.db](https://megapower-loterias.com.br/dados/MegaPower.db).
