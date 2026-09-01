# Pitch: Janela

Janela é um app em Flutter que responde, numa tela, quais salas, laboratórios e auditórios do campus estão livres agora e até que horário, deixa o aluno reservar o intervalo pelo celular, e devolve à coordenação um painel de demanda declarada. Quem usa é o aluno. Quem assina o contrato é a instituição, na figura da coordenação de curso ou da operação de campus. O produto é software para universidades em geral, e a FIAP entra como cliente piloto, não como dona do produto.

Rogério Deligi Ferreira Filho (RM561942) e Maria Fernanda Garavelli Dantas (RM562686) · Checkpoint 4 · Cross-Platform Application Development · FIAP, 2º semestre de 2026

Este documento detalha a seção `e)` do [README](../README.md). Todo número aqui tem fonte citada. Onde a fonte não existe, é única ou não é primária, a marcação de incerteza aparece no próprio ponto de uso e não numa nota de rodapé. Nenhum número de tamanho de mercado aparece, porque nenhum foi verificado.

---

## 1. Por que este app existiria no mercado

O único registro confiável de uso de espaço num campus é a grade horária, e a grade só sabe onde tem aula marcada. O que sobra entre duas aulas, o que vaga quando um professor falta e o que fica livre nos primeiros horários da noite não aparece em lugar nenhum. O aluno resolve isso a pé: sobe andar por andar, olha pela janela da porta, e quando finalmente acha uma sala vazia ainda não sabe se entra turma ali em dez minutos.

A observação que sustenta o produto no mercado é outra, e é mais forte que a dor: o dado que resolveria isso já existe dentro da instituição. Ele está na grade horária, dentro do Sistema de Informação do Estudante ou do ERP acadêmico. A prova de que existe são os apps de descoberta de sala vazia que universidades e alunos já construíram, porque eles só conseguem funcionar lendo exatamente esse dado. Falta a última milha entre o dado que a administração já tem e a ação que o aluno precisa executar.

Janela existe para fechar essa milha. Não é um sistema de agendamento novo e não disputa a alocação de turmas, que é problema já resolvido por fornecedor maduro. É a camada de acesso do aluno sobre um inventário que a instituição já conta.

---

## 2. O que já existe

A lacuna não é ausência de software. Existe muito, é maduro, e parte dele tem app móvel. Cada concorrente abaixo está nomeado com fonte, porque um pitch que finge que o concorrente não existe cai na primeira pergunta de quem conhece a categoria.

