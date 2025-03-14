PGDMP                 	        }           flexwear    14.17 (Homebrew)    14.17 (Homebrew) X    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    flexwear    DATABASE     S   CREATE DATABASE flexwear WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';
    DROP DATABASE flexwear;
                bohdansynytskyi    false            �            1259    16448    admins    TABLE     �   CREATE TABLE public.admins (
    admin_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.admins;
       public         heap    bohdansynytskyi    false            �            1259    16447    admins_admin_id_seq    SEQUENCE     �   CREATE SEQUENCE public.admins_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.admins_admin_id_seq;
       public          bohdansynytskyi    false    223            �           0    0    admins_admin_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.admins_admin_id_seq OWNED BY public.admins.admin_id;
          public          bohdansynytskyi    false    222            �            1259    16394 
   categories    TABLE     n   CREATE TABLE public.categories (
    category_id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.categories;
       public         heap    bohdansynytskyi    false            �            1259    16393    categories_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.categories_category_id_seq;
       public          bohdansynytskyi    false    211            �           0    0    categories_category_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;
          public          bohdansynytskyi    false    210            �            1259    16462    product_logs    TABLE     �   CREATE TABLE public.product_logs (
    log_id integer NOT NULL,
    product_id integer NOT NULL,
    admin_id integer NOT NULL,
    action_type character varying(50),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
     DROP TABLE public.product_logs;
       public         heap    bohdansynytskyi    false            �            1259    16461    product_logs_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_logs_log_id_seq;
       public          bohdansynytskyi    false    225            �           0    0    product_logs_log_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_logs_log_id_seq OWNED BY public.product_logs.log_id;
          public          bohdansynytskyi    false    224            �            1259    16415    product_variations    TABLE     �   CREATE TABLE public.product_variations (
    variation_id integer NOT NULL,
    product_id integer NOT NULL,
    size character varying(20) NOT NULL,
    color character varying(50) NOT NULL,
    stock_quantity integer DEFAULT 0
);
 &   DROP TABLE public.product_variations;
       public         heap    bohdansynytskyi    false            �            1259    16414 #   product_variations_variation_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_variations_variation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.product_variations_variation_id_seq;
       public          bohdansynytskyi    false    215            �           0    0 #   product_variations_variation_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.product_variations_variation_id_seq OWNED BY public.product_variations.variation_id;
          public          bohdansynytskyi    false    214            �            1259    16403    products    TABLE     x  CREATE TABLE public.products (
    product_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category_id integer NOT NULL,
    stock_quantity integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.products;
       public         heap    bohdansynytskyi    false            �            1259    16402    products_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_product_id_seq;
       public          bohdansynytskyi    false    213            �           0    0    products_product_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;
          public          bohdansynytskyi    false    212            �            1259    16523    public.users    TABLE     �   CREATE TABLE public."public.users" (
    id integer NOT NULL,
    email character varying,
    password character varying,
    name character varying,
    birthdate character varying
);
 "   DROP TABLE public."public.users";
       public         heap    bohdansynytskyi    false            �            1259    16522    public.users_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."public.users_id_seq";
       public          bohdansynytskyi    false    227            �           0    0    public.users_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."public.users_id_seq" OWNED BY public."public.users".id;
          public          bohdansynytskyi    false    226            �            1259    16438    reviews    TABLE     �   CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    email character varying(100) NOT NULL,
    product_id integer NOT NULL,
    rating integer,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.reviews;
       public         heap    bohdansynytskyi    false            �            1259    16437    reviews_review_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.reviews_review_id_seq;
       public          bohdansynytskyi    false    221            �           0    0    reviews_review_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;
          public          bohdansynytskyi    false    220            �            1259    16423    user_preferences    TABLE     �   CREATE TABLE public.user_preferences (
    preference_id integer NOT NULL,
    email character varying(100) NOT NULL,
    category_id integer NOT NULL,
    preferred_size character varying(20),
    preferred_color character varying(50)
);
 $   DROP TABLE public.user_preferences;
       public         heap    bohdansynytskyi    false            �            1259    16422 "   user_preferences_preference_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_preferences_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.user_preferences_preference_id_seq;
       public          bohdansynytskyi    false    217            �           0    0 "   user_preferences_preference_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.user_preferences_preference_id_seq OWNED BY public.user_preferences.preference_id;
          public          bohdansynytskyi    false    216            �            1259    16385    users    TABLE     !  CREATE TABLE public.users (
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    birthdate date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.users;
       public         heap    bohdansynytskyi    false            �            1259    16430    wishlist    TABLE     �   CREATE TABLE public.wishlist (
    wishlist_id integer NOT NULL,
    email character varying(100) NOT NULL,
    product_id integer NOT NULL,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.wishlist;
       public         heap    bohdansynytskyi    false            �            1259    16429    wishlist_wishlist_id_seq    SEQUENCE     �   CREATE SEQUENCE public.wishlist_wishlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.wishlist_wishlist_id_seq;
       public          bohdansynytskyi    false    219            �           0    0    wishlist_wishlist_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.wishlist_wishlist_id_seq OWNED BY public.wishlist.wishlist_id;
          public          bohdansynytskyi    false    218            �           2604    16451    admins admin_id    DEFAULT     r   ALTER TABLE ONLY public.admins ALTER COLUMN admin_id SET DEFAULT nextval('public.admins_admin_id_seq'::regclass);
 >   ALTER TABLE public.admins ALTER COLUMN admin_id DROP DEFAULT;
       public          bohdansynytskyi    false    223    222    223            �           2604    16397    categories category_id    DEFAULT     �   ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);
 E   ALTER TABLE public.categories ALTER COLUMN category_id DROP DEFAULT;
       public          bohdansynytskyi    false    211    210    211            �           2604    16465    product_logs log_id    DEFAULT     z   ALTER TABLE ONLY public.product_logs ALTER COLUMN log_id SET DEFAULT nextval('public.product_logs_log_id_seq'::regclass);
 B   ALTER TABLE public.product_logs ALTER COLUMN log_id DROP DEFAULT;
       public          bohdansynytskyi    false    225    224    225            �           2604    16418    product_variations variation_id    DEFAULT     �   ALTER TABLE ONLY public.product_variations ALTER COLUMN variation_id SET DEFAULT nextval('public.product_variations_variation_id_seq'::regclass);
 N   ALTER TABLE public.product_variations ALTER COLUMN variation_id DROP DEFAULT;
       public          bohdansynytskyi    false    214    215    215            �           2604    16406    products product_id    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN product_id DROP DEFAULT;
       public          bohdansynytskyi    false    213    212    213            �           2604    16526    public.users id    DEFAULT     v   ALTER TABLE ONLY public."public.users" ALTER COLUMN id SET DEFAULT nextval('public."public.users_id_seq"'::regclass);
 @   ALTER TABLE public."public.users" ALTER COLUMN id DROP DEFAULT;
       public          bohdansynytskyi    false    227    226    227            �           2604    16441    reviews review_id    DEFAULT     v   ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);
 @   ALTER TABLE public.reviews ALTER COLUMN review_id DROP DEFAULT;
       public          bohdansynytskyi    false    220    221    221            �           2604    16426    user_preferences preference_id    DEFAULT     �   ALTER TABLE ONLY public.user_preferences ALTER COLUMN preference_id SET DEFAULT nextval('public.user_preferences_preference_id_seq'::regclass);
 M   ALTER TABLE public.user_preferences ALTER COLUMN preference_id DROP DEFAULT;
       public          bohdansynytskyi    false    217    216    217            �           2604    16433    wishlist wishlist_id    DEFAULT     |   ALTER TABLE ONLY public.wishlist ALTER COLUMN wishlist_id SET DEFAULT nextval('public.wishlist_wishlist_id_seq'::regclass);
 C   ALTER TABLE public.wishlist ALTER COLUMN wishlist_id DROP DEFAULT;
       public          bohdansynytskyi    false    219    218    219            �          0    16448    admins 
   TABLE DATA           V   COPY public.admins (admin_id, username, email, password_hash, created_at) FROM stdin;
    public          bohdansynytskyi    false    223   �o       �          0    16394 
   categories 
   TABLE DATA           7   COPY public.categories (category_id, name) FROM stdin;
    public          bohdansynytskyi    false    211   p       �          0    16462    product_logs 
   TABLE DATA           ^   COPY public.product_logs (log_id, product_id, admin_id, action_type, "timestamp") FROM stdin;
    public          bohdansynytskyi    false    225   #p       �          0    16415    product_variations 
   TABLE DATA           c   COPY public.product_variations (variation_id, product_id, size, color, stock_quantity) FROM stdin;
    public          bohdansynytskyi    false    215   @p       �          0    16403    products 
   TABLE DATA           }   COPY public.products (product_id, name, description, price, category_id, stock_quantity, created_at, updated_at) FROM stdin;
    public          bohdansynytskyi    false    213   ]p       �          0    16523    public.users 
   TABLE DATA           N   COPY public."public.users" (id, email, password, name, birthdate) FROM stdin;
    public          bohdansynytskyi    false    227   zp       �          0    16438    reviews 
   TABLE DATA           \   COPY public.reviews (review_id, email, product_id, rating, comment, created_at) FROM stdin;
    public          bohdansynytskyi    false    221   �p       �          0    16423    user_preferences 
   TABLE DATA           n   COPY public.user_preferences (preference_id, email, category_id, preferred_size, preferred_color) FROM stdin;
    public          bohdansynytskyi    false    217   �p       �          0    16385    users 
   TABLE DATA           c   COPY public.users (email, password_hash, first_name, last_name, birthdate, created_at) FROM stdin;
    public          bohdansynytskyi    false    209   �p       �          0    16430    wishlist 
   TABLE DATA           L   COPY public.wishlist (wishlist_id, email, product_id, added_at) FROM stdin;
    public          bohdansynytskyi    false    219   �q       �           0    0    admins_admin_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.admins_admin_id_seq', 1, false);
          public          bohdansynytskyi    false    222            �           0    0    categories_category_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.categories_category_id_seq', 1, false);
          public          bohdansynytskyi    false    210            �           0    0    product_logs_log_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_logs_log_id_seq', 1, false);
          public          bohdansynytskyi    false    224            �           0    0 #   product_variations_variation_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.product_variations_variation_id_seq', 1, false);
          public          bohdansynytskyi    false    214            �           0    0    products_product_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);
          public          bohdansynytskyi    false    212            �           0    0    public.users_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."public.users_id_seq"', 1, false);
          public          bohdansynytskyi    false    226            �           0    0    reviews_review_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.reviews_review_id_seq', 1, false);
          public          bohdansynytskyi    false    220            �           0    0 "   user_preferences_preference_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.user_preferences_preference_id_seq', 1, false);
          public          bohdansynytskyi    false    216            �           0    0    wishlist_wishlist_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.wishlist_wishlist_id_seq', 1, false);
          public          bohdansynytskyi    false    218                       2606    16460    admins admins_email_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);
 A   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_email_key;
       public            bohdansynytskyi    false    223                       2606    16456    admins admins_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);
 <   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_pkey;
       public            bohdansynytskyi    false    223                       2606    16458    admins admins_username_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);
 D   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_username_key;
       public            bohdansynytskyi    false    223            �           2606    16401    categories categories_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_name_key;
       public            bohdansynytskyi    false    211            �           2606    16399    categories categories_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);
 D   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_pkey;
       public            bohdansynytskyi    false    211                       2606    16468    product_logs product_logs_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_pkey PRIMARY KEY (log_id);
 H   ALTER TABLE ONLY public.product_logs DROP CONSTRAINT product_logs_pkey;
       public            bohdansynytskyi    false    225                       2606    16421 *   product_variations product_variations_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_pkey PRIMARY KEY (variation_id);
 T   ALTER TABLE ONLY public.product_variations DROP CONSTRAINT product_variations_pkey;
       public            bohdansynytskyi    false    215                       2606    16413    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            bohdansynytskyi    false    213                       2606    16530    public.users public.users_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."public.users"
    ADD CONSTRAINT "public.users_pkey" PRIMARY KEY (id);
 L   ALTER TABLE ONLY public."public.users" DROP CONSTRAINT "public.users_pkey";
       public            bohdansynytskyi    false    227                       2606    16446    reviews reviews_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);
 >   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_pkey;
       public            bohdansynytskyi    false    221                       2606    16428 &   user_preferences user_preferences_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (preference_id);
 P   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_pkey;
       public            bohdansynytskyi    false    217            �           2606    16392    users users_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (email);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            bohdansynytskyi    false    209            
           2606    16436    wishlist wishlist_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (wishlist_id);
 @   ALTER TABLE ONLY public.wishlist DROP CONSTRAINT wishlist_pkey;
       public            bohdansynytskyi    false    219                       1259    16531    ix_public.users_email    INDEX     Z   CREATE UNIQUE INDEX "ix_public.users_email" ON public."public.users" USING btree (email);
 +   DROP INDEX public."ix_public.users_email";
       public            bohdansynytskyi    false    227                       1259    16532    ix_public.users_id    INDEX     M   CREATE INDEX "ix_public.users_id" ON public."public.users" USING btree (id);
 (   DROP INDEX public."ix_public.users_id";
       public            bohdansynytskyi    false    227                       1259    16469 ,   product_variations_product_id_size_color_idx    INDEX     �   CREATE UNIQUE INDEX product_variations_product_id_size_color_idx ON public.product_variations USING btree (product_id, size, color);
 @   DROP INDEX public.product_variations_product_id_size_color_idx;
       public            bohdansynytskyi    false    215    215    215                       1259    16470 &   user_preferences_email_category_id_idx    INDEX     x   CREATE UNIQUE INDEX user_preferences_email_category_id_idx ON public.user_preferences USING btree (email, category_id);
 :   DROP INDEX public.user_preferences_email_category_id_idx;
       public            bohdansynytskyi    false    217    217                       1259    16471    wishlist_email_product_id_idx    INDEX     f   CREATE UNIQUE INDEX wishlist_email_product_id_idx ON public.wishlist USING btree (email, product_id);
 1   DROP INDEX public.wishlist_email_product_id_idx;
       public            bohdansynytskyi    false    219    219            "           2606    16517 '   product_logs product_logs_admin_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admins(admin_id) ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public.product_logs DROP CONSTRAINT product_logs_admin_id_fkey;
       public          bohdansynytskyi    false    223    225    3600            !           2606    16512 )   product_logs product_logs_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.product_logs DROP CONSTRAINT product_logs_product_id_fkey;
       public          bohdansynytskyi    false    213    225    3585                       2606    16477 5   product_variations product_variations_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.product_variations DROP CONSTRAINT product_variations_product_id_fkey;
       public          bohdansynytskyi    false    3585    213    215                       2606    16472 "   products products_category_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;
 L   ALTER TABLE ONLY public.products DROP CONSTRAINT products_category_id_fkey;
       public          bohdansynytskyi    false    213    211    3583                       2606    16502    reviews reviews_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_email_fkey;
       public          bohdansynytskyi    false    221    3579    209                        2606    16507    reviews reviews_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_product_id_fkey;
       public          bohdansynytskyi    false    221    213    3585                       2606    16487 2   user_preferences user_preferences_category_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_category_id_fkey;
       public          bohdansynytskyi    false    211    3583    217                       2606    16482 ,   user_preferences user_preferences_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_email_fkey;
       public          bohdansynytskyi    false    3579    217    209                       2606    16492    wishlist wishlist_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.wishlist DROP CONSTRAINT wishlist_email_fkey;
       public          bohdansynytskyi    false    209    3579    219                       2606    16497 !   wishlist wishlist_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.wishlist DROP CONSTRAINT wishlist_product_id_fkey;
       public          bohdansynytskyi    false    219    3585    213            �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�}�MK1@ϓ_��!�m��"�/�J��u7S���7[�0����͙RƁb��|�"�h�J���J���pR����D�s��H.M�U�݃p^/j�UR�s��<�t׬�v���6�mB�	s��Ji˒�Zޗ��\�u�O�s�Ђ����_/�Rz�����Fk�R�&���0N�����u���Z[����-ꀌ�om�_'      �      x������ � �     