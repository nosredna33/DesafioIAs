Ferramentas de inteligência artificial (IA) vêm causando impacto no mundo da tecnologia desde o lançamento do ChatGPT em novembro de 2022. Essas ferramentas variam muito em forma e função, mas uma constante entre elas é que elas devem mudar muito os fluxos de trabalho e a eficiência de seus resultados, em especial no desenvolvimento de software.

No entanto, para fazer uso eficaz dessas ferramentas ainda é bastante desafiador, principalmente sem entender como elas funcionam e como interagir melhor com cada uma elas. A maioria dessas ferramentas – especialmente aquelas baseadas nos  modelos Generative Pretrained Transformer (GPT) da OpenAI – são  modelos de linguagem de grande porte  (LLMs), que funcionam essencialmente oferecendo um prompt (campo para entrada do texto de comandos) e prevendo qual recurso tem maior probabilidade de seguir esse prompt, com base nos dados com os quais foi treinado.

Os modelos da OpenAI foram treinados com uma  enorme quantidade de dados , incluindo informações de engenharia de software, codificação e design de sistemas. Assim, as IAs construídas com esses modelos podem responder às suas perguntas nessas e em muitas outras áreas.

Ferramentas de IA como  o GitHub Copilot , baseado no  modelo OpenAI Codex, Llama Coder, SQLAI e o ChatGPT são amplamente utilizadas por desenvolvedores para ajudá-los a escrever código e resolver problemas técnicos. No entanto, todas essas estas ferramentas apresentam limitações quando se trata de lidar com desafios maiores de design e implementação de softwares, devido à limitações de contexto.

É aqui que ferramentas de ponta, normalmente pagas, entram em ação. A maioria das Ferramentas de IA de ponta são  desenvolvidas com base no GPT-3.5 e GPT-4 que visa levar fluxos de trabalho aprimorados por IA para o design de software de nível superior, permitindo gerar uma base de código inteira a partir de um prompt específico. Será?

Testei varias delas num esforço que levou muitas horas de pesquisa e algumas trocas de insultos, evidentemente, da minha parte, pois, todas elas sempre foram cortezes e algumas, elegantemente, apresentaram alternativas ás suas próprias limitações.

Agora, a solução mágica que os desenvolvedores estão esperando, ainda está muito longe de ser alcançada com as IAs como estão atualmente. Neste artigo, você verá por si mesmo.

O desafio é entregar um prompt, com uma especificação, o mais detalhada o possível, de uma aplicação, juntamente com um banco de dados, em formato SQLite 3, uma especificação da estrutura do banco e a DDL de criação do banco.

O objetivo é obter uma, que possamos testar usando o mínimo de recursos ou Wamp ou Lamp para testar ou algum provedor de baixo cu custo para testar.
 iterativamente uma especificação para uma API RESTful CRUD simples que a IA usará para gerar a base de código. Você poderá ver os pontos fortes e as limitações dessa abordagem e aprender sobre as armadilhas que você deve conhecer antes de incorporar esse tipo de IA aos seus fluxos de trabalho.