| Produto | O que é | Desenhado para quem | Como cobra | Onde não chega |
|---|---|---|---|---|
| **Skedda** | Agendamento de espaços com planta interativa, regras de permissão, sincronização com Microsoft 365 e Google Workspace, apps iOS e Android e painel de utilização. Tem página de solução dedicada a universidades | Gestão de espaço de trabalho híbrido, estendida ao campus. Lista docentes e funcionários, alunos e administradores como perfis de uso | Por espaço gerenciado, faturado anualmente, usuários e reservas ilimitados. EUA e Canadá: Plus a partir de US$249/mês, Premier a partir de US$349/mês. EMEA e APAC: Starter US$99, Plus US$149, Premier US$199. O base inclui 15 a 45 espaços conforme o plano, e espaço extra custa US$4,99. Enterprise e AllBooked sob consulta | A modelagem é de espaço corporativo, não de grade acadêmica. Nada na página indica leitura da grade horária de turmas para inferir sala ociosa entre aulas, que é o dado que interessa ao aluno. O piso de US$249/mês por poucas dezenas de espaços é alto para uma unidade que só quer liberar salas de estudo |
| **Robin** | Plataforma unificada de local de trabalho: reserva de mesa e de sala, gestão de visitantes e analytics de ocupação | Organizações com 500 funcionários ou mais, um terço deles usando o escritório regularmente, com múltiplos andares ou prédios. A página menciona preço especial para universidades e espaços em campus | **[NÃO VERIFICADO]** junto ao fornecedor. A página não exibe valor, pede formulário e diz que o preço é montado por organização. Agregadores comerciais estimam US$3 a US$12 por funcionário por mês, mas é estimativa de terceiro, **[FONTE ÚNICA em termos de tier]**, com valores divergentes entre agregadores | Preço opaco e piso de 500 funcionários empurram a venda para o modo enterprise, com ciclo longo. O usuário modelado é o funcionário que escolhe mesa, não o aluno que precisa de sala por noventa minutos entre duas aulas |
| **Accruent EMS** (Classroom Scheduling e app Direct Spaces) | Suíte de agendamento acadêmico: aloca turmas automaticamente por tamanho, layout de assento e preferência do docente, integra com o SIS para importar turmas e professores, detecta conflito e reserva duplicada, e reporta utilização. Inclui o app móvel Direct Spaces, com reserva de sala e de assento. Presença declarada em mais de 75 países | O registro acadêmico e a redução do trabalho administrativo | **[NÃO VERIFICADO]**, só demonstração e contato | Entra na instituição como módulo de uma suíte corporativa de facilities, com venda enterprise e preço sob consulta, o que exclui a unidade que quer resolver só o problema do aluno. O aluno é usuário secundário de um sistema otimizado para outra pessoa |
| **CollegeNET Series25** (Schedule25, 25Live, X25, LYNX) | Suíte de agendamento de campus: alocação automática de turmas, gestão de eventos e recursos entre departamentos, analytics de utilização e integração bidirecional em tempo real com o SIS. Mais de 100 instituições declaradas | A administração acadêmica. O caso citado da University of Tennessee Knoxville mede o próprio sucesso em quase 80% de redução do tempo administrativo | **[NÃO VERIFICADO]** | A métrica de valor é hora de trabalho administrativo poupada, não acesso do aluno ao espaço. Não há app móvel citado na página, e nada indica que o aluno seja um usuário previsto |
| **Springshare LibCal** | Reserva de sala, de assento em laboratório de informática, empréstimo de equipamento, agendamento de atendimento e gestão de evento. Tem autoatendimento, interface móvel, limite de reserva, tempo de intervalo entre reservas, regras de capacidade, check-in e função quiosque. Declara 7.500 instituições, 106 países e 250.000 usuários bibliotecários | O aluno, por desenho e não por extensão, dentro do escopo da biblioteca | **[NÃO VERIFICADO]** | O escopo é o espaço da biblioteca, porque o dono do contrato é a biblioteca e não a instituição. A sala de aula ociosa, o laboratório de curso e o auditório ficam fora, ou seja, a metade do campus onde o aluno mais precisa de sala continua sem cobertura |
| **Modo Campus** (Modo Labs) | Plataforma de app de campus e portal: integração com LMS e SIS (horário, notas, financiamento), hub de serviços, carteirinha digital, wayfinding, mensagens e agente de IA para suporte ao aluno. Penn State, Notre Dame e Princeton entre os clientes citados | A experiência do aluno no campus. É o app onde o aluno já vive | **[NÃO VERIFICADO]** | Reserva de sala e de mesa aparece como recurso do Modo Workplace, o produto de escritório para funcionário, e não do Modo Campus **[FONTE ÚNICA]**. No app do aluno, o espaço é ponto de interesse no mapa, com navegação passo a passo até estações de trabalho reserváveis, sem agendar nada |
| **Apps de descoberta de sala vazia**: UofT Synchronous Space Finder, SpacePlusU, illiniSpots (UIUC), StudySpace | Cruzam a grade horária com o inventário de salas e mostram quais salas não têm aula. Alguns com mapa, filtro por prédio, favoritos e recomendação segundo o horário de aula do próprio usuário. Alguns oficiais da universidade, outros feitos por aluno | O aluno. É o único grupo do levantamento cujo usuário primário é ele | Não cobram. Gratuitos, sem compra interna e sem modelo de receita | Mostram disponibilidade e não reservam. Sem reserva, duas pessoas chegam na mesma sala e nenhuma tinha garantia. São de campus único, sem contrato, sem responsável institucional e sem manutenção garantida quando o aluno que escreveu o app se forma |
| **Calenda Smartrooms** (Brasil) | Agendamento de salas com mapa interativo, PWA para iOS e Android, tablet na porta da sala, relatórios de ocupação, regras de aprovação customizáveis e controle de permissão por usuário e grupo. Integra em quatro níveis: SSO Google e Microsoft, calendário do colaborador, Google Meet e Teams, e calendário da sala. FIEMG e PUC Minas entre os clientes citados | O colaborador em sala de reunião corporativa | **Por sala gerenciada**, declarado literalmente no site: cobrança por sala, não por usuário. O valor em reais não é publicado, a página remete a uma calculadora **[FONTE ÚNICA]** | É produto de sala de reunião corporativa. Fala em reunião agendada em menos de trinta segundos, aprovação e ocupação, sem qualquer leitura de grade acadêmica. Sem preço público, não há como comparar valor |
| **TOTVS Educacional** (linha RM) | ERP de gestão educacional que cobre secretaria, docência, matrícula e acompanhamento acadêmico. Traz cadastro de tipos de sala (sala de aula, laboratório, multimeios) e a funcionalidade Reserva de instalações | A secretaria acadêmica. É o incumbente instalado em boa parte das instituições brasileiras de porte, e já detém o dado que Janela precisa: inventário de salas, grade horária, turma e docente | **[NÃO VERIFICADO]** | A reserva é atrelada à aula do professor: relaciona-se aos horários de aula do docente e depende do parâmetro Permite Reserva no cadastro de prédio, bloco e tipo de sala. O modelo mental é alocação de aula, não pedido de espaço por aluno fora de aula. **[FONTE ÚNICA]** e **[NÃO VERIFICADO]** em fonte aberta, porque o artigo de suporte retornou HTTP 403 e o texto veio apenas do snippet de busca |
| **SuperSaaS** | Agendamento online genérico com página de reserva embutível no site da instituição, atribuição automática de sala disponível, confirmação e lembrete automáticos. Tem material específico para escolas e universidades, cobrindo horário de aula, reserva de prova, atendimento estudantil e alocação de sala | Qualquer negócio que marca horário | Por volume de agendamentos futuros. Plano gratuito por tempo indeterminado com 50 agendamentos futuros e 50 usuários registrados, com anúncios na tela. Pagos publicados de US$9/mês a US$180/mês. O site diz literalmente: pague por reservas, não por usuário ou recursos | Não é produto acadêmico. Não lê grade horária, não conhece sala de aula ociosa, não tem app nativo nem identidade da instituição, e a versão gratuita exibe anúncio, o que é inaceitável dentro de canal oficial de uma universidade. Resolve marcação de horário, não descoberta de espaço |
| **Microsoft 365 Room Finder** e recursos de calendário do **Google Workspace** | Reserva de sala embutida na suíte de produtividade: a sala é uma caixa postal de recurso com calendário próprio, e o Room Finder filtra sala disponível por prédio, capacidade e equipamento, puxando disponibilidade do Exchange. O Google Workspace tem mecanismo equivalente no Calendar | O organizador de reunião | Inclusão na assinatura existente sem licença adicional para a caixa postal de recurso: **[NÃO VERIFICADO]** em fonte primária. Sustentado apenas por **[Tier 3, não confirmado em fonte primária]**, blogs de fornecedores de produtos complementares, nenhuma documentação da Microsoft consultada | Reserva sala que foi cadastrada como recurso, e sala de aula normalmente não é cadastrada como recurso porque é governada pela grade acadêmica. Não sabe o que é aula, turma nem semestre, o fluxo é de organizador de reunião convidando participantes, e a experiência móvel é a do cliente de e-mail. Serve à administração, e para o aluno é invisível |
| **UniEspaços** (UESB, Brasil) | App brasileiro de reserva de espaços acadêmicos: salas de aula, auditórios e quadras esportivas, com solicitação por alunos, professores, setores administrativos e comunidade externa. Integra as etapas de solicitação, análise e aprovação, substituindo e-mail e planilha compartilhada. TCC de Pedro Henrique Pinheiro em Sistemas de Informação, orientação do professor Agnaldo Volpe Lovato, desenvolvimento iniciado em 2023.2, piloto no campus de Jequié. Software livre e registrado no INPI, com a UESB como titular. Expansão prevista para Itapetinga e Vitória da Conquista | A comunidade acadêmica inteira, com aprovação institucional no meio do caminho | Não cobra. Software livre | Digitaliza a burocracia em vez de eliminá-la. O pedido passa por análise e aprovação, então não existe decisão em poucos minutos sobre o que já está livre agora |
| **Procedimento manual** (o que está em uso hoje) | Na Escola de Engenharia Mecânica da UFG, reservar laboratório de informática exige e-mail com nome e finalidade no mínimo três dias antes, depende da disponibilidade de sala e de um técnico administrativo para abrir o laboratório, e instalação de software exige antecedência mínima de quinze dias. No CETENS da UFRB, a reserva é feita por formulários separados por categoria de espaço, um para o auditório, um para salas de aula e reunião e um para os laboratórios, com núcleos administrativos distintos | O controle administrativo | Não cobra licença. Custa trabalho de pessoa | Três dias de antecedência não atende grupo que precisa de sala hoje à tarde. São dois casos verificados, e dois casos não são estatística |

