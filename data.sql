--
-- PostgreSQL database dump
--

\restrict y7cBV7PFGduqeVAK54SlccikEUhnoHfKt6Zr8vVk27TRZK3tWqFlZhCk6qb6WhL

-- Dumped from database version 17.7 (Debian 17.7-3.pgdg13+1)
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: addresses; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.addresses (address_id, city, street, building, apartment, entrance, floor, comment, latitude, longitude) FROM stdin;
1	Запоріжжя	Головна	10	\N	\N	\N	\N	\N	\N
2	Запоріжжя	Головна	3	\N	\N	\N	\N	\N	\N
3	Запоріжжя	Соборний	4	\N	\N	\N	\N	\N	\N
4	Запоріжжя	Весніна	1	\N	\N	\N	\N	\N	\N
5	Запоріжжя	Академіка Весніна	1А	35	\N	\N	\N	\N	\N
\.


--
-- Data for Name: couriers; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.couriers (courier_id, full_name, phone, vehicle_type, is_active, hired_at, transport_type, transport_details) FROM stdin;
1	Максим Іванов	+380671111111	\N	t	\N	bike	\N
2	Дмитро Кравченко	+380672222222	\N	t	\N	car	\N
3	Олексій Бондар	+380673333333	\N	t	\N	scooter	\N
4	Іван Петренко	+380991112233	\N	t	\N	bike	\N
5	Микола	+380990001122	\N	t	\N	scooter	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.users (user_id, full_name, email, phone, password_hash, is_activ, created_at) FROM stdin;
2	Ян	yan@gmail.com	+380678489	654321	t	2026-03-04 07:57:35.415671+00
1	Настя	nastya@gmail.com	+3801544548	123456	t	2026-03-04 07:57:35.415671+00
\.


--
-- Data for Name: courier_shifts; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.courier_shifts (shift_id, courier_id, start_time, end_time, status, created_by_user_id) FROM stdin;
1	1	2026-03-04 07:11:38.366112+00	\N	open	\N
2	5	2026-03-04 07:32:00.239195+00	\N	open	\N
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.customers (customer_id, full_name, phone, email, created_at) FROM stdin;
1	Іван Петренко	+380931111111	ivan@mail.com	2026-03-04 07:01:44.286702+00
2	Олена Коваль	+380932222222	olena@mail.com	2026-03-04 07:01:44.286702+00
3	Андрій Шевченко	+380933333333	andriy@mail.com	2026-03-04 07:01:44.286702+00
5	Януша	+380000000001	\N	2026-03-04 07:31:06.141917+00
4	Ян Карпенко	+380931111112	yanchik@gmail.com	2026-03-04 07:30:44.286702+00
\.


--
-- Data for Name: restaurants; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.restaurants (restaurant_id, name, phone, email, address_id, is_active, commission_percent) FROM stdin;
1	Pizza House	+380441111111	pizza@mail.com	\N	t	10.00
2	Burger City	+380442222222	burger@mail.com	\N	t	12.00
3	Sushi Time	+380443333333	sushi@mail.com	\N	t	15.00
4	McDonald's	+380672544925	mcdonald@gmail.com	\N	t	20.00
5	Burger King	+380674544921	burgerking@gmail.com	\N	t	21.00
6	KFC	+380574544921	kfcnuggets@gmail.com	\N	t	19.00
7	Clode Monet	+380504544921	clodemonet@gmail.com	\N	t	22.00
8	Monofaktura	+380672544921	mono@gmail.com	\N	t	21.50
9	Fiesta	+380442222221	fiesta@gmail.com	\N	t	22.59
\.


--
-- Data for Name: tariffs; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.tariffs (tariff_id, name, base_fee, per_km_fee, service_fee_percent, is_active) FROM stdin;
1	Стандарт	55.00	40.00	10.00	t
2	Експрес	110.00	80.00	15.00	f
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.orders (order_id, customer_id, restaurant_id, delivery_address_id, status, subtotal_amount, delivery_fee, total_amount, created_at, confirmed_at, delivered_at, created_by_user_id, tariff_id) FROM stdin;
3	1	3	3	delivered	0.00	75.00	75.00	2026-03-04 17:31:06.141917+00	\N	\N	\N	1
19	5	1	1	cancelled	0.00	120.00	120.00	2026-03-04 07:31:06.141917+00	\N	\N	\N	1
1	3	5	1	on_delivery	0.00	50.00	50.00	2026-03-04 12:31:06.141917+00	\N	\N	\N	1
2	2	4	2	delivered	0.00	100.00	100.00	2026-03-04 14:31:06.141917+00	\N	\N	\N	2
4	4	2	4	delivered	0.00	100.00	100.00	2026-03-04 20:31:06.141917+00	\N	\N	\N	2
\.


--
-- Data for Name: courier_earnings; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.courier_earnings (earning_id, courier_id, shift_id, order_id, earning_type, amount, created_at) FROM stdin;
\.


--
-- Data for Name: courier_payouts; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.courier_payouts (payout_id, courier_id, period_start, period_end, amount, method, status, paid_at, created_by_user_id) FROM stdin;
\.


