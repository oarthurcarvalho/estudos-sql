--1. Quantos produtos distintos existem para cada categoria?

SELECT
	c.category_name,
	COUNT(DISTINCT p.product_id) AS qnt_produtos 
FROM
	products AS p
	LEFT JOIN categories AS c ON p.category_id = c.category_id
GROUP BY c.category_name

--2. Quantos produtos são enviados em cada pedido?

SELECT 
	od.order_id,
	SUM(od.quantity) qnt_total_produtos
FROM order_details AS od 
GROUP BY od.order_id

--3. Quantos produtos distintos são comercializados em garrafas?

SELECT COUNT(p.product_id) as prod_garrafas
FROM products p
WHERE p.quantity_per_unit LIKE '%bottle%'

--4. Foram realizados quantos pedidos por dia?

SELECT 
	order_date,
	COUNT(o.order_id)
FROM orders o
GROUP BY order_date

--5. Quantos produtos distintos existem por fornecedor?

SELECT
	s.supplier_id,
	COUNT(distinct p.product_id) AS qnt_produtos
FROM products p 
	LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_id 

--6. Quantos pedidos cada empregado conseguiu realizar?

SELECT  
	e.employee_id,
	COUNT(DISTINCT o.order_id) 
FROM employees e
	LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id

--7. Considerando as Américas (Norte, Sul e Central), quantos clientes existem por país?

SELECT 
	c.country,
	COUNT(customer_id) AS qnt_clientes 
FROM customers c
WHERE c.country IN ('Argentina', 'Venezuela', 'USA', 'Mexico', 'Brazil', 'Canada')
GROUP BY c.country

--8. Quantos pedidos foram realizados por clientes representantes das áreas de vendas?

SELECT
	c.customer_id,
	COUNT(o.order_id) AS qnt_pedidos
FROM customers c
	LEFT JOIN orders o ON o.customer_id = c.customer_id 
WHERE c.contact_title LIKE '%Sales%'
GROUP BY c.customer_id

--9. Quais produtos possuem menos de 10 quantidades em estoque?

SELECT
	product_id,
	product_name,
	units_in_stock
FROM products p
WHERE units_in_stock < 10
ORDER BY units_in_stock DESC

--10. Categorize os produtos que possuem preço unitário entre $0 e $9.99, entre $10 e
--19.99, entre $20 e $49.99 ou maior que $50 e conte quantos produtos há em cada categoria.

SELECT
	CASE
		WHEN p.unit_price BETWEEN 0 AND 9.99 THEN 'entre $0 e $9.99'
		WHEN p.unit_price BETWEEN 10 AND 19.99 THEN 'entre $10 e 19.99'
		WHEN p.unit_price BETWEEN 20 AND 50 THEN 'entre $20 e $49.99'
		WHEN p.unit_price > 50 THEN 'maior que $50'
		ELSE 'sem_categoria'
	END AS categoria_preco,
	COUNT(p.product_id) AS qnt_produtos
FROM products p
GROUP BY categoria_preco

--11. Ranqueie os produtos do maior para o menor preço, colocando preços iguais na mesma posição do ranking.

SELECT
	RANK() OVER (PARTITION BY p.unit_price),
	p.product_id,
	p.product_name,
	p.unit_price
FROM products p

--12. Categorize os pedidos com desconto e os pedidos sem desconto e conte quantos pedidos há em cada categoria.

SELECT
	CASE
		WHEN od.discount > 0 THEN 'com_desconto'
		ELSE 'sem_desconto'
	END AS tipo_pedido,
	COUNT(DISTINCT order_id)
FROM order_details od
GROUP BY tipo_pedido

--13. Foram realizados quantos pedidos por semana?

SELECT
	DATE_PART('week', o.order_date) AS num_semana,
	COUNT(order_id) AS qnt_pedidos
FROM orders o
GROUP BY num_semana
order by num_semana ASC

--14. Qual é o valor monetário de cada pedido (considerando o preço unitário, as quantidades, o desconto e o frete)?

WITH t1 AS (
	SELECT 
		od.order_id,
		ROUND( CAST( (p.unit_price * od.quantity) * (1 - od.discount) AS NUMERIC ), 2 ) AS pedido_produto
	FROM order_details od
		LEFT JOIN products p ON p.product_id = od.product_id
)
SELECT 
	DISTINCT t1.order_id,
	ROUND( CAST(SUM(t1.pedido_produto) OVER (PARTITION BY t1.order_id) + o.freight AS NUMERIC), 2) AS total_pedido
FROM t1
	LEFT JOIN orders o ON o.order_id = t1.order_id
ORDER BY t1.order_id



--15. Categorize o valor monetário de cada pedido em 4 buckets (conjuntos) e os ordene, do maior para o menor.