### O que cada um faz bem

Isto não é cortesia. Nomear a força do concorrente é o que impede o pitch de prometer algo que já está entregue.

**Skedda** é o concorrente mais forte do recorte. Publica preço, o que é raro na categoria, cobra pela métrica que a instituição controla, tem app móvel próprio e já usa universidade como caso de venda, citando Harvard, MIT, Columbia e Cornell College, com 3,1 milhões de usuários e mais de 7.000 clientes autodeclarados.

**Accruent EMS** é o que mais se aproxima funcionalmente de Janela, porque une o dado da grade horária vindo do SIS com reserva pelo celular no app Direct Spaces. É a razão pela qual a frase "ninguém faz reserva móvel para aluno" está proibida neste pitch.

**CollegeNET Series25** resolve de verdade o problema que escolheu: integração bidirecional em tempo real com o SIS e alocação automática de turmas, com resultado medido em quase 80% de redução do tempo administrativo no caso da UT Knoxville.

**Springshare LibCal** prova que autoatendimento por aluno funciona em escala, e chegou antes nas regras de uso justo onde um projeto novo costuma tropeçar: limite de reserva por pessoa, tempo de intervalo entre reservas e check-in obrigatório já resolvidos.

**Modo Labs** é a plataforma líder de experiência do aluno e, por isso, o canal que Janela teria de disputar ou integrar, porque já é o app onde o aluno vive.

