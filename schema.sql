--
-- PostgreSQL database dump
--

\restrict b6eFpvPmc40BxQNF8D9bdoemgMqq9KIjHkIADmdkIlGijsBGIEBfMx1TWaRW14e

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
-- Name: user_roles; Type: TABLE; Schema: delivery_mgmt; Owner: postgres
--

CREATE TABLE delivery_mgmt.user_roles (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE delivery_mgmt.user_roles OWNER TO postgres;

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

\unrestrict b6eFpvPmc40BxQNF8D9bdoemgMqq9KIjHkIADmdkIlGijsBGIEBfMx1TWaRW14e

