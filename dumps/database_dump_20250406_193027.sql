--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Homebrew)
-- Dumped by pg_dump version 14.17 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.wishlist DROP CONSTRAINT IF EXISTS wishlist_product_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.wishlist DROP CONSTRAINT IF EXISTS wishlist_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.wishlist DROP CONSTRAINT IF EXISTS wishlist_email_fkey1;
ALTER TABLE IF EXISTS ONLY public.wishlist DROP CONSTRAINT IF EXISTS wishlist_email_fkey;
ALTER TABLE IF EXISTS ONLY public.user_preferences DROP CONSTRAINT IF EXISTS user_preferences_email_fkey1;
ALTER TABLE IF EXISTS ONLY public.user_preferences DROP CONSTRAINT IF EXISTS user_preferences_email_fkey;
ALTER TABLE IF EXISTS ONLY public.user_preferences DROP CONSTRAINT IF EXISTS user_preferences_category_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.user_preferences DROP CONSTRAINT IF EXISTS user_preferences_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_product_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_email_fkey1;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_email_fkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_variations DROP CONSTRAINT IF EXISTS product_variations_product_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.product_variations DROP CONSTRAINT IF EXISTS product_variations_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_logs DROP CONSTRAINT IF EXISTS product_logs_product_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.product_logs DROP CONSTRAINT IF EXISTS product_logs_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.product_logs DROP CONSTRAINT IF EXISTS product_logs_admin_id_fkey1;
ALTER TABLE IF EXISTS ONLY public.product_logs DROP CONSTRAINT IF EXISTS product_logs_admin_id_fkey;
DROP INDEX IF EXISTS public.wishlist_email_product_id_idx1;
DROP INDEX IF EXISTS public.wishlist_email_product_id_idx;
DROP INDEX IF EXISTS public.user_preferences_email_category_id_idx1;
DROP INDEX IF EXISTS public.user_preferences_email_category_id_idx;
DROP INDEX IF EXISTS public.product_variations_product_id_size_color_idx1;
DROP INDEX IF EXISTS public.product_variations_product_id_size_color_idx;
ALTER TABLE IF EXISTS ONLY public.wishlist DROP CONSTRAINT IF EXISTS wishlist_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_preferences DROP CONSTRAINT IF EXISTS user_preferences_pkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_pkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.product_variations DROP CONSTRAINT IF EXISTS product_variations_pkey;
ALTER TABLE IF EXISTS ONLY public.product_logs DROP CONSTRAINT IF EXISTS product_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_name_key;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_username_key;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_pkey;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_email_key;
ALTER TABLE IF EXISTS public.wishlist ALTER COLUMN wishlist_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_preferences ALTER COLUMN preference_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.reviews ALTER COLUMN review_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.products ALTER COLUMN product_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.product_variations ALTER COLUMN variation_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.product_logs ALTER COLUMN log_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categories ALTER COLUMN category_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.admins ALTER COLUMN admin_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.wishlist_wishlist_id_seq;
DROP TABLE IF EXISTS public.wishlist;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_preferences_preference_id_seq;
DROP TABLE IF EXISTS public.user_preferences;
DROP SEQUENCE IF EXISTS public.reviews_review_id_seq;
DROP TABLE IF EXISTS public.reviews;
DROP SEQUENCE IF EXISTS public.products_product_id_seq;
DROP TABLE IF EXISTS public.products;
DROP SEQUENCE IF EXISTS public.product_variations_variation_id_seq;
DROP TABLE IF EXISTS public.product_variations;
DROP SEQUENCE IF EXISTS public.product_logs_log_id_seq;
DROP TABLE IF EXISTS public.product_logs;
DROP SEQUENCE IF EXISTS public.categories_category_id_seq;
DROP TABLE IF EXISTS public.categories;
DROP SEQUENCE IF EXISTS public.admins_admin_id_seq;
DROP TABLE IF EXISTS public.admins;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.admins (
    admin_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admins OWNER TO jaspartapgoomer;

--
-- Name: admins_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.admins_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_admin_id_seq OWNER TO jaspartapgoomer;

--
-- Name: admins_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.admins_admin_id_seq OWNED BY public.admins.admin_id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.categories OWNER TO jaspartapgoomer;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_category_id_seq OWNER TO jaspartapgoomer;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: product_logs; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.product_logs (
    log_id integer NOT NULL,
    product_id integer,
    admin_id integer NOT NULL,
    action_type character varying(50),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.product_logs OWNER TO jaspartapgoomer;

--
-- Name: product_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.product_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_logs_log_id_seq OWNER TO jaspartapgoomer;

--
-- Name: product_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.product_logs_log_id_seq OWNED BY public.product_logs.log_id;


--
-- Name: product_variations; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.product_variations (
    variation_id integer NOT NULL,
    product_id integer NOT NULL,
    size character varying(20) NOT NULL,
    color character varying(50) NOT NULL
);


ALTER TABLE public.product_variations OWNER TO jaspartapgoomer;

--
-- Name: product_variations_variation_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.product_variations_variation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_variations_variation_id_seq OWNER TO jaspartapgoomer;

--
-- Name: product_variations_variation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.product_variations_variation_id_seq OWNED BY public.product_variations.variation_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category_id integer NOT NULL,
    picture_url character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO jaspartapgoomer;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_product_id_seq OWNER TO jaspartapgoomer;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    email character varying(100) NOT NULL,
    product_id integer NOT NULL,
    rating integer,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.reviews OWNER TO jaspartapgoomer;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_review_id_seq OWNER TO jaspartapgoomer;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.user_preferences (
    preference_id integer NOT NULL,
    email character varying(100) NOT NULL,
    category_id integer NOT NULL,
    preferred_size character varying(20),
    preferred_color character varying(50)
);


ALTER TABLE public.user_preferences OWNER TO jaspartapgoomer;

--
-- Name: user_preferences_preference_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.user_preferences_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_preferences_preference_id_seq OWNER TO jaspartapgoomer;

--
-- Name: user_preferences_preference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.user_preferences_preference_id_seq OWNED BY public.user_preferences.preference_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.users (
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    birthdate date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO jaspartapgoomer;

--
-- Name: wishlist; Type: TABLE; Schema: public; Owner: jaspartapgoomer
--

CREATE TABLE public.wishlist (
    wishlist_id integer NOT NULL,
    email character varying(100) NOT NULL,
    product_id integer NOT NULL,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.wishlist OWNER TO jaspartapgoomer;

--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE; Schema: public; Owner: jaspartapgoomer
--

CREATE SEQUENCE public.wishlist_wishlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wishlist_wishlist_id_seq OWNER TO jaspartapgoomer;

--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jaspartapgoomer
--

ALTER SEQUENCE public.wishlist_wishlist_id_seq OWNED BY public.wishlist.wishlist_id;


--
-- Name: admins admin_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.admins ALTER COLUMN admin_id SET DEFAULT nextval('public.admins_admin_id_seq'::regclass);


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: product_logs log_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_logs ALTER COLUMN log_id SET DEFAULT nextval('public.product_logs_log_id_seq'::regclass);


--
-- Name: product_variations variation_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_variations ALTER COLUMN variation_id SET DEFAULT nextval('public.product_variations_variation_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- Name: user_preferences preference_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.user_preferences ALTER COLUMN preference_id SET DEFAULT nextval('public.user_preferences_preference_id_seq'::regclass);


--
-- Name: wishlist wishlist_id; Type: DEFAULT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.wishlist ALTER COLUMN wishlist_id SET DEFAULT nextval('public.wishlist_wishlist_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.admins (admin_id, username, email, password_hash, created_at) FROM stdin;
1	bohdan	b@gmail.com	123	2025-03-30 17:54:34.630729
2	JaspartapGoomer	jaspartapgoomer@gmail.com	Jaspartap@15	2025-03-30 19:23:19.502969
3	admin	admin@example.com	123	2025-03-30 19:23:46.299111
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.categories (category_id, name) FROM stdin;
6	Jacket And Vests
7	Hoodie
8	Quarter Sleeves
9	Shorts
10	Long Sleeves
11	Hoodies & Sweatshirt
12	Tights
13	TShirts
14	Polo
\.


--
-- Data for Name: product_logs; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.product_logs (log_id, product_id, admin_id, action_type, "timestamp") FROM stdin;
5	\N	1	Added	2025-03-30 19:24:43.997545
7	\N	3	Deleted	2025-03-30 19:26:10.058183
1	\N	1	Added	2025-03-30 18:01:52.45135
2	\N	1	Edited	2025-03-30 18:41:13.924586
3	\N	1	Edited	2025-03-30 18:44:59.922386
4	\N	1	Edited	2025-03-30 19:24:24.385629
6	\N	3	Edited	2025-03-30 19:26:10.056347
11	\N	3	Added Variation	2025-03-30 19:47:46.612025
12	\N	3	Added Variation	2025-03-30 19:47:53.469117
16	\N	3	Deleted	2025-03-31 21:45:07.250202
8	\N	3	Added	2025-03-30 19:27:19.109748
9	\N	3	Added Variation	2025-03-30 19:47:35.706318
10	\N	3	Added Variation	2025-03-30 19:47:41.143697
13	\N	3	Added Variation	2025-03-30 19:51:10.571597
14	\N	3	Edited	2025-03-31 18:19:08.079842
15	\N	3	Added Variation	2025-03-31 18:19:27.749261
17	\N	3	Deleted	2025-03-31 21:46:11.941757
18	5	3	Added	2025-03-31 21:50:57.066606
19	6	3	Added	2025-03-31 21:51:59.189713
20	5	3	Added Variation	2025-03-31 21:52:07.419909
21	5	3	Added Variation	2025-03-31 21:52:13.12316
22	6	3	Added Variation	2025-03-31 21:52:28.420075
23	6	3	Added Variation	2025-03-31 21:52:42.854366
24	7	3	Added	2025-03-31 21:53:47.351094
25	7	3	Added Variation	2025-03-31 21:54:07.606875
26	7	3	Added Variation	2025-03-31 21:54:15.447017
27	8	3	Added	2025-03-31 21:56:55.02206
28	8	3	Added Variation	2025-03-31 21:57:03.720933
29	8	3	Added Variation	2025-03-31 21:57:08.593146
30	9	3	Added	2025-03-31 21:59:42.749518
31	9	3	Added Variation	2025-03-31 21:59:58.654473
32	9	3	Added Variation	2025-03-31 22:00:02.636653
33	9	3	Added Variation	2025-03-31 22:00:10.410414
34	10	3	Added	2025-03-31 22:01:24.103972
35	10	3	Added Variation	2025-03-31 22:01:50.741096
36	10	3	Added Variation	2025-03-31 22:01:55.006722
37	10	3	Added Variation	2025-03-31 22:02:03.498082
38	11	3	Added	2025-03-31 22:03:29.451976
39	11	3	Added Variation	2025-03-31 22:03:40.579424
40	12	3	Added	2025-03-31 22:05:02.58046
41	12	3	Added Variation	2025-03-31 22:05:16.265519
42	12	3	Added Variation	2025-03-31 22:05:24.338214
43	13	3	Added	2025-03-31 22:06:56.082755
44	13	3	Added Variation	2025-03-31 22:07:51.530868
45	13	3	Added Variation	2025-03-31 22:08:38.901249
46	14	3	Added	2025-03-31 22:10:35.846683
47	14	3	Added Variation	2025-03-31 22:10:53.555129
48	14	3	Added Variation	2025-03-31 22:10:58.948664
49	15	3	Added	2025-03-31 22:12:25.388176
50	15	3	Added Variation	2025-03-31 22:12:34.913685
51	15	3	Added Variation	2025-03-31 22:12:39.470046
52	16	3	Added	2025-03-31 22:13:30.565865
53	16	3	Added Variation	2025-03-31 22:13:40.476473
54	16	3	Added Variation	2025-03-31 22:13:44.871847
55	17	3	Added	2025-03-31 22:14:54.896965
56	17	3	Added Variation	2025-03-31 22:15:06.018519
57	17	3	Added Variation	2025-03-31 22:15:12.002821
58	18	3	Added	2025-03-31 22:16:19.607187
59	18	3	Added Variation	2025-03-31 22:16:43.304969
60	18	3	Added Variation	2025-03-31 22:16:47.996167
61	18	3	Added Variation	2025-03-31 22:17:52.5507
62	18	3	Added Variation	2025-03-31 22:17:56.905469
63	19	3	Added	2025-03-31 22:18:41.578852
64	19	3	Added Variation	2025-03-31 22:18:52.434741
65	20	3	Added	2025-03-31 22:20:06.792262
66	20	3	Edited	2025-03-31 22:20:30.909264
67	20	3	Added Variation	2025-03-31 22:20:44.393675
68	20	3	Added Variation	2025-03-31 22:20:50.401431
69	21	3	Added	2025-03-31 22:21:42.773898
70	21	3	Added Variation	2025-03-31 22:21:52.566922
71	21	3	Added Variation	2025-03-31 22:21:56.48996
72	22	3	Added	2025-03-31 22:23:09.573231
73	22	3	Added Variation	2025-03-31 22:23:18.791017
74	22	3	Added Variation	2025-03-31 22:24:07.645563
75	23	3	Added	2025-03-31 22:25:15.216573
76	23	3	Added Variation	2025-03-31 22:25:27.890892
77	23	3	Added Variation	2025-03-31 22:25:34.340692
78	24	3	Added	2025-03-31 22:26:25.327955
79	24	3	Added Variation	2025-03-31 22:26:35.150069
80	24	3	Added Variation	2025-03-31 22:26:39.431052
81	25	3	Added	2025-03-31 22:28:04.360663
82	25	3	Added Variation	2025-03-31 22:28:13.252698
83	25	3	Added Variation	2025-03-31 22:28:17.897161
84	26	3	Added	2025-03-31 22:29:22.341666
85	25	3	Added Variation	2025-03-31 22:29:27.9894
86	25	3	Added Variation	2025-03-31 22:29:33.14597
87	27	3	Added	2025-04-01 12:22:49.790503
88	27	3	Added Variation	2025-04-01 12:23:14.766641
89	5	3	Edited	2025-04-06 19:28:04.450108
\.


--
-- Data for Name: product_variations; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.product_variations (variation_id, product_id, size, color) FROM stdin;
7	5	L	Black
8	5	M	Black
9	6	L	Black
10	6	S	Black
11	7	L	Navy
12	7	M	Navy
13	8	L	Green
14	8	M	Green
15	9	S	Black
16	9	M	Black
17	9	L	Black
18	10	M	Black
19	10	S	Black
20	10	S	White
21	11	S	Black
22	12	S	Black
23	12	XL	Black
24	13	S	Black
25	13	M	Black
26	14	M	Black
27	14	S	Black
28	15	S	Black
29	15	M	White
30	16	S	Grey
31	16	M	Grey
32	17	S	Navy
33	17	M	Navy
34	18	S	Gray
35	18	M	Gray
36	18	S	Blue
37	18	M	Blue
38	19	S	Black
39	20	S	Blue
40	20	M	Blue
41	21	M	White
42	21	L	White
43	22	S	Black
44	22	M	Black
45	23	S	Grey
46	23	M	Grey
47	24	S	Black
48	24	M	Black
49	25	S	Black
50	25	M	Black
51	25	S	Navy
52	25	M	Navy
53	27	S	Navy
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.products (product_id, name, description, price, category_id, picture_url, created_at, updated_at) FROM stdin;
6	Helly Hansen Dubliner Jacket	Helly Hansen Men's Dubliner Jacket	169.99	6	hh-mens-dubliner-jacket-s19-black-990-s--ed8424d7-3022-41ac-9f4f-b367ef7b9b18-jpgrendition.jpg	2025-03-31 21:50:57.067979	2025-03-31 21:50:57.067979
7	Helly Hansen Crew Jacket	Helly Hansen Men's Crew Jacket 2.0	199.99	6	helly-hansen-men-s-crew-jacket-2-0-1024-nvy-bf8a5713-2a3c-4c5a-8a01-77b093f43e42-jpgrendition.jpg	2025-03-31 21:52:42.85522	2025-03-31 21:52:42.85522
8	Under Armour Short Sleeve Hoodie	Under Armour Men's Project Rock Short Sleeve Hoodie	56.97	7	under-armour-men-s-project-rock-essential-pullover-short-sleeve-hoodie-eca4ad08-d242-4a59-8375-4efa53ec5c38-jpgrendition.jpg	2025-03-31 21:56:34.084331	2025-03-31 21:56:34.084331
9	FWD Three Quarter Sleeve Top	FWD Men's Sportswear Henley Three Quarter Sleeve Top	14.97	8	fwd-men-s-sportswear-henley-3-4-sleeve-top-a187ef98-cd71-4d2a-bfe3-7a9d2386a5e8-jpgrendition.jpg	2025-03-31 21:57:41.196958	2025-03-31 21:57:41.196958
10	adidas All SZN Shorts	adidas Men's Sportswear All SZN Shorts	26.97	9	adidas-men-s-sportswear-all-szn-shorts-2094055a-0dcd-48a1-b01f-9c4f89082050-jpgrendition.jpg	2025-03-31 22:00:40.934116	2025-03-31 22:00:40.934116
11	adidas Long Sleeve Shirt	adidas Men's Own The Run Long Sleeve Shirt	60.00	10	adidas-own-the-run-b-ls-q224-black-1b8cec0d-5a56-40ab-bf00-3f0346154c10-jpgrendition.jpg	2025-03-31 22:02:24.786113	2025-03-31 22:02:24.786113
12	Under Armour Essential Fleece Sweatshirt	Under Armour Men's Essential Fleece Sweatshirt	45.50	10	ua-essential-fleece-crew-q323-pitch-grey-0975f8da-69f1-45eb-8ecd-397e71c31d8d-jpgrendition.jpg	2025-03-31 22:03:40.58149	2025-03-31 22:03:40.58149
13	Nike Pullover Hoodie	Nike Sportswear Men's Club BB Pullover Hoodie	80.00	11	nike-nsw-club-bb-p-o-hoody-q-black-s--eb790963-9d19-40dd-92da-18d0429746d7-jpgrendition.jpg	2025-03-31 22:05:58.747364	2025-03-31 22:05:58.747364
14	Under Armour Elite Leggings	Under Armour Men's ColdGear© Elite Leggings	85.00	7	ua-coldgear-elite-leggings-q424-black-844ff93c-4e08-41a6-9729-4e8c4c4341b6-jpgrendition-2.jpg	2025-03-31 22:09:09.734526	2025-03-31 22:09:09.734526
15	Lotto Soccer Jersey	Lotto Men's Wesburn Soccer Jersey	21.97	13	lotto-men-s-wesburn-soccer-jersey-6a891164-211f-41fc-8e30-69a138e4e440-jpgrendition.jpg	2025-03-31 22:12:02.805181	2025-03-31 22:12:02.805181
16	Under Armour Training Hoodie	Under Armour Men's Tech 2.0 Training Hoodie	49.99	11	ua-tech-2-0-p-o-hoody-q120-pitch-gray-s--39c58e3f-93c6-4e7d-b136-0161945ca723-jpgrendition.jpg	2025-03-31 22:12:39.471179	2025-03-31 22:12:39.471179
17	Under Armour Long Sleeve Shirt	Under Armour Men's Run Everywhere Long Sleeve Shirt	26.97	13	under-armour-men-s-run-everywhere-long-sleeve-shirt-ff5f46d1-10c0-469c-9dda-1086fc6320b7-jpgrendition.jpg	2025-03-31 22:13:44.873023	2025-03-31 22:13:44.873023
18	Carhartt TShirt	Carhartt Men's Logo Graphic T Shirt	39.99	13	carhartt-men-s-logo-graphic-t-shirt-15cf8a4b-28ae-43a3-9cfb-9733ceb35291-jpgrendition.jpg	2025-03-31 22:15:12.003683	2025-03-31 22:15:12.003683
19	Carhartt T Shirt	Carhartt Men's Force Midweight Pocket T Shirt	39.99	13	carhartt-m-force-mw-ss-pocket-tee-malt-q125--045e4626-d141-4767-bd71-6254f65fb8e8-jpgrendition.jpg	2025-03-31 22:17:56.906281	2025-03-31 22:17:56.906281
20	TravisMathew  Polo Shirt	TravisMathew Men's The Heater Golf Polo Shirt	88.97	13	travis-mathew-m-the-heater-polo-q124-stellar-bl-8ec719a7-b79a-460c-b005-e3afa1e9f619-jpgrendition.jpg	2025-03-31 22:19:05.940156	2025-03-31 22:20:06.793006
21	TravisMathew Polo	TravisMathew Men's Call The Shots Golf Polo Shirt	96.97	14	travis-mathew-m-call-the-shots-polo-q124-lt-gr-3c1f4b76-6c63-41e9-b7c7-a5dc9ce1d3a0-jpgrendition.jpg	2025-03-31 22:20:50.402535	2025-03-31 22:20:50.402535
22	Under Armour Pants	Under Armour Men's Vital Woven Training Pants	49.99	12	ua-vital-woven-training-pants-black-s--2d0fb4cb-781b-472c-a578-8655ac6669e5-jpgrendition.jpg	2025-03-31 22:21:56.491083	2025-03-31 22:21:56.491083
23	Under Armour Sweatpants	Under Armour Men's Sportstyle Jogger Sweatpants	70.00	12	under-armour-men-s-tricot-jogger-pants-0edd05d6-a524-43a3-a225-f057241cab92-jpgrendition.jpg	2025-03-31 22:24:07.646089	2025-03-31 22:24:07.646089
24	Reebok Cargo Pants	Reebok Men's Active Sky Stretch Woven Cargo Pants	71.97	12	reebok-men-s-active-sky-stretch-woven-cargo-pants-de48b10e-e273-4a5f-accc-29cdf262e90b-jpgrendition.jpg	2025-03-31 22:25:34.341652	2025-03-31 22:25:34.341652
25	Under Armour Shorts	Under Armour Men's Tech Mesh 9 Inch Regular Fit Shorts	35.00	9	ua-tech-mesh-short-q219-black-pitch-gray-s--c1db5ec2-0e88-4a2d-baf4-8dc1f95220b7-jpgrendition.jpg	2025-03-31 22:28:04.357398	2025-03-31 22:28:04.357398
26	Nike Jogger Pants	Nike Sportswear Men's Club Brushed Back Jogger Pants	75.00	12	nike-nsw-club-bb-jogger-pant-410-navy-s--224b2c6d-96f8-46eb-a338-cd99c61808fc-jpgrendition.jpg	2025-03-31 22:28:17.897933	2025-03-31 22:28:17.897933
27	Ontario Tech Hoodie	Hoodie	30.00	7	OntarioTech.jpeg	2025-04-01 11:10:51.01056	2025-04-01 11:10:51.01056
5	Trial Product	Helly Hansen Men's Vancouver Rain Jacket	130.00	6	helly-hansen-men-s-vancouver-rain-jacket-1d32dca1-71ae-4938-9607-6c5ea477d458-jpgrendition.jpg	2025-03-31 21:50:15.980531	2025-04-06 19:24:11.490973
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.reviews (review_id, email, product_id, rating, comment, created_at) FROM stdin;
1	info@jaspartapgoomer.com	9	5	Amazing quality	2025-04-03 14:58:34.873056
2	trial@example.com	9	3	Not that great	2025-04-03 15:01:33.218794
\.


--
-- Data for Name: user_preferences; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.user_preferences (preference_id, email, category_id, preferred_size, preferred_color) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.users (email, password_hash, first_name, last_name, birthdate, created_at) FROM stdin;
info@jaspartapgoomer.com	123	Jaspartap	Goomer	\N	2025-03-30 17:43:37.999602
someone@example.com	Jaspartap@15	Jane	Doe	\N	2025-04-03 14:59:13.433916
trial@example.com	123	Trial	Account	\N	2025-04-03 15:00:33.713189
trial@trial.com	123	trial	Acount	\N	2025-04-06 23:26:42.324279
\.


--
-- Data for Name: wishlist; Type: TABLE DATA; Schema: public; Owner: jaspartapgoomer
--

COPY public.wishlist (wishlist_id, email, product_id, added_at) FROM stdin;
16	info@jaspartapgoomer.com	27	2025-04-01 16:23:24.940163
19	trial@example.com	7	2025-04-06 21:03:34.105651
20	trial@example.com	5	2025-04-06 23:15:40.125448
21	trial@trial.com	5	2025-04-06 23:27:07.074471
\.


--
-- Name: admins_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.admins_admin_id_seq', 3, true);


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 18, true);


--
-- Name: product_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.product_logs_log_id_seq', 89, true);


--
-- Name: product_variations_variation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.product_variations_variation_id_seq', 53, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.products_product_id_seq', 27, true);


--
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 2, true);


--
-- Name: user_preferences_preference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.user_preferences_preference_id_seq', 1, false);


--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jaspartapgoomer
--

SELECT pg_catalog.setval('public.wishlist_wishlist_id_seq', 22, true);


--
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);


--
-- Name: admins admins_username_key; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: product_logs product_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_pkey PRIMARY KEY (log_id);


--
-- Name: product_variations product_variations_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_pkey PRIMARY KEY (variation_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- Name: user_preferences user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (preference_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (email);


--
-- Name: wishlist wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (wishlist_id);


--
-- Name: product_variations_product_id_size_color_idx; Type: INDEX; Schema: public; Owner: jaspartapgoomer
--

CREATE UNIQUE INDEX product_variations_product_id_size_color_idx ON public.product_variations USING btree (product_id, size, color);


--
-- Name: product_variations_product_id_size_color_idx1; Type: INDEX; Schema: public; Owner: jaspartapgoomer
--

CREATE UNIQUE INDEX product_variations_product_id_size_color_idx1 ON public.product_variations USING btree (product_id, size, color);


--
-- Name: user_preferences_email_category_id_idx; Type: INDEX; Schema: public; Owner: jaspartapgoomer
--

CREATE UNIQUE INDEX user_preferences_email_category_id_idx ON public.user_preferences USING btree (email, category_id);


--
-- Name: user_preferences_email_category_id_idx1; Type: INDEX; Schema: public; Owner: jaspartapgoomer
--

CREATE UNIQUE INDEX user_preferences_email_category_id_idx1 ON public.user_preferences USING btree (email, category_id);


--
-- Name: wishlist_email_product_id_idx; Type: INDEX; Schema: public; Owner: jaspartapgoomer
--

CREATE UNIQUE INDEX wishlist_email_product_id_idx ON public.wishlist USING btree (email, product_id);


--
-- Name: wishlist_email_product_id_idx1; Type: INDEX; Schema: public; Owner: jaspartapgoomer
--

CREATE UNIQUE INDEX wishlist_email_product_id_idx1 ON public.wishlist USING btree (email, product_id);


--
-- Name: product_logs product_logs_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admins(admin_id) ON DELETE SET NULL;


--
-- Name: product_logs product_logs_admin_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_admin_id_fkey1 FOREIGN KEY (admin_id) REFERENCES public.admins(admin_id) ON DELETE SET NULL;


--
-- Name: product_logs product_logs_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE SET NULL;


--
-- Name: product_logs product_logs_product_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_product_id_fkey1 FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE SET NULL;


--
-- Name: product_variations product_variations_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: product_variations product_variations_product_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_product_id_fkey1 FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- Name: products products_category_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey1 FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- Name: reviews reviews_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: reviews reviews_email_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_email_fkey1 FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_product_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey1 FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: user_preferences user_preferences_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- Name: user_preferences user_preferences_category_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_category_id_fkey1 FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- Name: user_preferences user_preferences_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: user_preferences user_preferences_email_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_email_fkey1 FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_email_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_email_fkey1 FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_product_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: jaspartapgoomer
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_product_id_fkey1 FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