**Calenda** é a evidência mais direta de que o modelo por espaço gerenciado é aceito no mercado brasileiro, e de que universidade privada de porte já paga por reserva de espaço.

**TOTVS Educacional** tem a vantagem estrutural que importa: já detém o inventário de salas e a grade horária. Quem manda no dado começa na frente.

**SuperSaaS** define o piso de preço da categoria. Qualquer proposta comercial acima de US$9/mês tem de justificar por que não basta o SuperSaaS.

**Microsoft 365 Room Finder** é o concorrente que mais mata projeto: custo marginal zero, já instalado, já tem a identidade do aluno no SSO e já é onde o calendário dele mora. Toda proposta de compra vai bater na pergunta "por que não usamos o Outlook?".

**Os apps de descoberta** provam que o dado necessário já existe na instituição, porque saem da grade horária. Eles resolvem exatamente a dor declarada deste projeto, e alguns com mapa e recomendação por horário do usuário.

**UniEspaços** é a prova nacional de que aluno solicitando espaço acadêmico por app funciona, é software livre e está registrado no INPI. Foi ele que obrigou este pitch a abandonar a versão "no Brasil o aluno não consegue reservar nada".

### As três camadas da lacuna

A lacuna é de **para quem** esse software foi desenhado, e ela aparece em três camadas verificáveis.

**Primeira camada: os produtos sérios de espaço acadêmico são produtos de administração, e o próprio material de venda deles admite isso.** O Accruent EMS descreve alocação automática de turma por tamanho de sala, layout de assento e preferência de docente, integração com o SIS e detecção de conflito. O CollegeNET Series25 mede o próprio sucesso em tempo administrativo poupado, com quase 80% de redução no caso da University of Tennessee Knoxville. Nenhum dos dois trata o aluno como usuário primário. O EMS tem o app Direct Spaces com reserva pelo celular, mas ele chega como módulo de uma suíte de facilities, com preço sob consulta e venda enterprise. O aluno é beneficiário de um sistema otimizado para o registro acadêmico.

**Segunda camada: o que de fato existe voltado ao aluno mostra disponibilidade e não reserva.** Os três localizadores de espaço de estudo da University of Toronto exibem disponibilidade em vez de permitir agendamento, e o único agendamento citado no material oficial da própria universidade é o de blocos de duas horas em salas da Hart House. O illiniSpots, na University of Illinois Urbana-Champaign, é feito por aluno, gratuito, e apenas mostra sala vazia. A consequência prática é concreta: sem reserva, duas pessoas chegam na mesma sala e nenhuma tinha garantia. Onde o aluno realmente reserva sozinho, o escopo é a biblioteca, via LibCal, dentro do domínio de quem assina o contrato, e a sala de aula ociosa e o laboratório de curso ficam fora. A plataforma líder de experiência do aluno reforça o diagnóstico: no Modo Labs, reserva de sala e de mesa é recurso do produto de escritório, ao passo que no app de campus a sala é ponto de interesse no mapa.

**Terceira camada, que é a que interessa por ser o cenário local:** no Brasil o incumbente é o ERP acadêmico, e nele a reserva de instalação está atrelada ao horário de aula do docente, dependendo do parâmetro Permite Reserva **[FONTE ÚNICA]**. O modelo mental é alocação de aula, não pedido de espaço por aluno fora de aula. Na ponta, o procedimento real é manual: e-mail com três dias de antecedência e técnico deslocado na UFG, formulário por categoria na UFRB. Existe uma exceção nacional, e ela precisa ser dita em voz alta: o UniEspaços, da UESB, é feito por aluno, é software livre, está registrado no INPI e permite que aluno solicite sala, auditório e quadra. Mas ele integra solicitação, análise e aprovação, isto é, digitaliza a burocracia em vez de eliminá-la.