--
-- Data for Name: customer_addresses; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.customer_addresses (customer_id, address_id, is_default) FROM stdin;
4	3	t
1	1	t
2	3	t
3	4	t
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.deliveries (delivery_id, order_id, courier_id, status, assigned_at, picked_up_at, delivered_at, distance_km, delivery_cost) FROM stdin;
14	2	2	picked_up	2026-03-04 07:42:37.909014+00	\N	\N	\N	\N
15	3	3	delivered	2026-03-04 07:42:37.909014+00	\N	\N	\N	\N
16	4	\N	queued	2026-03-08 18:39:47.551413+00	\N	\N	\N	\N
13	1	1	cancelled	2026-03-04 07:42:37.909014+00	\N	\N	\N	\N
\.


--
-- Data for Name: expense_categories; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.expense_categories (expense_category_id, name) FROM stdin;
1	Паливо
2	Оренда офісу
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.expenses (expense_id, expense_category_id, amount, expense_date, description, related_courier_id, related_order_id, created_by_user_id, created_at) FROM stdin;
1	1	500.00	2026-03-04	Заправка авто кур`єра	\N	\N	\N	2026-03-04 07:06:34.230496+00
2	2	5000.00	2026-03-04	Оренда за березень	\N	\N	\N	2026-03-04 07:06:34.230496+00
\.


--
-- Data for Name: restaurants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurants (restaurant_id, name, phone, email, address_id, is_active, commission_percent) FROM stdin;
1	Pizza House	+380441111111	pizza@mail.com	\N	t	10.00
2	Burger City	+380442222222	burger@mail.com	\N	t	12.00
3	Sushi Time	+380443333333	sushi@mail.com	\N	t	15.00
\.


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.menu_categories (category_id, restaurant_id, name) FROM stdin;
9	1	Піца
10	2	Бургери
11	3	Суші
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.menu_items (menu_item_id, restaurant_id, category_id, name, description, price, is_available) FROM stdin;
2	1	9	Маргарита	Класична піца	180.00	t
3	1	9	Пепероні	Піца з ковбасою	220.00	t
4	2	10	Чізбургер	Бургер з сиром	150.00	t
6	3	11	Філадельфія	Суші рол	250.00	t
5	2	9	Картопля фрі	Смажена картопля	90.00	t
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.order_items (order_item_id, order_id, menu_item_id, qty, unit_price, line_total) FROM stdin;
1	19	2	1	180.00	180.00
2	19	3	1	220.00	220.00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.payments (payment_id, order_id, method, status, amount, paid_at, provider_ref) FROM stdin;
\.


--
-- Data for Name: restaurant_settlements; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.restaurant_settlements (settlement_id, restaurant_id, period_start, period_end, orders_count, gross_amount, service_commission, net_amount, status, paid_at, created_at, created_by_user_id) FROM stdin;
1	1	2026-03-01	2026-03-07	0	10000.00	0.00	8500.00	paid	2026-03-04 07:12:05.42276+00	2026-03-04 07:12:05.42276+00	\N
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.roles (role_id, role_name) FROM stdin;
2	Manager
1	Admin
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: delivery_mgmt; Owner: postgres
--

COPY delivery_mgmt.user_roles (user_id, role_id) FROM stdin;
2	2
1	1
\.


--
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.addresses_address_id_seq', 1, true);


--
-- Name: courier_earnings_earning_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.courier_earnings_earning_id_seq', 1, false);


--
-- Name: courier_payouts_payout_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.courier_payouts_payout_id_seq', 1, false);


--
-- Name: courier_shifts_shift_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.courier_shifts_shift_id_seq', 2, true);


--
-- Name: couriers_courier_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.couriers_courier_id_seq', 5, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.customers_customer_id_seq', 5, true);


--
-- Name: deliveries_delivery_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.deliveries_delivery_id_seq', 17, true);


--
-- Name: expense_categories_expense_category_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.expense_categories_expense_category_id_seq', 5, true);


--
-- Name: expenses_expense_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.expenses_expense_id_seq', 2, true);


--
-- Name: menu_categories_category_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.menu_categories_category_id_seq', 11, true);


--
-- Name: menu_items_menu_item_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.menu_items_menu_item_id_seq', 9, true);


--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.order_items_order_item_id_seq', 2, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.orders_order_id_seq', 19, true);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.payments_payment_id_seq', 1, false);


--
-- Name: restaurant_settlements_settlement_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.restaurant_settlements_settlement_id_seq', 2, true);


--
-- Name: restaurants_restaurant_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.restaurants_restaurant_id_seq', 5, true);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.roles_role_id_seq', 1, false);


--
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.tariffs_tariff_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: delivery_mgmt; Owner: postgres
--

SELECT pg_catalog.setval('delivery_mgmt.users_user_id_seq', 1, false);


--
-- Name: restaurants_restaurant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restaurants_restaurant_id_seq', 3, true);


--
-- PostgreSQL database dump complete
--

\unrestrict y7cBV7PFGduqeVAK54SlccikEUhnoHfKt6Zr8vVk27TRZK3tWqFlZhCk6qb6WhL

