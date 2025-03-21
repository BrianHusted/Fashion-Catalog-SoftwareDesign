PGDMP     %                    }           flexwear    14.17 (Homebrew)    14.17 (Homebrew) O    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16692    flexwear    DATABASE     ]   CREATE DATABASE flexwear WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_CA.UTF-8';
    DROP DATABASE flexwear;
                postgres    false            �            1259    16756    admins    TABLE     �   CREATE TABLE public.admins (
    admin_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.admins;
       public         heap    postgres    false            �            1259    16755    admins_admin_id_seq    SEQUENCE     �   CREATE SEQUENCE public.admins_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.admins_admin_id_seq;
       public          postgres    false    223            �           0    0    admins_admin_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.admins_admin_id_seq OWNED BY public.admins.admin_id;
          public          postgres    false    222            �            1259    16702 
   categories    TABLE     n   CREATE TABLE public.categories (
    category_id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.categories;
       public         heap    postgres    false            �            1259    16701    categories_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.categories_category_id_seq;
       public          postgres    false    211            �           0    0    categories_category_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;
          public          postgres    false    210            �            1259    16770    product_logs    TABLE     �   CREATE TABLE public.product_logs (
    log_id integer NOT NULL,
    product_id integer,
    admin_id integer NOT NULL,
    action_type character varying(50),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
     DROP TABLE public.product_logs;
       public         heap    postgres    false            �            1259    16769    product_logs_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_logs_log_id_seq;
       public          postgres    false    225            �           0    0    product_logs_log_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_logs_log_id_seq OWNED BY public.product_logs.log_id;
          public          postgres    false    224            �            1259    16723    product_variations    TABLE     �   CREATE TABLE public.product_variations (
    variation_id integer NOT NULL,
    product_id integer NOT NULL,
    size character varying(20) NOT NULL,
    color character varying(50) NOT NULL
);
 &   DROP TABLE public.product_variations;
       public         heap    postgres    false            �            1259    16722 #   product_variations_variation_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_variations_variation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.product_variations_variation_id_seq;
       public          postgres    false    215            �           0    0 #   product_variations_variation_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.product_variations_variation_id_seq OWNED BY public.product_variations.variation_id;
          public          postgres    false    214            �            1259    16711    products    TABLE     h  CREATE TABLE public.products (
    product_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    picture_url text
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    16710    products_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_product_id_seq;
       public          postgres    false    213            �           0    0    products_product_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;
          public          postgres    false    212            �            1259    16746    reviews    TABLE     �   CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    email character varying(100) NOT NULL,
    product_id integer NOT NULL,
    rating integer,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.reviews;
       public         heap    postgres    false            �            1259    16745    reviews_review_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.reviews_review_id_seq;
       public          postgres    false    221            �           0    0    reviews_review_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;
          public          postgres    false    220            �            1259    16731    user_preferences    TABLE     �   CREATE TABLE public.user_preferences (
    preference_id integer NOT NULL,
    email character varying(100) NOT NULL,
    category_id integer NOT NULL,
    preferred_size character varying(20),
    preferred_color character varying(50)
);
 $   DROP TABLE public.user_preferences;
       public         heap    postgres    false            �            1259    16730 "   user_preferences_preference_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_preferences_preference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.user_preferences_preference_id_seq;
       public          postgres    false    217            �           0    0 "   user_preferences_preference_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.user_preferences_preference_id_seq OWNED BY public.user_preferences.preference_id;
          public          postgres    false    216            �            1259    16693    users    TABLE     *  CREATE TABLE public.users (
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    birthdate date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16738    wishlist    TABLE     �   CREATE TABLE public.wishlist (
    wishlist_id integer NOT NULL,
    email character varying(100) NOT NULL,
    product_id integer NOT NULL,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.wishlist;
       public         heap    postgres    false            �            1259    16737    wishlist_wishlist_id_seq    SEQUENCE     �   CREATE SEQUENCE public.wishlist_wishlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.wishlist_wishlist_id_seq;
       public          postgres    false    219            �           0    0    wishlist_wishlist_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.wishlist_wishlist_id_seq OWNED BY public.wishlist.wishlist_id;
          public          postgres    false    218            �           2604    16877    admins admin_id    DEFAULT     r   ALTER TABLE ONLY public.admins ALTER COLUMN admin_id SET DEFAULT nextval('public.admins_admin_id_seq'::regclass);
 >   ALTER TABLE public.admins ALTER COLUMN admin_id DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    16878    categories category_id    DEFAULT     �   ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);
 E   ALTER TABLE public.categories ALTER COLUMN category_id DROP DEFAULT;
       public          postgres    false    210    211    211            �           2604    16879    product_logs log_id    DEFAULT     z   ALTER TABLE ONLY public.product_logs ALTER COLUMN log_id SET DEFAULT nextval('public.product_logs_log_id_seq'::regclass);
 B   ALTER TABLE public.product_logs ALTER COLUMN log_id DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    16880    product_variations variation_id    DEFAULT     �   ALTER TABLE ONLY public.product_variations ALTER COLUMN variation_id SET DEFAULT nextval('public.product_variations_variation_id_seq'::regclass);
 N   ALTER TABLE public.product_variations ALTER COLUMN variation_id DROP DEFAULT;
       public          postgres    false    214    215    215            �           2604    16881    products product_id    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    213    212    213            �           2604    16882    reviews review_id    DEFAULT     v   ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);
 @   ALTER TABLE public.reviews ALTER COLUMN review_id DROP DEFAULT;
       public          postgres    false    221    220    221            �           2604    16883    user_preferences preference_id    DEFAULT     �   ALTER TABLE ONLY public.user_preferences ALTER COLUMN preference_id SET DEFAULT nextval('public.user_preferences_preference_id_seq'::regclass);
 M   ALTER TABLE public.user_preferences ALTER COLUMN preference_id DROP DEFAULT;
       public          postgres    false    216    217    217            �           2604    16884    wishlist wishlist_id    DEFAULT     |   ALTER TABLE ONLY public.wishlist ALTER COLUMN wishlist_id SET DEFAULT nextval('public.wishlist_wishlist_id_seq'::regclass);
 C   ALTER TABLE public.wishlist ALTER COLUMN wishlist_id DROP DEFAULT;
       public          postgres    false    218    219    219            �          0    16756    admins 
   TABLE DATA           V   COPY public.admins (admin_id, username, email, password_hash, created_at) FROM stdin;
    public          postgres    false    223   1c       �          0    16702 
   categories 
   TABLE DATA           7   COPY public.categories (category_id, name) FROM stdin;
    public          postgres    false    211   �c       �          0    16770    product_logs 
   TABLE DATA           ^   COPY public.product_logs (log_id, product_id, admin_id, action_type, "timestamp") FROM stdin;
    public          postgres    false    225   �c       �          0    16723    product_variations 
   TABLE DATA           S   COPY public.product_variations (variation_id, product_id, size, color) FROM stdin;
    public          postgres    false    215   �d       �          0    16711    products 
   TABLE DATA           z   COPY public.products (product_id, name, description, price, category_id, created_at, updated_at, picture_url) FROM stdin;
    public          postgres    false    213   �d       �          0    16746    reviews 
   TABLE DATA           \   COPY public.reviews (review_id, email, product_id, rating, comment, created_at) FROM stdin;
    public          postgres    false    221   be       �          0    16731    user_preferences 
   TABLE DATA           n   COPY public.user_preferences (preference_id, email, category_id, preferred_size, preferred_color) FROM stdin;
    public          postgres    false    217   e       �          0    16693    users 
   TABLE DATA           c   COPY public.users (email, password_hash, first_name, last_name, birthdate, created_at) FROM stdin;
    public          postgres    false    209   �e       �          0    16738    wishlist 
   TABLE DATA           L   COPY public.wishlist (wishlist_id, email, product_id, added_at) FROM stdin;
    public          postgres    false    219   �e       �           0    0    admins_admin_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.admins_admin_id_seq', 2, true);
          public          postgres    false    222            �           0    0    categories_category_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.categories_category_id_seq', 13, true);
          public          postgres    false    210            �           0    0    product_logs_log_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_logs_log_id_seq', 74, true);
          public          postgres    false    224            �           0    0 #   product_variations_variation_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.product_variations_variation_id_seq', 16, true);
          public          postgres    false    214            �           0    0    products_product_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.products_product_id_seq', 10, true);
          public          postgres    false    212            �           0    0    reviews_review_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.reviews_review_id_seq', 1, false);
          public          postgres    false    220            �           0    0 "   user_preferences_preference_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.user_preferences_preference_id_seq', 1, false);
          public          postgres    false    216            �           0    0    wishlist_wishlist_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.wishlist_wishlist_id_seq', 1, false);
          public          postgres    false    218                       2606    16768    admins admins_email_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);
 A   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_email_key;
       public            postgres    false    223                       2606    16764    admins admins_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);
 <   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_pkey;
       public            postgres    false    223            
           2606    16766    admins admins_username_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);
 D   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_username_key;
       public            postgres    false    223            �           2606    16709    categories categories_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_name_key;
       public            postgres    false    211            �           2606    16707    categories categories_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);
 D   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_pkey;
       public            postgres    false    211                       2606    16776    product_logs product_logs_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_pkey PRIMARY KEY (log_id);
 H   ALTER TABLE ONLY public.product_logs DROP CONSTRAINT product_logs_pkey;
       public            postgres    false    225            �           2606    16729 *   product_variations product_variations_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_pkey PRIMARY KEY (variation_id);
 T   ALTER TABLE ONLY public.product_variations DROP CONSTRAINT product_variations_pkey;
       public            postgres    false    215            �           2606    16721    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    213                       2606    16754    reviews reviews_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);
 >   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_pkey;
       public            postgres    false    221            �           2606    16736 &   user_preferences user_preferences_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (preference_id);
 P   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_pkey;
       public            postgres    false    217            �           2606    16700    users users_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (email);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    209                       2606    16744    wishlist wishlist_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (wishlist_id);
 @   ALTER TABLE ONLY public.wishlist DROP CONSTRAINT wishlist_pkey;
       public            postgres    false    219            �           1259    16777 ,   product_variations_product_id_size_color_idx    INDEX     �   CREATE UNIQUE INDEX product_variations_product_id_size_color_idx ON public.product_variations USING btree (product_id, size, color);
 @   DROP INDEX public.product_variations_product_id_size_color_idx;
       public            postgres    false    215    215    215            �           1259    16778 &   user_preferences_email_category_id_idx    INDEX     x   CREATE UNIQUE INDEX user_preferences_email_category_id_idx ON public.user_preferences USING btree (email, category_id);
 :   DROP INDEX public.user_preferences_email_category_id_idx;
       public            postgres    false    217    217                        1259    16779    wishlist_email_product_id_idx    INDEX     f   CREATE UNIQUE INDEX wishlist_email_product_id_idx ON public.wishlist USING btree (email, product_id);
 1   DROP INDEX public.wishlist_email_product_id_idx;
       public            postgres    false    219    219                       2606    16825 '   product_logs product_logs_admin_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admins(admin_id) ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public.product_logs DROP CONSTRAINT product_logs_admin_id_fkey;
       public          postgres    false    225    3592    223                       2606    16925 )   product_logs product_logs_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_logs
    ADD CONSTRAINT product_logs_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE SET NULL;
 S   ALTER TABLE ONLY public.product_logs DROP CONSTRAINT product_logs_product_id_fkey;
       public          postgres    false    3577    213    225                       2606    16785 5   product_variations product_variations_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.product_variations DROP CONSTRAINT product_variations_product_id_fkey;
       public          postgres    false    213    3577    215                       2606    16780 "   products products_category_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;
 L   ALTER TABLE ONLY public.products DROP CONSTRAINT products_category_id_fkey;
       public          postgres    false    213    211    3575                       2606    16810    reviews reviews_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_email_fkey;
       public          postgres    false    3571    209    221                       2606    16815    reviews reviews_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_product_id_fkey;
       public          postgres    false    3577    213    221                       2606    16795 2   user_preferences user_preferences_category_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_category_id_fkey;
       public          postgres    false    211    3575    217                       2606    16790 ,   user_preferences user_preferences_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_email_fkey;
       public          postgres    false    209    3571    217                       2606    16800    wishlist wishlist_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.wishlist DROP CONSTRAINT wishlist_email_fkey;
       public          postgres    false    209    219    3571                       2606    16805 !   wishlist wishlist_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.wishlist DROP CONSTRAINT wishlist_product_id_fkey;
       public          postgres    false    219    213    3577            �   v   x�E�;
�0Dk�)|�GV�:gH�$�8x#�����0<������o���oKkV������5;7��@q<�4`�"Yf��(0�ӻ��_������� H|�i@�2eN>�́�����(�      �   "   x�34����O�L-�24�)��,*����� c[�      �   �   x����jAE��W�<H=�8m�Tn��BH ���8.�$Y����se^�o��봜�i�~�^N���0����w$]�sV&D&��1/�� Q섕\�,�:3��܃o�a����� ���o��*5����k��#�**q$�=3���V�Q����ڑ�F�t�B�l���{���{��1R�T�eU�i4l84�X�_�t�      �       x�34����t�IL��24�44��b���� o��      �   `   x������NU)��,*Aa�ps����+�ZYe�́ �TRNbr�.�(���t.CN���7��32�4�0�'�n~� ��1�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     