---

## 3. A lacuna

O que o aluno não consegue fazer hoje é uma coisa específica e pequena: **garantir, pelo celular e em poucos minutos, um espaço que a instituição já sabe que está vazio, sem passar por fila de aprovação.** O dado existe, está na grade horária dentro do SIS ou do ERP, e a prova de que existe são os apps de descoberta, que só conseguem funcionar porque leem exatamente esse dado.

**Honestidade obrigatória, e isso entra no pitch em vez de ser escondido:** a brecha é de posicionamento e de custo de entrada, não de impossibilidade técnica. A Skedda declara atender aluno com app móvel e cita Harvard, MIT e Columbia. O EMS tem reserva móvel. Um ano de trabalho de fornecedor estabelecido fecha essa lacuna funcional. O que sustenta o produto no horizonte deste projeto é o recorte: um app cujo usuário primário é o aluno, que lê a grade acadêmica para saber o que está ocioso, que reserva de verdade em vez de apenas mostrar, com preço público por espaço e piloto de um campus, em vez de módulo de suíte com preço sob consulta.

---

## 4. Por que a instituição pagaria

A resposta não pode ser satisfação do aluno, que não vira linha de orçamento. São três razões, e as três se apoiam em algo verificado.

**Primeiro, porque a instituição hoje não tem o lado da demanda.** Ela compra analytics de utilização (o X25 do Series25, os relatórios do EMS) que dizem quanto espaço ficou ocioso, mas nada diz quantos alunos procuraram espaço e não acharam. Sem demanda reprimida medida, decisão de expansão de campus e de remanejamento de bloco é feita no escuro. É esse número que o painel da coordenação entrega, e ele é demanda declarada, não ocupação medida, porque o check-in ficou fora do MVP. A distinção está declarada dentro do próprio app.

**Segundo, porque o fluxo manual custa trabalho.** E-mail para pessoa nomeada, três dias de antecedência e técnico administrativo deslocado para abrir a sala é exatamente o tipo de custo que os fornecedores administrativos já vendem como economia, só que na ponta do docente e nunca na do aluno.

**Terceiro, porque o preço de entrada dessa camada é baixo em comparação.** O piso público da categoria é US$249/mês para dezenas de espaços na Skedda, e existe concorrente brasileiro cobrando por sala gerenciada e já vendendo para universidade privada de porte.

---

## 5. Modelo de negócio

### Recomendado: SaaS por espaço gerenciado

Assinatura anual proporcional ao número de salas, laboratórios e auditórios habilitados no sistema, com usuários e reservas ilimitados.

A métrica é o inventário físico, que a instituição já conta, já tem em planilha e já entende como custo. O contrato não encarece quando a adoção cresce, o que remove o principal medo do comprador de ed-tech: "mais aluno usando é mais fatura". Permite piloto honesto, porque habilita um andar, mede e expande. E tem preço público de referência, com a Skedda cobrando por espaço gerenciado e publicando Plus a partir de US$249/mês nos Estados Unidos e Canadá, 15 a 45 espaços no base e extra a US$4,99, mais prova de aceitação da métrica no mercado brasileiro, com a Calenda declarando cobrança por sala gerenciada e citando PUC Minas e FIEMG entre os clientes.

Para este nome há um argumento a mais, e ele é bom na apresentação: a unidade de valor é a janela, mas a unidade de cobrança é o espaço, de propósito. Cobrar por janela puniria a instituição por ter tempo livre, que é justamente o assunto do produto.

**O contra tem de ser dito.** A receita não acompanha o valor entregue: um app usado por dez mil alunos em quarenta salas fatura o mesmo que um usado por cinquenta alunos nas mesmas quarenta salas. Cria também incentivo perverso para a instituição cadastrar menos sala do que tem, o que sabota justamente o dado de ocupação que o produto quer vender. E ancora o produto contra concorrente maduro na mesma métrica, onde a comparação de funcionalidades é desfavorável para um projeto de checkpoint.

### O contrato do piloto

Valor fechado por campus, prazo curto, um prédio habilitado, expansão medida por andar. Isso simplifica a compra da universidade, que prefere linha orçamentária previsível a métrica variável, e evita precificar sem histórico. Como modelo permanente não serve, porque campus de porte muito diferente pagando o mesmo valor destrói a negociação com o cliente grande ou a margem com o pequeno.

### A estratégia de entrada

É o que responde "como vocês conseguem o primeiro cliente": freemium bottom-up. A camada de descoberta, ver o que está livre agora, é gratuita para o aluno e adotada espontaneamente. A camada de reserva com garantia, check-in, regra de uso justo, integração com o SIS e relatório de ocupação é vendida à instituição. É assim que os apps de descoberta reais surgiram, e adoção prévia de aluno é a alavanca mais forte numa negociação, porque troca argumento de vendedor por demanda observada.

