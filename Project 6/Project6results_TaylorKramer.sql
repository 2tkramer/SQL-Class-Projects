DROP TABLE IF EXISTS business CASCADE;
DROP TABLE IF EXISTS reviewer CASCADE;
DROP TABLE IF EXISTS chain CASCADE;
DROP TABLE IF EXISTS menu CASCADE;
DROP TABLE IF EXISTS reviewer_business_xref CASCADE;
DROP TABLE IF EXISTS business_business_type CASCADE;
CREATE TABLE business (
    id integer PRIMARY KEY,
    name text,	
    street_address text,
    city text,
    state text,
    zip integer
);

CREATE TABLE reviewer (
    screen_name text not null,
    identity_provider text not null,
    PRIMARY KEY (screen_name, identity_provider)		
);

CREATE TABLE chain (
    name text PRIMARY KEY,
    city text,
    state text,	
    business_id integer REFERENCES business (id) not null
);

CREATE TABLE menu (
    business_id integer REFERENCES business (id) not null,
    label text not null,
    url text,
    PRIMARY KEY (business_id, label)
);

CREATE TABLE reviewer_business_xref	(
    reviewer_identity_provider text not null,
    reviewer_screen_name text not null,
    business_id integer REFERENCES business (id) not null,
    views integer,
    rating numeric,
    review_date date,
    comments text,
    PRIMARY KEY (reviewer_identity_provider, reviewer_screen_name, business_id),		
    FOREIGN KEY (reviewer_identity_provider, reviewer_screen_name) REFERENCES reviewer (identity_provider, screen_name)
);

CREATE TABLE business_business_type	(
    business_id	integer REFERENCES business (id) not null,
    business_type text not null,
    PRIMARY KEY (business_id, business_type)
);
		

