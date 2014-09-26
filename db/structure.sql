--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    country character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    state character varying(255),
    pin_code integer,
    phone_number integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE blocks (
    id integer NOT NULL,
    name character varying(255),
    subtitle character varying(255),
    block_type character varying(255),
    workout_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    move integer DEFAULT 0,
    minutes integer DEFAULT 0,
    seconds integer DEFAULT 0
);


--
-- Name: blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: full_workouts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE full_workouts (
    id integer NOT NULL,
    video character varying(255),
    mark_complete boolean DEFAULT false,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    enable boolean DEFAULT true
);


--
-- Name: full_workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE full_workouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: full_workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE full_workouts_id_seq OWNED BY full_workouts.id;


--
-- Name: histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE histories (
    id integer NOT NULL,
    status character varying(255),
    move_id integer,
    workout_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE histories_id_seq OWNED BY histories.id;


--
-- Name: library_videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE library_videos (
    id integer NOT NULL,
    panda_video_id character varying(255),
    video character varying(255),
    move_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image character varying(255),
    video_tmp character varying(255)
);


--
-- Name: library_videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE library_videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: library_videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE library_videos_id_seq OWNED BY library_videos.id;


--
-- Name: move_blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE move_blocks (
    id integer NOT NULL,
    block_id integer NOT NULL,
    move_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: move_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE move_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: move_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE move_blocks_id_seq OWNED BY move_blocks.id;


--
-- Name: move_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE move_details (
    id integer NOT NULL,
    repetitions boolean DEFAULT true,
    weight boolean DEFAULT false,
    distance boolean DEFAULT false,
    dist_option character varying(255),
    dist_val integer DEFAULT 1,
    duration boolean DEFAULT false,
    minute integer DEFAULT 0,
    second integer DEFAULT 0,
    tempo boolean DEFAULT false,
    temp_lower integer DEFAULT 0,
    temp_pause integer DEFAULT 0,
    temp_lift integer DEFAULT 0,
    rep_min integer DEFAULT 1,
    rep_max integer DEFAULT 1,
    rep_total integer DEFAULT 1,
    rep_each_side boolean DEFAULT false,
    rep_option character varying(255),
    move_block_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sets boolean DEFAULT false,
    sets_count integer DEFAULT 1,
    rest boolean DEFAULT false,
    rest_time integer DEFAULT 30
);


--
-- Name: move_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE move_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: move_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE move_details_id_seq OWNED BY move_details.id;


--
-- Name: moves; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE moves (
    id integer NOT NULL,
    user_id integer,
    title character varying(255),
    directions text,
    category character varying(255),
    difficulty character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(255),
    move_type character varying(255),
    equipment character varying(255)[] DEFAULT '{}'::character varying[],
    help character varying(255),
    work character varying(255),
    date_submitted_for_approval timestamp without time zone,
    enable boolean DEFAULT true
);


--
-- Name: moves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE moves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE moves_id_seq OWNED BY moves.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: statastics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE statastics (
    id integer NOT NULL,
    visits integer DEFAULT 0,
    workout_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: statastics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statastics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statastics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statastics_id_seq OWNED BY statastics.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    stripe_card_token character varying(255),
    customer_id character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: target_muscle_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE target_muscle_groups (
    id integer NOT NULL,
    move_id integer,
    target_muscle_group character varying(255),
    sub_target_muscle_group character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: target_muscle_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE target_muscle_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: target_muscle_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE target_muscle_groups_id_seq OWNED BY target_muscle_groups.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(255),
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    role character varying(255),
    enabled boolean DEFAULT true,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    provider character varying(255),
    uid character varying(255),
    avatar character varying(255),
    pin_code character varying(255),
    date_of_birth date,
    gender character varying(255),
    pic_file_name character varying(255),
    pic_content_type character varying(255),
    pic_file_size integer,
    pic_updated_at timestamp without time zone,
    token character varying(255),
    last_name character varying(255),
    time_zone character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: workouts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE workouts (
    id integer NOT NULL,
    title character varying(255),
    subtitle character varying(255),
    description text,
    state character varying(255) DEFAULT 'initiated'::character varying,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    pic_file_name character varying(255),
    pic_content_type character varying(255),
    pic_file_size integer,
    pic_updated_at timestamp without time zone,
    status character varying(255),
    category character varying(255),
    move_type character varying(255),
    date_submitted_for_approval timestamp without time zone,
    enable boolean DEFAULT true,
    number_of_moves integer DEFAULT 0
);


--
-- Name: workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workouts_id_seq OWNED BY workouts.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY full_workouts ALTER COLUMN id SET DEFAULT nextval('full_workouts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY histories ALTER COLUMN id SET DEFAULT nextval('histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY library_videos ALTER COLUMN id SET DEFAULT nextval('library_videos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY move_blocks ALTER COLUMN id SET DEFAULT nextval('move_blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY move_details ALTER COLUMN id SET DEFAULT nextval('move_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY moves ALTER COLUMN id SET DEFAULT nextval('moves_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statastics ALTER COLUMN id SET DEFAULT nextval('statastics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY target_muscle_groups ALTER COLUMN id SET DEFAULT nextval('target_muscle_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY workouts ALTER COLUMN id SET DEFAULT nextval('workouts_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: full_workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY full_workouts
    ADD CONSTRAINT full_workouts_pkey PRIMARY KEY (id);


--
-- Name: histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY histories
    ADD CONSTRAINT histories_pkey PRIMARY KEY (id);


--
-- Name: libraries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY moves
    ADD CONSTRAINT libraries_pkey PRIMARY KEY (id);


--
-- Name: library_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY move_blocks
    ADD CONSTRAINT library_blocks_pkey PRIMARY KEY (id);


--
-- Name: library_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY move_details
    ADD CONSTRAINT library_details_pkey PRIMARY KEY (id);


--
-- Name: library_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY library_videos
    ADD CONSTRAINT library_videos_pkey PRIMARY KEY (id);


--
-- Name: statastics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY statastics
    ADD CONSTRAINT statastics_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: target_muscle_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY target_muscle_groups
    ADD CONSTRAINT target_muscle_groups_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_statastics_on_workout_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_statastics_on_workout_id ON statastics USING btree (workout_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140610180639');

INSERT INTO schema_migrations (version) VALUES ('20140612111216');

INSERT INTO schema_migrations (version) VALUES ('20140613065125');

INSERT INTO schema_migrations (version) VALUES ('20140616110825');

INSERT INTO schema_migrations (version) VALUES ('20140617101708');

INSERT INTO schema_migrations (version) VALUES ('20140618064743');

INSERT INTO schema_migrations (version) VALUES ('20140618122041');

INSERT INTO schema_migrations (version) VALUES ('20140620104935');

INSERT INTO schema_migrations (version) VALUES ('20140624074543');

INSERT INTO schema_migrations (version) VALUES ('20140625101424');

INSERT INTO schema_migrations (version) VALUES ('20140625101524');

INSERT INTO schema_migrations (version) VALUES ('20140627124520');

INSERT INTO schema_migrations (version) VALUES ('20140627133531');

INSERT INTO schema_migrations (version) VALUES ('20140627140011');

INSERT INTO schema_migrations (version) VALUES ('20140630055608');

INSERT INTO schema_migrations (version) VALUES ('20140702090254');

INSERT INTO schema_migrations (version) VALUES ('20140702121642');

INSERT INTO schema_migrations (version) VALUES ('20140717095831');

INSERT INTO schema_migrations (version) VALUES ('20140721095936');

INSERT INTO schema_migrations (version) VALUES ('20140724052810');

INSERT INTO schema_migrations (version) VALUES ('20140724053107');

INSERT INTO schema_migrations (version) VALUES ('20140724053834');

INSERT INTO schema_migrations (version) VALUES ('20140724082537');

INSERT INTO schema_migrations (version) VALUES ('20140724082647');

INSERT INTO schema_migrations (version) VALUES ('20140724085147');

INSERT INTO schema_migrations (version) VALUES ('20140725054513');

INSERT INTO schema_migrations (version) VALUES ('20140725095333');

INSERT INTO schema_migrations (version) VALUES ('20140728120233');

INSERT INTO schema_migrations (version) VALUES ('20140805055704');

INSERT INTO schema_migrations (version) VALUES ('20140806104309');

INSERT INTO schema_migrations (version) VALUES ('20140807092754');

INSERT INTO schema_migrations (version) VALUES ('20140901052443');

INSERT INTO schema_migrations (version) VALUES ('20140901055551');

INSERT INTO schema_migrations (version) VALUES ('20140902052809');

INSERT INTO schema_migrations (version) VALUES ('20140902054729');

INSERT INTO schema_migrations (version) VALUES ('20140902081143');

INSERT INTO schema_migrations (version) VALUES ('20140902094051');

INSERT INTO schema_migrations (version) VALUES ('20140903052811');

INSERT INTO schema_migrations (version) VALUES ('20140903062943');

INSERT INTO schema_migrations (version) VALUES ('20140904065656');

INSERT INTO schema_migrations (version) VALUES ('20140905063108');

INSERT INTO schema_migrations (version) VALUES ('20140908123706');

INSERT INTO schema_migrations (version) VALUES ('20140911063516');

INSERT INTO schema_migrations (version) VALUES ('20140916131956');

INSERT INTO schema_migrations (version) VALUES ('20140920074532');

INSERT INTO schema_migrations (version) VALUES ('20140926055644');
