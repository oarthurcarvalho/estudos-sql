# 2ª Edição do Bootcamp CDS
Este exercícios faz parte do evento da Comunidade DS.

## 1.0 - Problema de Negócio

A rede de restaurantes norte-americana Northwind está passando por um processo
de reformulação na sua gestão. Uma das ideias dos novos gestores é instalar uma
cultura voltada para dados na empresa, a fim de entender melhor em qual cenário
a empresa está, qual é o perfil dos seus clientes, como reduzir custos, como
aumentar os lucros e assim por diante.

A empresa começou a registrar todos os eventos que aconteciam e todas as informações
que pudesse ter relevância. A partir disso, foram coletados dados dos clientes,
ados empregados, dos produtos, das categorias dos produtos, dos pedidos, dos detalhes dos pedidos, dos fornecedores, dos entregadores, das regiões e dos locais de venda. Além disso, todas essas informações foram armazenadas em um banco de dados projetado pela rede.
 
Por ainda possuírem poucos dados e ao mesmo tempo necessitarem de algumas informações
rápidas para gerar insights no intuito de melhorar a performance do negócio, atraírem mais clientes e reduzirem os custos, os gestores solicitaram a equipe de analistas de dados da rede que acessasse a base de dados e trouxesse, ao final do dia, a resposta para algumas perguntas de negócio.

**Objetivo:** como analista de dados da Northwind, o seu objetivo é reunir-se com a sua equipe, do início ao final do dia, e acessar a base de dados da empresa, trazendo as respostas às perguntas de negócio solicitadas pelos gestores, a fim de gerar novos insights e facilitar a tomada de decisão por parte dos mesmos.

## 2.0 - Perguntas de Negócio

1. Quantos produtos distintos existem para cada categoria?
2. Quantos produtos são enviados em cada pedido?
3. Quantos produtos distintos são comercializados em garrafas?
4. Foram realizados quantos pedidos por dia?
5. Quantos produtos distintos existem por fornecedor?
6. Quantos pedidos cada empregado conseguiu realizar?
7. Considerando as Américas (Norte, Sul e Central), quantos clientes existem por país?
8. Quantos pedidos foram realizados por clientes representantes das áreas de vendas?
9. Quais produtos possuem menos de 10 quantidades em estoque?
10. Categorize os produtos que possuem preço unitário entre $0 e $9.99, entre $10 e
19.99, entre $20 e $49.99 ou maior que $50 e conte quantos produtos há em cada
categoria.
11. Ranqueie os produtos do maior para o menor preço, colocando preços iguais na
mesma posição do ranking.
12. Categorize os pedidos com desconto e os pedidos sem desconto e conte quantos
pedidos há em cada categoria.
13. Foram realizados quantos pedidos por semana?
14. Qual é o valor monetário de cada pedido (considerando o preço unitário, as
quantidades, o desconto e o frete)?
15. Categorize o valor monetário de cada pedido em 4 buckets (conjuntos) e os ordene,
do maior para o menor.
16. Qual é o faturamento agregado em pedidos por região e por país?
17. Qual é o faturamento agregado em pedidos por categoria de produto?
18. Qual é o faturamento agregado em pedidos por funcionário?
19. Compare o faturamento médio em pedidos entre todos os clientes em relação ao
faturamento agregado em pedidos por cliente para cada cliente.
20. Qual é a diferença do tempo, em dias, entre o pedido mais recente de cada cliente e o
pedido atual de cada cliente?
21. Qual é a diferença do tempo, em dias, entre o pedido mais recente geral e o pedido
mais recente de cada cliente?
22. Qual é a média móvel semanal dos preços dos pedidos?
23. Qual é a média móvel histórica dos preços dos pedidos?
24. Crie um aviso de ‘nao_identificado’ para os códigos postais faltantes dos envios.
25. Adicione um novo produto na categoria de bebidas chamado ‘suco_de_uva’,
pertencente ao primeiro fornecedor, custando $20 por unidade e com 50 unidades no
estoque. Preencha o restante dos campos com 0.

## 3.0 - Fonte de Dados

**Fonte dos dados:**https://github.com/pthom/northwind_psql

**OBS.:** O dataset original pode ser acessado no site https://www.sql-practice.com/. Porém, o site só aceita SQLite.