O risco disso é real e tem de constar. A parte gratuita precisa de dado que a instituição pode simplesmente não publicar, e **se as instituições brasileiras publicam a grade horária em formato consumível por aplicação de terceiro é [NÃO VERIFICADO]**. Sem cooperação, o app vira digitação manual ou raspagem, com risco de desatualização e atrito com a TI. Os precedentes gratuitos citados não faturam nada, e o aluno adotante se forma, então a base evapora a cada ciclo. Serve como narrativa de entrada, não como modelo de receita principal.

### Modelos avaliados e recusados

| Modelo | Por que não é o principal |
|---|---|
| Por aluno ativo (per FTE matriculado) | Penaliza o comprador justamente pelo que dá valor ao produto, e faz a fatura subir sem que o número de salas mude. Numa instituição com trinta mil alunos e cem salas o preço fica absurdo em relação ao custo de operação. É indefensável no piloto, quando só um prédio está no ar |
| Módulo ou integração vendida sobre o ERP incumbente (parceria ou white-label) | É o caminho mais realista de execução, porque resolve acesso ao dado e canal de venda de uma vez. Mas cria dependência total de um terceiro que pode replicar a funcionalidade a custo baixo, e o produto deixaria de ter proposta de valor própria, virando funcionalidade de outro. Vale citar como caminho de escala futura, não como modelo do pitch |
| Open source com receita em implantação, hospedagem e suporte | Cai bem em instituição pública, onde licitação trava SaaS, mas receita de serviço não escala e depende de duas pessoas venderem o próprio tempo. Há precedente livre já publicado na categoria, incluindo o UniEspaços da UESB, o que prova que o preço de referência do software nu é zero |
| Por reserva realizada | Existe e tem preço público (SuperSaaS, US$9 a US$180/mês), mas taxaria exatamente o comportamento que o produto existe para criar, e ancoraria a comparação numa ferramenta de US$9/mês |

---

## 6. Diferencial competitivo

Quatro afirmações, todas verificáveis, nenhuma delas dependendo de negar o que os concorrentes fazem.

1. **O usuário primário é o aluno, por desenho e não por extensão.** Skedda, Robin, EMS, Series25 e Calenda modelam comprador administrativo ou colaborador de escritório. O LibCal modela aluno, mas dentro do escopo da biblioteca.
2. **Lê a grade acadêmica para inferir o que está ocioso, não só o que foi cadastrado como recurso.** É o que separa o produto do Microsoft 365 Room Finder, onde sala governada pela grade não é caixa postal de recurso, e da Skedda, onde nada indica leitura de grade de turmas.
3. **Reserva de verdade, com garantia, em vez de apenas exibir.** É a lacuna exata dos apps de descoberta gratuitos, o illiniSpots e os localizadores da University of Toronto.
4. **Sem fila de aprovação para o caso comum.** É o que separa do UniEspaços, que integra solicitação, análise e aprovação, e do fluxo manual da UFG e da UFRB. Auditório e espaço com autorização continuam precisando de aprovação, e isso está declarado no que ficou fora do MVP.

O nome carrega a afirmação 2. Na gíria acadêmica brasileira, janela é o vão livre na grade de horário, e é essa a unidade que o produto vende, porque a reserva é sempre de um intervalo entre dois usos e nunca da sala inteira.

---

## 7. O que NÃO entra no pitch, porque é falso

Estas frases são tentadoras e todas as quatro estão proibidas. Cada uma tem, ao lado, a evidência que a derruba.

| Frase proibida | Por que é falsa |
|---|---|
| "Ninguém reserva sala pelo celular" | O Accruent EMS tem o app Direct Spaces, com reserva de sala e de assento **[FONTE ÚNICA]** para a existência do app. A Skedda tem apps iOS e Android. A Calenda tem PWA para iOS e Android |
| "No Brasil não existe app de reserva de espaço para aluno" | Existe o UniEspaços, da UESB, software livre, registrado no INPI, em piloto no campus de Jequié, com solicitação por aluno de sala, auditório e quadra |
| Qualquer número de tamanho de mercado (TAM, SAM, SOM, "mercado de X bilhões") | Nenhum número de mercado foi verificado. Nenhuma fonte citável encontrada traz tamanho, receita ou taxa de crescimento do mercado brasileiro de gestão de espaço acadêmico |
| "O aluno da FIAP perde N minutos por dia procurando sala" | A afirmação aparece no README do CP1 desta mesma dupla e nunca foi medida. Não pode ser apresentada como dado. Se o pitch precisar do número, tem de haver coleta própria, e contagem simples com colegas serve desde que declarada como amostra da dupla |