WITH t1 AS (
	SELECT 
		od.order_id,
		p.product_id,
		p.product_name,
		p.unit_price,
		od.quantity,
		od.discount,
		ROUND( CAST( (p.unit_price * od.quantity) * (1 - od.discount) AS NUMERIC ), 2 ) AS pedido_produto
	FROM order_details od
		LEFT JOIN products p ON p.product_id = od.product_id
),
t2 AS (
	SELECT 
		DISTINCT t1.order_id,
		ROUND( CAST(SUM(t1.pedido_produto) OVER (PARTITION BY t1.order_id) + o.freight AS NUMERIC), 2) AS total_pedido
	FROM t1
		LEFT JOIN orders o ON o.order_id = t1.order_id
	ORDER BY t1.order_id
),
t3 AS (
 	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY t2.total_pedido) AS q1,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY t2.total_pedido) AS q2,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY t2.total_pedido) AS q3
	FROM t2
)
SELECT *
FROM (
    SELECT
        t2.order_id,
        t2.total_pedido,
        CASE
            WHEN total_pedido <= (SELECT q1 FROM t3) THEN 1
            WHEN total_pedido > (SELECT q1 FROM t3) AND total_pedido <= (SELECT q2 FROM t3) THEN 2
            WHEN total_pedido > (SELECT q2 FROM t3) AND total_pedido <= (SELECT q3 FROM t3) THEN 3
            ELSE 4
        END AS bucket
    FROM t2
) AS subquery
ORDER BY total_pedido


--16. Qual é o faturamento agregado em pedidos por região e por país?
WITH t1 AS (
	SELECT
		o.order_id,
		p.unit_price,
		od.quantity,
		o.freight,
		od.discount,
		p.unit_price * quantity * ( 1 - discount ) AS order_price
	FROM order_details od 
		LEFT JOIN orders o ON od.order_id = o.order_id
		LEFT JOIN products p ON p.product_id = od.product_id
),
t2 AS (
	SELECT 
		t1.order_id,
		ROUND( CAST( SUM(t1.order_price) AS NUMERIC), 2) AS valor_pedido
	FROM t1
	GROUP BY t1.order_id
)
SELECT 
	c.country,
	c.region,
	ROUND( CAST(SUM(t2.valor_pedido) AS NUMERIC), 2) AS valor_pedido_pais
FROM t2
	LEFT JOIN orders o ON o.order_id = t2.order_id
	LEFT JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.region, c.country 
ORDER BY c.country
	
--17. Qual é o faturamento agregado em pedidos por categoria de produto?
WITH t1 AS (
	SELECT
		od.order_id,
		p.category_id,
		(p.unit_price * od.quantity) * (1 - od.discount) AS total_produto
	FROM order_details od
		LEFT JOIN products p ON p.product_id = od.product_id
),
t2 AS (
	SELECT
		t1.order_id,
		SUM(t1.total_produto) AS faturamento
	FROM t1
		LEFT JOIN orders o ON t1.order_id = o.order_id
	GROUP BY t1.order_id
)
SELECT
	c.category_id,
	c.category_name,
	ROUND( CAST( SUM(t2.faturamento) AS NUMERIC ), 2) AS valor_faturamento
FROM t2
	LEFT JOIN order_details od ON t2.order_id = od.order_id
	LEFT JOIN products p ON p.product_id = od.product_id
	LEFT JOIN categories c ON c.category_id = p.category_id
GROUP BY c.category_id

--18. Qual é o faturamento agregado em pedidos por funcionário?
WITH t1 AS (
	SELECT
		od.order_id,
		p.unit_price,
		od.quantity,
		od.discount,
		(p.unit_price * od.quantity) * (1 - od.discount) AS valor_produto
	FROM order_details od
		LEFT JOIN products p ON p.product_id = od.product_id
),
t2 AS (
	SELECT
		t1.order_id,
		SUM(valor_produto) AS faturamento
	FROM t1
	GROUP BY t1.order_id
)
SELECT 
	e.employee_id,
	CONCAT(e.first_name, ' ', e.last_name),
	ROUND( CAST(SUM(faturamento) AS NUMERIC), 2) AS faturamento
FROM t2
	LEFT JOIN orders o ON o.order_id = t2.order_id
	LEFT JOIN employees e ON e.employee_id = o.employee_id
GROUP BY e.employee_id
ORDER BY e.employee_id

--19. Compare o faturamento médio em pedidos entre todos os clientes em relação ao 
--faturamento agregado em pedidos por cliente para cada cliente.

