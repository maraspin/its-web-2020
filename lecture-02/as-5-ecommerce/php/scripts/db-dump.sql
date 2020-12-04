--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: categorie_id_seq; Type: SEQUENCE; Schema: public; Owner: ecommerce
--
CREATE SEQUENCE categorie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categorie_id_seq OWNER TO ecommerce;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categorie; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE categorie (
    id integer DEFAULT nextval('categorie_id_seq'::regclass) NOT NULL,
    nome character varying(50) NOT NULL,
    macrocategoria_id integer NOT NULL
);


ALTER TABLE categorie OWNER TO ecommerce;

--
-- Name: clienti; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE clienti (
    id integer NOT NULL,
    email character varying(100),
    password character varying(100),
    cognome character varying(100),
    nome character varying(100),
    indirizzo character varying(254),
    citta character varying(100),
    provincia character varying(40),
    cap character varying(20),
    stato character varying(40)
);


ALTER TABLE clienti OWNER TO ecommerce;

--
-- Name: clienti_id_seq; Type: SEQUENCE; Schema: public; Owner: ecommerce
--

CREATE SEQUENCE clienti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clienti_id_seq OWNER TO ecommerce;

--
-- Name: clienti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecommerce
--

ALTER SEQUENCE clienti_id_seq OWNED BY clienti.id;


--
-- Name: macrocategorie_id_seq; Type: SEQUENCE; Schema: public; Owner: ecommerce
--

CREATE SEQUENCE macrocategorie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE macrocategorie_id_seq OWNER TO ecommerce;

--
-- Name: macrocategorie; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE macrocategorie (
    id integer DEFAULT nextval('macrocategorie_id_seq'::regclass) NOT NULL,
    nome character varying(50) NOT NULL
);


ALTER TABLE macrocategorie OWNER TO ecommerce;

--
-- Name: ordini; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE ordini (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    data timestamp without time zone NOT NULL,
    cognome character varying NOT NULL,
    nome character varying,
    indirizzo character varying NOT NULL,
    citta character varying NOT NULL,
    provincia character varying NOT NULL,
    cap character varying,
    stato character varying NOT NULL,
    spese_spedizione numeric(2,0) NOT NULL
);


ALTER TABLE ordini OWNER TO ecommerce;

--
-- Name: ordini_id_seq; Type: SEQUENCE; Schema: public; Owner: ecommerce
--

CREATE SEQUENCE ordini_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ordini_id_seq OWNER TO ecommerce;

--
-- Name: ordini_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecommerce
--

ALTER SEQUENCE ordini_id_seq OWNED BY ordini.id;


CREATE SEQUENCE ordiniprodottivarianti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER TABLE ordiniprodottivarianti_id_seq OWNER TO ecommerce;

-- Name: ordiniprodottivarianti; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE ordiniprodottivarianti (
    id integer DEFAULT nextval('ordiniprodottivarianti_id_seq'::regclass) NOT NULL,
    ordine_id integer NOT NULL,
    prodotto_id integer NOT NULL,
    variante_id integer,
    prezzo numeric(8,2) NOT NULL,
    quantita integer NOT NULL,
    descrizione character varying(254) DEFAULT 'Descrizione Non Disponibile'::character varying
);


ALTER TABLE ordiniprodottivarianti OWNER TO ecommerce;


CREATE SEQUENCE prodotti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prodotti_id_seq OWNER TO ecommerce;


--
-- Name: prodotti; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE prodotti (
    id integer DEFAULT nextval('prodotti_id_seq'::regclass) NOT NULL,
    nome character varying(100) NOT NULL,
    prezzo numeric(8,2) NOT NULL,
    descrizione character varying(1000),
    dataarrivo timestamp with time zone,
    categoria_id integer,
    visite integer DEFAULT 0 NOT NULL,
    visibile boolean DEFAULT true NOT NULL
);


ALTER TABLE prodotti OWNER TO ecommerce;

--
-- Name: prodottivarianti; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE prodottivarianti (
    prodotto_id integer NOT NULL,
    variante_id integer NOT NULL
);


ALTER TABLE prodottivarianti OWNER TO ecommerce;

--
-- Name: varianti_id_seq; Type: SEQUENCE; Schema: public; Owner: ecommerce
--