Duas proibições adicionais, mais discretas e igualmente firmes. Não afirmar quanto uma instituição paga hoje por EMS, Series25, LibCal, Modo Labs, Robin, Calenda ou TOTVS Educacional, porque nenhum dos sete publica valor. E não afirmar que os fornecedores estrangeiros não têm cliente universitário no Brasil: os clientes que eles citam são norte-americanos e europeus, o que não é o mesmo que ausência verificada.

---

## 8. Fontes e nível de verificação

Tier 1 é o fornecedor sobre o próprio produto e preço, ou instituição oficial. Tier 2 é projeto de aluno ou loja de aplicativo. Tier 3 é blog de fornecedor interessado, usado só com ressalva explícita.

| Afirmação | Fonte | Tier | Marcação |
|---|---|---|---|
| Skedda cobra por espaço gerenciado. Plus a partir de US$249/mês e Premier a partir de US$349/mês nos EUA e Canadá, Starter US$99, Plus US$149 e Premier US$199 em EMEA e APAC, 15 a 45 espaços no base, extra US$4,99 | skedda.com/pricing | 1 | Verificação cruzada com yarooms.com/blog/desk-booking-software-pricing para Plus e Premier, que é **[Tier 3, não confirmado em fonte primária]** e serve só de corroboração |
| Skedda tem página de solução para universidades, com docentes, alunos e administradores como perfis | skedda.com/solutions/university-scheduling-software | 1 | Verificado |
| Skedda cita Harvard, MIT, Columbia e Cornell College, 3,1 milhões de usuários e mais de 7.000 clientes | skedda.com | 1 | Autodeclaração do fornecedor |
| Robin define o perfil ideal como 500 funcionários ou mais e menciona preço especial para universidades | robinpowered.com/pricing | 1 | Verificado para a política de preço e o perfil-alvo |
| Preço do Robin | Nenhuma fonte primária | Nenhum | **[NÃO VERIFICADO]**. A faixa de US$3 a US$12 por funcionário por mês existe só em agregadores comerciais, com valores divergentes, e é **[FONTE ÚNICA em termos de tier]**. Não entrou como fato |
| Accruent EMS aloca turmas pelo SIS, detecta conflito e tem o app Direct Spaces com reserva de sala e assento. Presença declarada em mais de 75 países | accruent.com/products/ems/classroom-scheduling-software | 1 | **[FONTE ÚNICA]** para a existência do Direct Spaces |
| Preço do Accruent EMS | Não publicado | Nenhum | **[NÃO VERIFICADO]** |
| CollegeNET Series25 integra em tempo real com o SIS, mais de 100 instituições, quase 80% de redução do tempo administrativo na UT Knoxville | collegenet.com/scheduling | 1 | Números autodeclarados pelo fornecedor |
| Preço do CollegeNET Series25 | Não publicado | Nenhum | **[NÃO VERIFICADO]** |
| LibCal tem autoatendimento, limite de reserva, intervalo entre reservas e check-in. Declara 7.500 instituições, 106 países, 250.000 usuários bibliotecários | springshare.com/academic-libraries/libcal | 1 | Números autodeclarados pelo fornecedor |
| Preço do Springshare LibCal | Não publicado | Nenhum | **[NÃO VERIFICADO]** |
| No Modo Labs, reserva de sala e de mesa é recurso do Modo Workplace e não do Modo Campus. No app do aluno o espaço é ponto de interesse no mapa | modolabs.com/features-use-cases-campus-app | 1 | **[FONTE ÚNICA]** para a separação entre Campus e Workplace |
| Preço do Modo Campus | Não publicado | Nenhum | **[NÃO VERIFICADO]** |
| Os localizadores de espaço da University of Toronto exibem disponibilidade sem permitir agendamento, e o único agendamento citado é de blocos de duas horas na Hart House | utoronto.ca/news/looking-study-spot-campus-here-s-where-and-how-find-one-near-you | 1 | Verificado em fonte oficial da universidade |
| illiniSpots é feito por aluno, gratuito e apenas exibe sala vazia | illinispots.com | 2 | Verificado como projeto de aluno |
| StudySpace corrobora localizador sem reserva | Descrição na App Store | 2 | Corroboração apenas. Descrição de loja de aplicativo é material promocional do próprio autor do app, então vale como reforço e nunca como fonte única de nenhum fato |
| Calenda Smartrooms cobra por sala gerenciada, não por usuário, com valor em reais não publicado. FIEMG e PUC Minas entre os clientes citados | calenda.com.br/smartrooms | 1 | **[FONTE ÚNICA]** |
| TOTVS Educacional tem cadastro de tipos de sala e a funcionalidade Reserva de instalações | totvs.com/educacional/totvs-educacional | 1 | Verificado para o escopo do módulo |
| No TOTVS a reserva se relaciona aos horários de aula do docente e depende do parâmetro Permite Reserva | Artigo da Central de Atendimento TOTVS | Nenhum utilizável | **[FONTE ÚNICA]** e **[NÃO VERIFICADO]** em fonte aberta. O fetch direto retornou HTTP 403 e o texto veio apenas do snippet de busca. É indício, não fato firme |
| Preço do TOTVS Educacional | Não publicado | Nenhum | **[NÃO VERIFICADO]** |
| SuperSaaS cobra por volume de agendamentos futuros, com gratuito de 50 agendamentos e pagos de US$9/mês a US$180/mês | supersaas.com.br/info/precos e supersaas.com.br/info/software-de-agendamento-para-escolas-e-universidades | 1 | Verificado, fornecedor sobre o próprio preço |
| Microsoft 365 Room Finder incluído na assinatura sem licença adicional para caixa postal de recurso | medium.com/meeting-room-365 e virtosoftware.com/events/meeting-room-booking-software | 3 | **[NÃO VERIFICADO]** em fonte primária. **[Tier 3, não confirmado em fonte primária]**, ambos fornecedores interessados, nenhuma documentação da Microsoft consultada |
| UniEspaços é da UESB, software livre, registrado no INPI com a UESB como titular, TCC de Pedro Henrique Pinheiro com orientação do professor Agnaldo Volpe Lovato, piloto em Jequié, cobre salas, auditórios e quadras e integra solicitação, análise e aprovação | uesb.br | 1 | Verificado em fonte oficial da universidade |
| A UFCSPA tem aplicativo institucional com consulta e reserva de salas para alunos | Apenas snippet de busca | Nenhum utilizável | **[FONTE ÚNICA]** e **[NÃO VERIFICADO]**. Não confirmado em fetch, e por isso não é usado como argumento em nenhum ponto deste pitch |
| Na UFG o laboratório de informática exige e-mail com três dias de antecedência e técnico administrativo para abrir, e instalação de software exige quinze dias | emc.ufg.br/p/23681-uso-e-procedimentos-de-reserva-laboratorios-informatica | 1 | Verificado em unidade acadêmica oficial |
| No CETENS da UFRB a reserva usa formulários separados por categoria de espaço | ufrb.edu.br/cetens/reserva | 1 | Verificado em unidade acadêmica oficial. São dois casos, e dois casos não são estatística |
| As instituições brasileiras publicam a grade horária em formato consumível por aplicação de terceiro | Nenhuma fonte consultada | Nenhum | **[NÃO VERIFICADO]**. É premissa da estratégia freemium e não foi verificada para nenhuma instituição |
| Tamanho, receita ou crescimento do mercado brasileiro de gestão de espaço acadêmico | Nenhuma fonte citável encontrada | Nenhum | **[NÃO VERIFICADO]**. Nenhum número de mercado aparece neste documento |
| Skedda, EMS ou Series25 têm cliente universitário no Brasil | Nenhuma fonte | Nenhum | **[NÃO VERIFICADO]**. Os clientes que eles citam são norte-americanos e europeus, o que não é prova de ausência no Brasil |
| Política da FIAP sobre acesso a dados de grade horária e inventário de salas por aplicação de aluno | Nenhuma fonte consultada | Nenhum | **[NÃO VERIFICADO]**. É pergunta a fazer ao professor ou à instituição, não a supor. Não bloqueia o CP4, porque os dados são mockados, mas bloqueia qualquer afirmação sobre integração real |

### Nível de verificação

Toda afirmação desta seção foi conferida na fonte citada. Onde a fonte é única, onde ela é
comercial de terceiro em vez de primária, ou onde ela simplesmente não existe, a marcação
aparece no próprio ponto de uso e não numa nota de rodapé.

Três consultas não puderam ser concluídas por acesso negado ou página inexistente, e por isso
os dados que dependiam só delas ficaram de fora em vez de serem citados: um artigo de jornal
universitário e um artigo de central de atendimento retornaram HTTP 403, e a página de preços
de um concorrente retornou HTTP 404. O valor de cerca de US$92 por mês que circula em
comparativo sobre esse concorrente foi descartado justamente por isso.

Nenhum número de tamanho de mercado aparece neste documento, porque nenhum foi verificado em
fonte primária.