WITH t1 AS (
SELECT 
	o.order_id,
	o.customer_id,
	(p.unit_price * od.quantity) * (1 - od.discount) AS valor_produto
FROM order_details od
	LEFT JOIN orders o ON o.order_id = od.order_id
	LEFT JOIN products p ON p.product_id = od.product_id
),
t2 AS (
	SELECT 
		t1.order_id,
		SUM(t1.valor_produto) AS valor_order
	FROM t1
		LEFT JOIN customers c ON t1.customer_id = c.customer_id
	GROUP BY t1.order_id
)
SELECT 
	o.customer_id,
	ROUND( CAST(AVG(t2.valor_order) AS NUMERIC ), 2)  AS valor_pedido_cliente_medio,
	(
		SELECT 
			ROUND( CAST( AVG(t2.valor_order) AS NUMERIC ), 2 )
		FROM t2
	) AS valor_pedido_geral_medio
FROM t2
	LEFT JOIN orders o ON t2.order_id = o.order_id
GROUP BY o.customer_id
ORDER BY o.customer_id

--20. Qual é a diferença do tempo, em dias, entre o pedido mais recente de cada cliente e o 
--pedido atual de cada cliente?
WITH t1 AS (
	SELECT 
		o.customer_id,
		o.order_id,
		o.order_date,
		MAX(o.order_date) OVER (PARTITION BY o.customer_id) AS max_date_by_client
	FROM orders o
)
SELECT
	t1.customer_id,
	t1.order_id,
	t1.order_date,
	t1.max_date_by_client,
	t1.max_date_by_client - t1.order_date AS difference_days
FROM t1
ORDER BY customer_id, difference_days DESC

--21. Qual é a diferença do tempo, em dias, entre o pedido mais recente geral e o pedido
--mais recente de cada cliente?
WITH t1 AS (
	SELECT
		DISTINCT o.customer_id,
		( SELECT MAX(o2.order_date) FROM orders o2 ) AS max_date_geral,
		MAX(o.order_date) OVER (PARTITION BY o.customer_id) AS max_date_by_client
	FROM orders o
)
SELECT 
	t1.customer_id,
	t1.max_date_by_client,
	t1.max_date_geral,
    t1.max_date_geral - t1.max_date_by_client AS difference_days
FROM t1
ORDER BY t1.customer_id

--22. Qual é a média móvel semanal dos preços dos pedidos?
WITH t1 AS (
	SELECT 
		od.order_id,
		p.unit_price,
		od.quantity,
		od.discount,
		(p.unit_price * od.quantity) * (1 - od.discount) AS preco_produto
	FROM order_details od 
		LEFT JOIN products p ON od.product_id = p.product_id
),
t2 AS (
	SELECT 
		t1.order_id,
		SUM( t1.preco_produto ) AS valor_pedido
	FROM t1
	GROUP BY t1.order_id
)
SELECT
	o.order_id,
	o.order_date,
	t2.valor_pedido,
	AVG(t2.valor_pedido) OVER (ORDER BY o.order_date ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) AS medial_movel
FROM t2
	LEFT JOIN orders o ON o.order_id = t2.order_id
ORDER BY o.order_id

--23. Qual é a média móvel histórica dos preços dos pedidos?
WITH t1 AS (
	SELECT 
		od.order_id,
		p.unit_price,
		od.quantity,
		od.discount,
		(p.unit_price * od.quantity) * (1 - od.discount) AS preco_produto
	FROM order_details od 
		LEFT JOIN products p ON od.product_id = p.product_id
),
t2 AS (
	SELECT 
		t1.order_id,
		SUM( t1.preco_produto ) AS valor_pedido
	FROM t1
	GROUP BY t1.order_id
)
SELECT
	o.order_id,
	o.order_date,
	t2.valor_pedido,
	AVG(t2.valor_pedido) OVER (ORDER BY o.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS medial_movel
FROM t2
	LEFT JOIN orders o ON o.order_id = t2.order_id
ORDER BY o.order_id

--24. Crie um aviso de ‘nao_identificado’ para os códigos postais faltantes dos envios.

 SELECT
 	c.postal_code,
 	COALESCE(postal_code, 'nao_identificado') AS postal_code_not_null
FROM customers c

-- 25. Adicione um novo produto na categoria de bebidas chamado ‘suco_de_uva’,
-- pertencente ao primeiro fornecedor, custando $20 por unidade e com 50 unidades no
-- estoque. Preencha o restante dos campos com 0.

INSERT INTO products (product_id, product_name, category_id, supplier_id, unit_price, units_in_stock, quantity_per_unit,
                      reorder_level, discontinued, units_on_order)
VALUES ((SELECT MAX(product_id) FROM products) + 1, 'suco_de_uva', 1, 1, 20, 50, 1, 0, 0, 0)

--	verificando a inserção 
SELECT *
FROM products p
WHERE p.product_name = 'suco_de_uva'
	