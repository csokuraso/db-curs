--
-- PostgreSQL database dump
--

\restrict 5pX1Y2DzVCec3JD3CUqd3MelNpLuvTf0k998k8XGAvkD5V73lCT6XfOcd1KPZsD

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
-- Name: delivery_mgmt; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA delivery_mgmt;


ALTER SCHEMA delivery_mgmt OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: addresses; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.addresses (
    address_id bigint NOT NULL,
    city text NOT NULL,
    street text NOT NULL,
    building text NOT NULL,
    apartment text,
    entrance text,
    floor text,
    comment text,
    latitude numeric(9,6),
    longitude numeric(9,6)
);


ALTER TABLE delivery_mgmt.addresses OWNER TO postgres;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.addresses_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.addresses_address_id_seq OWNER TO postgres;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.addresses_address_id_seq OWNED BY delivery_mgmt.addresses.address_id;


--
-- Name: courier_earnings; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.courier_earnings (
    earning_id bigint NOT NULL,
    courier_id bigint NOT NULL,
    shift_id bigint,
    order_id bigint,
    earning_type text NOT NULL,
    amount numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT courier_earnings_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT courier_earnings_earning_type_check CHECK ((earning_type = ANY (ARRAY['delivery_fee'::text, 'bonus'::text, 'penalty'::text])))
);


ALTER TABLE delivery_mgmt.courier_earnings OWNER TO postgres;

--
-- Name: courier_earnings_earning_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.courier_earnings_earning_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.courier_earnings_earning_id_seq OWNER TO postgres;

--
-- Name: courier_earnings_earning_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.courier_earnings_earning_id_seq OWNED BY delivery_mgmt.courier_earnings.earning_id;


--
-- Name: courier_payouts; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.courier_payouts (
    payout_id bigint NOT NULL,
    courier_id bigint NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    amount numeric(12,2) NOT NULL,
    method text NOT NULL,
    status text NOT NULL,
    paid_at timestamp with time zone,
    created_by_user_id bigint,
    CONSTRAINT courier_payouts_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT courier_payouts_check CHECK ((period_end >= period_start)),
    CONSTRAINT courier_payouts_method_check CHECK ((method = ANY (ARRAY['cash'::text, 'card'::text, 'bank_transfer'::text]))),
    CONSTRAINT courier_payouts_status_check CHECK ((status = ANY (ARRAY['planned'::text, 'paid'::text, 'cancelled'::text])))
);


ALTER TABLE delivery_mgmt.courier_payouts OWNER TO postgres;

--
-- Name: courier_payouts_payout_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.courier_payouts_payout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.courier_payouts_payout_id_seq OWNER TO postgres;

--
-- Name: courier_payouts_payout_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.courier_payouts_payout_id_seq OWNED BY delivery_mgmt.courier_payouts.payout_id;


--
-- Name: courier_shifts; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.courier_shifts (
    shift_id bigint NOT NULL,
    courier_id bigint NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone,
    status text NOT NULL,
    created_by_user_id bigint,
    CONSTRAINT courier_shifts_check CHECK (((end_time IS NULL) OR (end_time >= start_time))),
    CONSTRAINT courier_shifts_status_check CHECK ((status = ANY (ARRAY['open'::text, 'closed'::text, 'cancelled'::text])))
);


ALTER TABLE delivery_mgmt.courier_shifts OWNER TO postgres;

--
-- Name: courier_shifts_shift_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.courier_shifts_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.courier_shifts_shift_id_seq OWNER TO postgres;

--
-- Name: courier_shifts_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.courier_shifts_shift_id_seq OWNED BY delivery_mgmt.courier_shifts.shift_id;


--
-- Name: couriers; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.couriers (
    courier_id bigint NOT NULL,
    full_name text NOT NULL,
    phone text NOT NULL,
    vehicle_type text,
    is_active boolean DEFAULT true NOT NULL,
    hired_at date,
    transport_type text NOT NULL,
    transport_details text,
    CONSTRAINT couriers_transport_type_chk CHECK ((transport_type = ANY (ARRAY['bike'::text, 'car'::text, 'scooter'::text, 'motorbike'::text])))
);


ALTER TABLE delivery_mgmt.couriers OWNER TO postgres;

--
-- Name: couriers_courier_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.couriers_courier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.couriers_courier_id_seq OWNER TO postgres;

--
-- Name: couriers_courier_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.couriers_courier_id_seq OWNED BY delivery_mgmt.couriers.courier_id;


--
-- Name: customer_addresses; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.customer_addresses (
    customer_id bigint NOT NULL,
    address_id bigint NOT NULL,
    is_default boolean DEFAULT false NOT NULL
);


