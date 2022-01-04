---db creation
CREATE TABLE Document (
    ID serial PRIMARY KEY UNIQUE NOT NULL,
    name varchar(50) NOT NULL,
    content text NOT NULL,
    entry_date date NOT NULL
);
CREATE OR REPLACE FUNCTION validateRate (rate smallint) RETURNS bool
AS
$$
    BEGIN
        RETURN rate >= 0 AND rate <= 100;
    END;
$$ LANGUAGE plpgsql;
CREATE TABLE Tax (
    code varchar(10) PRIMARY KEY UNIQUE NOT NULL,
    name varchar(50) NOT NULL,
    rate smallint NOT NULL,
    docID int,
    CONSTRAINT rate_valid CHECK (validateRate(rate)),
    FOREIGN KEY (docID) REFERENCES Document(ID)
);
CREATE TABLE Payer (
    registrationID bigserial PRIMARY KEY UNIQUE NOT NULL,
    name varchar(100) NOT NULL,
    type varchar(50) NOT NULL,
    address varchar(50)
);
CREATE TABLE NecessaryTaxes (
    ID serial PRIMARY KEY UNIQUE NOT NULL,
    registrationID bigint NOT NULL,
    tax_code varchar(10) NOT NULL,
    FOREIGN KEY (registrationID) REFERENCES Payer(registrationID),
    FOREIGN KEY (tax_code) REFERENCES Tax(code)
);
CREATE TABLE PayedTax (
    ID bigserial PRIMARY KEY UNIQUE NOT NULL,
    registrationID bigint NOT NULL,
    tax_code varchar(10) NOT NULL,
    count money NOT NULL,
    quarter varchar(1) NOT NULL,
    date date NOT NULL,
    CONSTRAINT quarter_valid CHECK (quarter IN ('1', '2', '3', '4')),
    FOREIGN KEY (registrationID) REFERENCES Payer(registrationID),
    FOREIGN KEY (tax_code) REFERENCES Tax(code)
);