CREATE SEQUENCE varianti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE varianti_id_seq OWNER TO ecommerce;

--
-- Name: varianti; Type: TABLE; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE TABLE varianti (
    id integer DEFAULT nextval('varianti_id_seq'::regclass) NOT NULL,
    nome character varying(200)
);


ALTER TABLE varianti OWNER TO ecommerce;

--
-- Name: periodico; Type: VIEW; Schema: public; Owner: ecommerce
--

CREATE VIEW periodico AS
 SELECT prodotti.nome AS prodotto,
    varianti.nome AS variante
   FROM ((prodotti
     JOIN prodottivarianti ON ((prodotti.id = prodottivarianti.prodotto_id)))
     JOIN varianti ON ((prodottivarianti.variante_id = varianti.id)));


ALTER TABLE periodico OWNER TO ecommerce;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY clienti ALTER COLUMN id SET DEFAULT nextval('clienti_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY ordini ALTER COLUMN id SET DEFAULT nextval('ordini_id_seq'::regclass);


--
-- Data for Name: categorie; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO categorie VALUES (1, 'Sport', 1);
INSERT INTO categorie VALUES (2, 'Fotografia', 1);
INSERT INTO categorie VALUES (3, 'Viaggi', 1);
INSERT INTO categorie VALUES (4, 'Giardinaggio', 2);
INSERT INTO categorie VALUES (5, 'Utensili', 2);
INSERT INTO categorie VALUES (6, 'Cancelleria', 3);
INSERT INTO categorie VALUES (7, 'Informatica', 3);


--
-- Name: categorie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecommerce
--

SELECT pg_catalog.setval('categorie_id_seq', 7, true);


--
-- Data for Name: clienti; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO clienti VALUES (1, 'mario@rossi.it', 'pocosicura', 'Rossi', 'Mario', 'Via degli Anagrammi, 17', 'Codroipo', 'UD', '33033', 'Italia');
INSERT INTO clienti VALUES (2, 'gigi_storto@gmail.com', 'anchequesta', 'Storto', 'Gigi', 'Via di Pisa, 13', 'Poveromo', 'MS', '35354', 'Italia');


--
-- Name: clienti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecommerce
--

SELECT pg_catalog.setval('clienti_id_seq', 2, true);


--
-- Data for Name: macrocategorie; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO macrocategorie VALUES (1, 'Tempo Libero');
INSERT INTO macrocategorie VALUES (2, 'Casa');
INSERT INTO macrocategorie VALUES (3, 'Ufficio');


--
-- Name: macrocategorie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecommerce
--

SELECT pg_catalog.setval('macrocategorie_id_seq', 3, true);


--
-- Data for Name: ordini; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO ordini VALUES (2, 1, '2015-02-01 21:10:00', 'Rossi', 'Luisella', 'Via Pitura Freska, 23', 'Mestre', 'VE', '42351', 'Italia', 20);
INSERT INTO ordini VALUES (3, 1, '2015-02-01 22:10:00', 'Rossi', 'Mario', 'Via degli Anagrammi, 17', 'Codroipo', 'UD', '33033', 'Italia', 20);
INSERT INTO ordini VALUES (1, 1, '2015-01-01 23:00:00', 'Rossi', 'Mario', 'Via Precedente', 'Roma', 'RM', '01201', 'Italia', 16);
INSERT INTO ordini VALUES (4, 2, '2015-01-05 14:00:00', 'Storto', 'Gigi', 'Via di Pisa, 13', 'Poveromo', 'MS', '35354	', 'Italia', 20);


--
-- Name: ordini_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecommerce
--

SELECT pg_catalog.setval('ordini_id_seq', 4, true);


--
-- Data for Name: ordiniprodottivarianti; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO ordiniprodottivarianti VALUES (1,1, 1, 8, 39.00, 1, 'Pallone da Basket Molten (Pelle)');
INSERT INTO ordiniprodottivarianti VALUES (2,2, 4, NULL, 6.00, 1, 'Cartina di Cuba');
INSERT INTO ordiniprodottivarianti VALUES (3,3, 2, 8, 35.00, 1, 'Pallone da Basket Spalding (Pelle)');
INSERT INTO ordiniprodottivarianti VALUES (4,3, 12, 3, 14.00, 4, 'USB Pen 8GB (Blue)');
INSERT INTO ordiniprodottivarianti VALUES (5,4, 7, 7, 4200.00, 1, 'Nikon D5600 (Argento)');


--
-- Data for Name: prodotti; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO prodotti VALUES (1, 'Pallone da Basket Molten', 40.00, 'Pallone da basket adatto all''uso indoor', '2015-01-01 10:00:00+01', 1, 0, true);
INSERT INTO prodotti VALUES (2, 'Pallone da Basket Spalding', 34.99, 'Pallone adatto sia all''uso indoor che outdoor', '2015-02-05 10:00:00+01', 1, 0, true);
INSERT INTO prodotti VALUES (3, 'Pallone da Calcio Nike', 29.99, 'Pallone ottimo per l''allenamento', '2015-02-05 10:00:00+01', 1, 0, true);
INSERT INTO prodotti VALUES (4, 'Cartina Geografica di Cuba', 5.99, 'Il tuo compagno di viaggio ideale, per esplorare l''isola in autonomia. Esplora Cuba. E non perderti!', '2015-02-05 10:00:00+01', 3, 0, true);
INSERT INTO prodotti VALUES (5, 'Guida Illustrata alla Patagonia', 9.95, 'Il tuo compagno di viaggio ideale, per esplorare la Patagonia. Esplorala tutta, e ritorna vivo!', '2015-02-02 10:45:00+01', 3, 0, true);
INSERT INTO prodotti VALUES (6, 'Obiettivo Nikon D 50mm 1.4', 249.00, 'Obiettivo 50mm 1.4 per ritratti e scatti in condizioni di scarsa illuminazione', '2015-01-01 10:00:00+01', 2, 0, true);
INSERT INTO prodotti VALUES (7, 'Macchina Fotografica Nikon D5600', 2900.00, 'Digital SLR Professionale 50MP', '2015-02-05 10:00:00+01', 2, 0, true);
INSERT INTO prodotti VALUES (8, 'Nikon D300', 1200.00, 'Nikon Digital SLR D300, 12MP', '2013-02-05 10:00:00+01', 2, 450, false);
INSERT INTO prodotti VALUES (9, 'Decespugliatore', 236.00, 'Decespugliatore con impugnatura in gomma', '2015-02-05 10:00:00+01', 4, 10, true);
INSERT INTO prodotti VALUES (10, 'Martello ergonomico', 15.00, 'Martello ergonomico con impugnatura in gomma', '2015-02-05 10:00:00+01', 5, 0, true);
INSERT INTO prodotti VALUES (11, 'Pennarello 0.1mm Nero ', 3.00, 'Pennarello 0.1mm Nero, adatto per scrivere su plastica, legno, metallo. Ottimo su CD e altri supporti magnetici.', '2015-02-05 10:00:00+01', 6, 20, true);
INSERT INTO prodotti VALUES (12, 'USB Pen 8GB', 14.00, 'Pen Drive USB Capacità 8GB', '2015-02-05 10:00:00+01', 7, 24, true);


--
-- Name: prodotti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecommerce
--

SELECT pg_catalog.setval('prodotti_id_seq', 12, true);


--
-- Data for Name: prodottivarianti; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO prodottivarianti VALUES (1, 8);
INSERT INTO prodottivarianti VALUES (2, 8);
INSERT INTO prodottivarianti VALUES (2, 1);
INSERT INTO prodottivarianti VALUES (3, 4);
INSERT INTO prodottivarianti VALUES (3, 9);
INSERT INTO prodottivarianti VALUES (6, 1);
INSERT INTO prodottivarianti VALUES (6, 7);
INSERT INTO prodottivarianti VALUES (7, 1);
INSERT INTO prodottivarianti VALUES (7, 7);
INSERT INTO prodottivarianti VALUES (7, 9);
INSERT INTO prodottivarianti VALUES (8, 1);
INSERT INTO prodottivarianti VALUES (9, 2);
INSERT INTO prodottivarianti VALUES (9, 3);
INSERT INTO prodottivarianti VALUES (10, 3);
INSERT INTO prodottivarianti VALUES (9, 4);
INSERT INTO prodottivarianti VALUES (11, 1);
INSERT INTO prodottivarianti VALUES (11, 2);
INSERT INTO prodottivarianti VALUES (11, 3);
INSERT INTO prodottivarianti VALUES (12, 1);
INSERT INTO prodottivarianti VALUES (12, 2);
INSERT INTO prodottivarianti VALUES (12, 4);
INSERT INTO prodottivarianti VALUES (12, 5);
INSERT INTO prodottivarianti VALUES (12, 6);


--
-- Data for Name: varianti; Type: TABLE DATA; Schema: public; Owner: ecommerce
--

INSERT INTO varianti VALUES (1, 'Nero');
INSERT INTO varianti VALUES (2, 'Rosso');
INSERT INTO varianti VALUES (3, 'Blue');
INSERT INTO varianti VALUES (4, 'Giallo');
INSERT INTO varianti VALUES (5, 'Verde');
INSERT INTO varianti VALUES (6, 'Mimetico');
INSERT INTO varianti VALUES (7, 'Argento');
INSERT INTO varianti VALUES (8, 'Pelle');
INSERT INTO varianti VALUES (9, 'Bianco');


--
-- Name: varianti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecommerce
--

SELECT pg_catalog.setval('varianti_id_seq', 9, true);


--
-- Name: categorie_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY categorie
    ADD CONSTRAINT categorie_pkey PRIMARY KEY (id);


--
-- Name: clienti_email_key; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY clienti
    ADD CONSTRAINT clienti_email_key UNIQUE (email);


--
-- Name: clienti_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY clienti
    ADD CONSTRAINT clienti_pkey PRIMARY KEY (id);


--
-- Name: macrocategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY macrocategorie
    ADD CONSTRAINT macrocategorie_pkey PRIMARY KEY (id);


--
-- Name: ordini_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY ordini
    ADD CONSTRAINT ordini_pkey PRIMARY KEY (id);


--
-- Name: ordiniprodottivarianti_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY ordiniprodottivarianti
    ADD CONSTRAINT ordiniprodottivarianti_pkey PRIMARY KEY (id);


--
-- Name: prodotti_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY prodotti
    ADD CONSTRAINT prodotti_pkey PRIMARY KEY (id);


--
-- Name: prodottivarianti_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY prodottivarianti
    ADD CONSTRAINT prodottivarianti_pkey PRIMARY KEY (prodotto_id, variante_id);


--
-- Name: varianti_pkey; Type: CONSTRAINT; Schema: public; Owner: ecommerce; Tablespace: 
--

ALTER TABLE ONLY varianti
    ADD CONSTRAINT varianti_pkey PRIMARY KEY (id);


--
-- Name: univoco_record_ordine; Type: INDEX; Schema: public; Owner: ecommerce; Tablespace: 
--

CREATE UNIQUE INDEX univoco_record_ordine ON ordiniprodottivarianti USING btree (ordine_id, prodotto_id, variante_id);


--
-- Name: fk_categoria; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY prodotti
    ADD CONSTRAINT fk_categoria FOREIGN KEY (categoria_id) REFERENCES categorie(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_macrocategoria; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY categorie
    ADD CONSTRAINT fk_macrocategoria FOREIGN KEY (macrocategoria_id) REFERENCES macrocategorie(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_opv_ordine; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY ordiniprodottivarianti
    ADD CONSTRAINT fk_opv_ordine FOREIGN KEY (ordine_id) REFERENCES ordini(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_opv_prodotto; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY ordiniprodottivarianti
    ADD CONSTRAINT fk_opv_prodotto FOREIGN KEY (prodotto_id) REFERENCES prodotti(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fk_opv_variante; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY ordiniprodottivarianti
    ADD CONSTRAINT fk_opv_variante FOREIGN KEY (variante_id) REFERENCES varianti(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fk_or_cliente; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY ordini
    ADD CONSTRAINT fk_or_cliente FOREIGN KEY (cliente_id) REFERENCES clienti(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fk_pv_prodotto; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY prodottivarianti
    ADD CONSTRAINT fk_pv_prodotto FOREIGN KEY (prodotto_id) REFERENCES prodotti(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_pv_variante; Type: FK CONSTRAINT; Schema: public; Owner: ecommerce
--

ALTER TABLE ONLY prodottivarianti
    ADD CONSTRAINT fk_pv_variante FOREIGN KEY (variante_id) REFERENCES varianti(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