ALTER TABLE delivery_mgmt.customer_addresses OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.customers (
    customer_id bigint NOT NULL,
    full_name text NOT NULL,
    phone text NOT NULL,
    email text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE delivery_mgmt.customers OWNER TO postgres;

--
-- Name: customer_delivery_points; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.customer_delivery_points AS
 SELECT c.full_name,
    a.city,
    a.street,
    a.building,
    ca.is_default
   FROM ((delivery_mgmt.customers c
     JOIN delivery_mgmt.customer_addresses ca ON ((c.customer_id = ca.customer_id)))
     JOIN delivery_mgmt.addresses a ON ((ca.address_id = a.address_id)));


ALTER VIEW delivery_mgmt.customer_delivery_points OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.customers_customer_id_seq OWNED BY delivery_mgmt.customers.customer_id;


--
-- Name: deliveries; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.deliveries (
    delivery_id bigint NOT NULL,
    order_id bigint NOT NULL,
    courier_id bigint,
    status text NOT NULL,
    assigned_at timestamp with time zone,
    picked_up_at timestamp with time zone,
    delivered_at timestamp with time zone,
    distance_km numeric(8,2),
    delivery_cost numeric(12,2),
    CONSTRAINT deliveries_delivery_cost_check CHECK ((delivery_cost >= (0)::numeric)),
    CONSTRAINT deliveries_distance_km_check CHECK ((distance_km >= (0)::numeric)),
    CONSTRAINT deliveries_status_check CHECK ((status = ANY (ARRAY['queued'::text, 'assigned'::text, 'picked_up'::text, 'delivered'::text, 'cancelled'::text])))
);


ALTER TABLE delivery_mgmt.deliveries OWNER TO postgres;

--
-- Name: deliveries_delivery_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.deliveries_delivery_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.deliveries_delivery_id_seq OWNER TO postgres;

--
-- Name: deliveries_delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.deliveries_delivery_id_seq OWNED BY delivery_mgmt.deliveries.delivery_id;


--
-- Name: expense_categories; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.expense_categories (
    expense_category_id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE delivery_mgmt.expense_categories OWNER TO postgres;

--
-- Name: expense_categories_expense_category_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.expense_categories_expense_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.expense_categories_expense_category_id_seq OWNER TO postgres;

--
-- Name: expense_categories_expense_category_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.expense_categories_expense_category_id_seq OWNED BY delivery_mgmt.expense_categories.expense_category_id;


--
-- Name: expenses; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.expenses (
    expense_id bigint NOT NULL,
    expense_category_id bigint NOT NULL,
    amount numeric(12,2) NOT NULL,
    expense_date date DEFAULT CURRENT_DATE NOT NULL,
    description text,
    related_courier_id bigint,
    related_order_id bigint,
    created_by_user_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT expenses_amount_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE delivery_mgmt.expenses OWNER TO postgres;

--
-- Name: expenses_expense_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.expenses_expense_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.expenses_expense_id_seq OWNER TO postgres;

--
-- Name: expenses_expense_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.expenses_expense_id_seq OWNED BY delivery_mgmt.expenses.expense_id;


--
-- Name: menu_categories; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.menu_categories (
    category_id bigint NOT NULL,
    restaurant_id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE delivery_mgmt.menu_categories OWNER TO postgres;

--
-- Name: menu_categories_category_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.menu_categories_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.menu_categories_category_id_seq OWNER TO postgres;

--
-- Name: menu_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.menu_categories_category_id_seq OWNED BY delivery_mgmt.menu_categories.category_id;


--
-- Name: menu_items; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.menu_items (
    menu_item_id bigint NOT NULL,
    restaurant_id bigint NOT NULL,
    category_id bigint,
    name text NOT NULL,
    description text,
    price numeric(12,2) NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    CONSTRAINT menu_items_price_check CHECK ((price >= (0)::numeric))
);


ALTER TABLE delivery_mgmt.menu_items OWNER TO postgres;

--
-- Name: menu_items_menu_item_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.menu_items_menu_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.menu_items_menu_item_id_seq OWNER TO postgres;

--
-- Name: menu_items_menu_item_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.menu_items_menu_item_id_seq OWNED BY delivery_mgmt.menu_items.menu_item_id;


--
-- Name: order_items; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.order_items (
    order_item_id bigint NOT NULL,
    order_id bigint NOT NULL,
    menu_item_id bigint NOT NULL,
    qty integer NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    line_total numeric(12,2) NOT NULL,
    CONSTRAINT order_items_line_total_check CHECK ((line_total >= (0)::numeric)),
    CONSTRAINT order_items_qty_check CHECK ((qty > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE delivery_mgmt.order_items OWNER TO postgres;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.order_items_order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.order_items_order_item_id_seq OWNER TO postgres;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.order_items_order_item_id_seq OWNED BY delivery_mgmt.order_items.order_item_id;


--
-- Name: orders; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.orders (
    order_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    restaurant_id bigint NOT NULL,
    delivery_address_id bigint NOT NULL,
    status text NOT NULL,
    subtotal_amount numeric(12,2) DEFAULT 0 NOT NULL,
    delivery_fee numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    confirmed_at timestamp with time zone,
    delivered_at timestamp with time zone,
    created_by_user_id bigint,
    tariff_id bigint,
    CONSTRAINT orders_delivery_fee_check CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT orders_status_check CHECK ((status = ANY (ARRAY['created'::text, 'confirmed'::text, 'cooking'::text, 'ready'::text, 'on_delivery'::text, 'delivered'::text, 'cancelled'::text]))),
    CONSTRAINT orders_subtotal_amount_check CHECK ((subtotal_amount >= (0)::numeric)),
    CONSTRAINT orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE delivery_mgmt.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.orders_order_id_seq OWNED BY delivery_mgmt.orders.order_id;


--
-- Name: payments; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.payments (
    payment_id bigint NOT NULL,
    order_id bigint NOT NULL,
    method text NOT NULL,
    status text NOT NULL,
    amount numeric(12,2) NOT NULL,
    paid_at timestamp with time zone,
    provider_ref text,
    CONSTRAINT payments_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT payments_method_check CHECK ((method = ANY (ARRAY['cash'::text, 'card'::text, 'online'::text]))),
    CONSTRAINT payments_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text])))
);


ALTER TABLE delivery_mgmt.payments OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.payments_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.payments_payment_id_seq OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.payments_payment_id_seq OWNED BY delivery_mgmt.payments.payment_id;


--
-- Name: restaurant_settlements; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.restaurant_settlements (
    settlement_id bigint NOT NULL,
    restaurant_id bigint NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    orders_count integer DEFAULT 0 NOT NULL,
    gross_amount numeric(12,2) DEFAULT 0 NOT NULL,
    service_commission numeric(12,2) DEFAULT 0 NOT NULL,
    net_amount numeric(12,2) DEFAULT 0 NOT NULL,
    status text NOT NULL,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id bigint,
    CONSTRAINT restaurant_settlements_check CHECK ((period_end >= period_start)),
    CONSTRAINT restaurant_settlements_gross_amount_check CHECK ((gross_amount >= (0)::numeric)),
    CONSTRAINT restaurant_settlements_net_amount_check CHECK ((net_amount >= (0)::numeric)),
    CONSTRAINT restaurant_settlements_orders_count_check CHECK ((orders_count >= 0)),
    CONSTRAINT restaurant_settlements_service_commission_check CHECK ((service_commission >= (0)::numeric)),
    CONSTRAINT restaurant_settlements_status_check CHECK ((status = ANY (ARRAY['calculated'::text, 'paid'::text, 'cancelled'::text])))
);


ALTER TABLE delivery_mgmt.restaurant_settlements OWNER TO postgres;

--
-- Name: restaurant_settlements_settlement_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.restaurant_settlements_settlement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.restaurant_settlements_settlement_id_seq OWNER TO postgres;

--
-- Name: restaurant_settlements_settlement_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.restaurant_settlements_settlement_id_seq OWNED BY delivery_mgmt.restaurant_settlements.settlement_id;


--
-- Name: restaurants; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.restaurants (
    restaurant_id bigint NOT NULL,
    name text NOT NULL,
    phone text,
    email text,
    address_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    commission_percent numeric(5,2) DEFAULT 0 NOT NULL,
    CONSTRAINT restaurants_commission_percent_check CHECK ((commission_percent >= (0)::numeric))
);


ALTER TABLE delivery_mgmt.restaurants OWNER TO postgres;

--
-- Name: restaurants_restaurant_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.restaurants_restaurant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.restaurants_restaurant_id_seq OWNER TO postgres;

--
-- Name: restaurants_restaurant_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.restaurants_restaurant_id_seq OWNED BY delivery_mgmt.restaurants.restaurant_id;


--
-- Name: roles; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.roles (
    role_id bigint NOT NULL,
    role_name text NOT NULL
);


ALTER TABLE delivery_mgmt.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.roles_role_id_seq OWNED BY delivery_mgmt.roles.role_id;


--
-- Name: tariffs; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.tariffs (
    tariff_id bigint NOT NULL,
    name text NOT NULL,
    base_fee numeric(12,2) DEFAULT 0 NOT NULL,
    per_km_fee numeric(12,2) DEFAULT 0 NOT NULL,
    service_fee_percent numeric(5,2) DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT tariffs_base_fee_check CHECK ((base_fee >= (0)::numeric)),
    CONSTRAINT tariffs_per_km_fee_check CHECK ((per_km_fee >= (0)::numeric)),
    CONSTRAINT tariffs_service_fee_percent_check CHECK ((service_fee_percent >= (0)::numeric))
);


ALTER TABLE delivery_mgmt.tariffs OWNER TO postgres;

--
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.tariffs_tariff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.tariffs_tariff_id_seq OWNER TO postgres;

--
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.tariffs_tariff_id_seq OWNED BY delivery_mgmt.tariffs.tariff_id;


--
-- Name: users; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.users (
    user_id bigint NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text,
    password_hash text NOT NULL,
    is_activ boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE delivery_mgmt.users OWNER TO postgres;

--
-- Name: user_contact_list; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.user_contact_list AS
 SELECT full_name,
    email,
    phone,
    is_activ
   FROM delivery_mgmt.users;


ALTER VIEW delivery_mgmt.user_contact_list OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.user_roles (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE delivery_mgmt.user_roles OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: delivery_mgmt; Owner: postgres
--

CREATE SEQUENCE delivery_mgmt.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE delivery_mgmt.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: delivery_mgmt; Owner: postgres
--

ALTER SEQUENCE delivery_mgmt.users_user_id_seq OWNED BY delivery_mgmt.users.user_id;


--
-- Name: v_courier_delivery_stat; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_courier_delivery_stat AS
 SELECT c.courier_id,
    c.full_name AS courier_name,
    c.transport_type,
    count(d.delivery_id) AS deliveries_count
   FROM (delivery_mgmt.couriers c
     LEFT JOIN delivery_mgmt.deliveries d ON ((c.courier_id = d.courier_id)))
  GROUP BY c.courier_id, c.full_name, c.transport_type;


ALTER VIEW delivery_mgmt.v_courier_delivery_stat OWNER TO postgres;

--
-- Name: v_delivered_orders; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_delivered_orders AS
 SELECT o.order_id,
    c.full_name AS customer_name,
    r.name AS restaurant_name,
    o.total_amount,
    o.delivered_at
   FROM ((delivery_mgmt.orders o
     JOIN delivery_mgmt.customers c ON ((o.customer_id = c.customer_id)))
     JOIN delivery_mgmt.restaurants r ON ((o.restaurant_id = r.restaurant_id)));


ALTER VIEW delivery_mgmt.v_delivered_orders OWNER TO postgres;

--
-- Name: v_delivery_status; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_delivery_status AS
 SELECT o.order_id,
    c.full_name AS customer_name,
    r.name AS restaurant_name,
    o.status AS order_status,
    d.delivery_id,
    d.status AS delivery_status,
    d.assigned_at,
    d.picked_up_at,
    d.delivered_at,
    d.distance_km,
    d.delivery_cost,
    cr.full_name AS courier_name,
    cr.phone AS courier_phone,
    cr.transport_type
   FROM ((((delivery_mgmt.orders o
     JOIN delivery_mgmt.customers c ON ((o.customer_id = c.customer_id)))
     JOIN delivery_mgmt.restaurants r ON ((o.restaurant_id = r.restaurant_id)))
     LEFT JOIN delivery_mgmt.deliveries d ON ((o.order_id = d.order_id)))
     LEFT JOIN delivery_mgmt.couriers cr ON ((d.courier_id = cr.courier_id)));


ALTER VIEW delivery_mgmt.v_delivery_status OWNER TO postgres;

--
-- Name: v_order_items_info; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_order_items_info AS
 SELECT oi.order_item_id,
    oi.order_id,
    mi.name AS menu_item_name,
    oi.qty,
    oi.unit_price,
    oi.line_total
   FROM (delivery_mgmt.order_items oi
     JOIN delivery_mgmt.menu_items mi ON ((oi.menu_item_id = mi.menu_item_id)));


ALTER VIEW delivery_mgmt.v_order_items_info OWNER TO postgres;

--
-- Name: v_orders_info; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_orders_info AS
 SELECT o.order_id,
    c.full_name AS customer_name,
    c.phone AS customer_phone,
    r.name AS restaurant_name,
    o.status AS order_status,
    o.subtotal_amount,
    o.delivery_fee,
    o.total_amount,
    o.created_at
   FROM ((delivery_mgmt.orders o
     JOIN delivery_mgmt.customers c ON ((o.customer_id = c.customer_id)))
     JOIN delivery_mgmt.restaurants r ON ((o.restaurant_id = r.restaurant_id)));


ALTER VIEW delivery_mgmt.v_orders_info OWNER TO postgres;

--
-- Name: restaurants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurants (
    restaurant_id bigint NOT NULL,
    name text NOT NULL,
    phone text,
    email text,
    address_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    commission_percent numeric(5,2) DEFAULT 0 NOT NULL,
    CONSTRAINT restaurants_commission_percent_check CHECK ((commission_percent >= (0)::numeric))
);


ALTER TABLE public.restaurants OWNER TO postgres;

--
-- Name: v_restaurant_menu; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_restaurant_menu AS
 SELECT mi.menu_item_id,
    r.name AS restaurant_name,
    mi.name AS menu_item_name,
    mi.description,
    mi.price,
    mi.is_available
   FROM (delivery_mgmt.menu_items mi
     JOIN public.restaurants r ON ((mi.restaurant_id = r.restaurant_id)));


ALTER VIEW delivery_mgmt.v_restaurant_menu OWNER TO postgres;

--
-- Name: v_restaurant_orders_stat; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.v_restaurant_orders_stat AS
 SELECT r.restaurant_id,
    r.name AS restaurant_name,
    count(o.order_id) AS orders_count,
    COALESCE(sum(o.total_amount), (0)::numeric) AS total_orders_sum
   FROM (delivery_mgmt.restaurants r
     LEFT JOIN delivery_mgmt.orders o ON ((r.restaurant_id = o.restaurant_id)))
  GROUP BY r.restaurant_id, r.name;


ALTER VIEW delivery_mgmt.v_restaurant_orders_stat OWNER TO postgres;

--
-- Name: view_active_courier_shifts; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_active_courier_shifts AS
 SELECT cs.shift_id,
    c.full_name AS courier_name,
    cs.start_time,
    cs.status
   FROM (delivery_mgmt.courier_shifts cs
     JOIN delivery_mgmt.couriers c ON ((cs.courier_id = c.courier_id)))
  WHERE (cs.status = 'open'::text);


ALTER VIEW delivery_mgmt.view_active_courier_shifts OWNER TO postgres;

--
-- Name: view_active_tariffs; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_active_tariffs AS
 SELECT name,
    base_fee,
    per_km_fee,
    service_fee_percent
   FROM delivery_mgmt.tariffs
  WHERE (is_active = true);


ALTER VIEW delivery_mgmt.view_active_tariffs OWNER TO postgres;

--
-- Name: view_daily_expenses; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_daily_expenses AS
 SELECT e.amount,
    ec.name AS category,
    e.description,
    e.created_at
   FROM (delivery_mgmt.expenses e
     JOIN delivery_mgmt.expense_categories ec ON ((e.expense_category_id = ec.expense_category_id)))
  WHERE (e.expense_date = CURRENT_DATE);


ALTER VIEW delivery_mgmt.view_daily_expenses OWNER TO postgres;

--
-- Name: view_delivery_dispatch_center; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_delivery_dispatch_center AS
 SELECT d.delivery_id,
    COALESCE(cr.full_name, 'Кур’єра не призначено'::text) AS courier_name,
    cr.transport_type,
    o.order_id,
    ((((a.city || ', '::text) || a.street) || ' '::text) || a.building) AS destination,
    d.status AS delivery_status,
    d.assigned_at
   FROM (((delivery_mgmt.deliveries d
     LEFT JOIN delivery_mgmt.couriers cr ON ((d.courier_id = cr.courier_id)))
     JOIN delivery_mgmt.orders o ON ((d.order_id = o.order_id)))
     JOIN delivery_mgmt.addresses a ON ((o.delivery_address_id = a.address_id)));


ALTER VIEW delivery_mgmt.view_delivery_dispatch_center OWNER TO postgres;

--
-- Name: view_detailed_expenses_log; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_detailed_expenses_log AS
 SELECT e.expense_id,
    ec.name AS category_name,
    e.amount,
    e.expense_date,
    e.description,
    u.full_name AS recorded_by,
    e.created_at
   FROM ((delivery_mgmt.expenses e
     JOIN delivery_mgmt.expense_categories ec ON ((e.expense_category_id = ec.expense_category_id)))
     LEFT JOIN delivery_mgmt.users u ON ((e.created_by_user_id = u.user_id)))
  ORDER BY e.expense_date DESC;


ALTER VIEW delivery_mgmt.view_detailed_expenses_log OWNER TO postgres;

--
-- Name: view_expense_control_center; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_expense_control_center AS
 SELECT e.expense_id,
    ec.name AS expense_type,
    e.amount,
    e.description,
    u.full_name AS authorized_by,
    u.email AS authorizer_email,
    e.expense_date
   FROM ((delivery_mgmt.expenses e
     JOIN delivery_mgmt.expense_categories ec ON ((e.expense_category_id = ec.expense_category_id)))
     LEFT JOIN delivery_mgmt.users u ON ((e.created_by_user_id = u.user_id)))
  WHERE (e.amount > (0)::numeric);


ALTER VIEW delivery_mgmt.view_expense_control_center OWNER TO postgres;

--
-- Name: view_restaurant_finance_report; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_restaurant_finance_report AS
 SELECT r.name AS restaurant_name,
    rs.period_start,
    rs.period_end,
    rs.gross_amount AS total_revenue,
    rs.service_commission AS app_fee,
    rs.net_amount AS restaurant_payout,
    rs.status AS payment_status,
    ((rs.service_commission / NULLIF(rs.gross_amount, (0)::numeric)) * (100)::numeric) AS real_commission_rate
   FROM (delivery_mgmt.restaurant_settlements rs
     JOIN delivery_mgmt.restaurants r ON ((rs.restaurant_id = r.restaurant_id)))
  WHERE (rs.gross_amount > (0)::numeric);


ALTER VIEW delivery_mgmt.view_restaurant_finance_report OWNER TO postgres;

--
-- Name: view_restaurant_payout_locations; Type: VIEW; Schema: delivery_mgmt; Owner: postgres
--

CREATE VIEW delivery_mgmt.view_restaurant_payout_locations AS
 SELECT r.name AS restaurant,
    rs.net_amount AS paid_sum,
    COALESCE(((a.city || ', '::text) || a.street), 'Адреса відсутня'::text) AS location
   FROM ((delivery_mgmt.restaurant_settlements rs
     JOIN delivery_mgmt.restaurants r ON ((rs.restaurant_id = r.restaurant_id)))
     LEFT JOIN delivery_mgmt.addresses a ON ((r.address_id = a.address_id)))
  WHERE (rs.status = 'paid'::text);


ALTER VIEW delivery_mgmt.view_restaurant_payout_locations OWNER TO postgres;

--
-- Name: restaurants_restaurant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restaurants_restaurant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurants_restaurant_id_seq OWNER TO postgres;

--
-- Name: restaurants_restaurant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restaurants_restaurant_id_seq OWNED BY public.restaurants.restaurant_id;


--
-- Name: addresses address_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.addresses ALTER COLUMN address_id SET DEFAULT nextval('delivery_mgmt.addresses_address_id_seq'::regclass);


--
-- Name: courier_earnings earning_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_earnings ALTER COLUMN earning_id SET DEFAULT nextval('delivery_mgmt.courier_earnings_earning_id_seq'::regclass);


--
-- Name: courier_payouts payout_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_payouts ALTER COLUMN payout_id SET DEFAULT nextval('delivery_mgmt.courier_payouts_payout_id_seq'::regclass);


--
-- Name: courier_shifts shift_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_shifts ALTER COLUMN shift_id SET DEFAULT nextval('delivery_mgmt.courier_shifts_shift_id_seq'::regclass);


--
-- Name: couriers courier_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.couriers ALTER COLUMN courier_id SET DEFAULT nextval('delivery_mgmt.couriers_courier_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.customers ALTER COLUMN customer_id SET DEFAULT nextval('delivery_mgmt.customers_customer_id_seq'::regclass);


--
-- Name: deliveries delivery_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.deliveries ALTER COLUMN delivery_id SET DEFAULT nextval('delivery_mgmt.deliveries_delivery_id_seq'::regclass);


--
-- Name: expense_categories expense_category_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expense_categories ALTER COLUMN expense_category_id SET DEFAULT nextval('delivery_mgmt.expense_categories_expense_category_id_seq'::regclass);


--
-- Name: expenses expense_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expenses ALTER COLUMN expense_id SET DEFAULT nextval('delivery_mgmt.expenses_expense_id_seq'::regclass);


--
-- Name: menu_categories category_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_categories ALTER COLUMN category_id SET DEFAULT nextval('delivery_mgmt.menu_categories_category_id_seq'::regclass);


--
-- Name: menu_items menu_item_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_items ALTER COLUMN menu_item_id SET DEFAULT nextval('delivery_mgmt.menu_items_menu_item_id_seq'::regclass);


--
-- Name: order_items order_item_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('delivery_mgmt.order_items_order_item_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders ALTER COLUMN order_id SET DEFAULT nextval('delivery_mgmt.orders_order_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.payments ALTER COLUMN payment_id SET DEFAULT nextval('delivery_mgmt.payments_payment_id_seq'::regclass);


--
-- Name: restaurant_settlements settlement_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurant_settlements ALTER COLUMN settlement_id SET DEFAULT nextval('delivery_mgmt.restaurant_settlements_settlement_id_seq'::regclass);


--
-- Name: restaurants restaurant_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurants ALTER COLUMN restaurant_id SET DEFAULT nextval('delivery_mgmt.restaurants_restaurant_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.roles ALTER COLUMN role_id SET DEFAULT nextval('delivery_mgmt.roles_role_id_seq'::regclass);


--
-- Name: tariffs tariff_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.tariffs ALTER COLUMN tariff_id SET DEFAULT nextval('delivery_mgmt.tariffs_tariff_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.users ALTER COLUMN user_id SET DEFAULT nextval('delivery_mgmt.users_user_id_seq'::regclass);


--
-- Name: restaurants restaurant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants ALTER COLUMN restaurant_id SET DEFAULT nextval('public.restaurants_restaurant_id_seq'::regclass);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);


--
-- Name: courier_earnings courier_earnings_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_earnings
    ADD CONSTRAINT courier_earnings_pkey PRIMARY KEY (earning_id);


--
-- Name: courier_payouts courier_payouts_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_payouts
    ADD CONSTRAINT courier_payouts_pkey PRIMARY KEY (payout_id);


--
-- Name: courier_shifts courier_shifts_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_shifts
    ADD CONSTRAINT courier_shifts_pkey PRIMARY KEY (shift_id);


--
-- Name: couriers couriers_phone_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.couriers
    ADD CONSTRAINT couriers_phone_key UNIQUE (phone);


--
-- Name: couriers couriers_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.couriers
    ADD CONSTRAINT couriers_pkey PRIMARY KEY (courier_id);


--
-- Name: customer_addresses customer_addresses_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.customer_addresses
    ADD CONSTRAINT customer_addresses_pkey PRIMARY KEY (customer_id, address_id);


--
-- Name: customers customers_phone_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.customers
    ADD CONSTRAINT customers_phone_key UNIQUE (phone);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: deliveries deliveries_order_id_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.deliveries
    ADD CONSTRAINT deliveries_order_id_key UNIQUE (order_id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (delivery_id);


--
-- Name: expense_categories expense_categories_name_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expense_categories
    ADD CONSTRAINT expense_categories_name_key UNIQUE (name);


--
-- Name: expense_categories expense_categories_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expense_categories
    ADD CONSTRAINT expense_categories_pkey PRIMARY KEY (expense_category_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (expense_id);


--
-- Name: menu_categories menu_categories_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_categories
    ADD CONSTRAINT menu_categories_pkey PRIMARY KEY (category_id);


--
-- Name: menu_categories menu_categories_restaurant_id_name_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_categories
    ADD CONSTRAINT menu_categories_restaurant_id_name_key UNIQUE (restaurant_id, name);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (menu_item_id);


--
-- Name: menu_items menu_items_restaurant_id_name_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_items
    ADD CONSTRAINT menu_items_restaurant_id_name_key UNIQUE (restaurant_id, name);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: payments payments_order_id_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.payments
    ADD CONSTRAINT payments_order_id_key UNIQUE (order_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: restaurant_settlements restaurant_settlements_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurant_settlements
    ADD CONSTRAINT restaurant_settlements_pkey PRIMARY KEY (settlement_id);


--
-- Name: restaurant_settlements restaurant_settlements_restaurant_id_period_start_period_en_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurant_settlements
    ADD CONSTRAINT restaurant_settlements_restaurant_id_period_start_period_en_key UNIQUE (restaurant_id, period_start, period_end);


--
-- Name: restaurants restaurants_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (restaurant_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: tariffs tariffs_name_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.tariffs
    ADD CONSTRAINT tariffs_name_key UNIQUE (name);


--
-- Name: tariffs tariffs_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.tariffs
    ADD CONSTRAINT tariffs_pkey PRIMARY KEY (tariff_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: restaurants restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (restaurant_id);


--
-- Name: idx_courier_earnings_courier; Type: INDEX; Schema: delivery_mgmt; Owner: postgres
--

CREATE INDEX idx_courier_earnings_courier ON delivery_mgmt.courier_earnings USING btree (courier_id);


--
-- Name: idx_courier_shifts_courier; Type: INDEX; Schema: delivery_mgmt; Owner: postgres
--

CREATE INDEX idx_courier_shifts_courier ON delivery_mgmt.courier_shifts USING btree (courier_id);


--
-- Name: idx_expenses_category; Type: INDEX; Schema: delivery_mgmt; Owner: postgres
--

CREATE INDEX idx_expenses_category ON delivery_mgmt.expenses USING btree (expense_category_id);


--
-- Name: idx_expenses_date; Type: INDEX; Schema: delivery_mgmt; Owner: postgres
--

CREATE INDEX idx_expenses_date ON delivery_mgmt.expenses USING btree (expense_date);


--
-- Name: courier_earnings courier_earnings_courier_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_earnings
    ADD CONSTRAINT courier_earnings_courier_id_fkey FOREIGN KEY (courier_id) REFERENCES delivery_mgmt.couriers(courier_id) ON DELETE RESTRICT;


--
-- Name: courier_earnings courier_earnings_order_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_earnings
    ADD CONSTRAINT courier_earnings_order_id_fkey FOREIGN KEY (order_id) REFERENCES delivery_mgmt.orders(order_id) ON DELETE SET NULL;


--
-- Name: courier_earnings courier_earnings_shift_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_earnings
    ADD CONSTRAINT courier_earnings_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES delivery_mgmt.courier_shifts(shift_id) ON DELETE SET NULL;


--
-- Name: courier_payouts courier_payouts_courier_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_payouts
    ADD CONSTRAINT courier_payouts_courier_id_fkey FOREIGN KEY (courier_id) REFERENCES delivery_mgmt.couriers(courier_id) ON DELETE RESTRICT;


--
-- Name: courier_payouts courier_payouts_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_payouts
    ADD CONSTRAINT courier_payouts_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES delivery_mgmt.users(user_id) ON DELETE SET NULL;


--
-- Name: courier_shifts courier_shifts_courier_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_shifts
    ADD CONSTRAINT courier_shifts_courier_id_fkey FOREIGN KEY (courier_id) REFERENCES delivery_mgmt.couriers(courier_id) ON DELETE RESTRICT;


--
-- Name: courier_shifts courier_shifts_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.courier_shifts
    ADD CONSTRAINT courier_shifts_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES delivery_mgmt.users(user_id) ON DELETE SET NULL;


--
-- Name: customer_addresses customer_addresses_address_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.customer_addresses
    ADD CONSTRAINT customer_addresses_address_id_fkey FOREIGN KEY (address_id) REFERENCES delivery_mgmt.addresses(address_id) ON DELETE RESTRICT;


--
-- Name: customer_addresses customer_addresses_customer_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.customer_addresses
    ADD CONSTRAINT customer_addresses_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES delivery_mgmt.customers(customer_id) ON DELETE CASCADE;


--
-- Name: deliveries deliveries_courier_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.deliveries
    ADD CONSTRAINT deliveries_courier_id_fkey FOREIGN KEY (courier_id) REFERENCES delivery_mgmt.couriers(courier_id) ON DELETE SET NULL;


--
-- Name: deliveries deliveries_order_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.deliveries
    ADD CONSTRAINT deliveries_order_id_fkey FOREIGN KEY (order_id) REFERENCES delivery_mgmt.orders(order_id) ON DELETE CASCADE;


--
-- Name: expenses expenses_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expenses
    ADD CONSTRAINT expenses_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES delivery_mgmt.users(user_id) ON DELETE SET NULL;


--
-- Name: expenses expenses_expense_category_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expenses
    ADD CONSTRAINT expenses_expense_category_id_fkey FOREIGN KEY (expense_category_id) REFERENCES delivery_mgmt.expense_categories(expense_category_id) ON DELETE RESTRICT;


--
-- Name: expenses expenses_related_courier_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expenses
    ADD CONSTRAINT expenses_related_courier_id_fkey FOREIGN KEY (related_courier_id) REFERENCES delivery_mgmt.couriers(courier_id) ON DELETE SET NULL;


--
-- Name: expenses expenses_related_order_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.expenses
    ADD CONSTRAINT expenses_related_order_id_fkey FOREIGN KEY (related_order_id) REFERENCES delivery_mgmt.orders(order_id) ON DELETE SET NULL;


--
-- Name: menu_categories menu_categories_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_categories
    ADD CONSTRAINT menu_categories_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(restaurant_id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_category_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_items
    ADD CONSTRAINT menu_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES delivery_mgmt.menu_categories(category_id) ON DELETE SET NULL;


--
-- Name: menu_items menu_items_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.menu_items
    ADD CONSTRAINT menu_items_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(restaurant_id) ON DELETE CASCADE;


--
-- Name: order_items order_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES delivery_mgmt.menu_items(menu_item_id) ON DELETE RESTRICT;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES delivery_mgmt.orders(order_id) ON DELETE CASCADE;


--
-- Name: orders orders_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders
    ADD CONSTRAINT orders_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES delivery_mgmt.users(user_id) ON DELETE SET NULL;


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES delivery_mgmt.customers(customer_id) ON DELETE RESTRICT;


--
-- Name: orders orders_delivery_address_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders
    ADD CONSTRAINT orders_delivery_address_id_fkey FOREIGN KEY (delivery_address_id) REFERENCES delivery_mgmt.addresses(address_id) ON DELETE RESTRICT;


--
-- Name: orders orders_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders
    ADD CONSTRAINT orders_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES delivery_mgmt.restaurants(restaurant_id) ON DELETE RESTRICT;


--
-- Name: orders orders_tariff_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.orders
    ADD CONSTRAINT orders_tariff_id_fkey FOREIGN KEY (tariff_id) REFERENCES delivery_mgmt.tariffs(tariff_id) ON DELETE SET NULL;


--
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES delivery_mgmt.orders(order_id) ON DELETE CASCADE;


--
-- Name: restaurant_settlements restaurant_settlements_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurant_settlements
    ADD CONSTRAINT restaurant_settlements_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES delivery_mgmt.users(user_id) ON DELETE SET NULL;


--
-- Name: restaurant_settlements restaurant_settlements_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurant_settlements
    ADD CONSTRAINT restaurant_settlements_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES delivery_mgmt.restaurants(restaurant_id) ON DELETE RESTRICT;


--
-- Name: restaurants restaurants_address_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.restaurants
    ADD CONSTRAINT restaurants_address_id_fkey FOREIGN KEY (address_id) REFERENCES delivery_mgmt.addresses(address_id) ON DELETE SET NULL;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES delivery_mgmt.roles(role_id) ON DELETE RESTRICT;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: delivery_mgmt; Owner: postgres
--

ALTER TABLE ONLY delivery_mgmt.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES delivery_mgmt.users(user_id) ON DELETE CASCADE;


--
-- Name: restaurants restaurants_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_address_id_fkey FOREIGN KEY (address_id) REFERENCES delivery_mgmt.addresses(address_id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 5pX1Y2DzVCec3JD3CUqd3MelNpLuvTf0k998k8XGAvkD5V73lCT6XfOcd1KPZsD

