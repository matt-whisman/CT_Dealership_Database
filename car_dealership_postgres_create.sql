CREATE TABLE "car" (
	"car_id" serial NOT NULL,
	"sales_id" integer NOT NULL,
	"customer_id" integer NOT NULL,
	"vin" varchar(17) NOT NULL UNIQUE,
	"make" varchar(255) NOT NULL,
	"model" varchar(255) NOT NULL,
	"year" integer NOT NULL,
	CONSTRAINT "car_pk" PRIMARY KEY ("car_id")
) WITH (OIDS = FALSE);

CREATE TABLE "salesperson" (
	"sales_id" serial NOT NULL,
	"first_name" varchar(255) NOT NULL,
	"last_name" varchar(255) NOT NULL,
	CONSTRAINT "salesperson_pk" PRIMARY KEY ("sales_id")
) WITH (OIDS = FALSE);

CREATE TABLE "customer" (
	"customer_id" serial NOT NULL,
	"first_name" varchar(255) NOT NULL,
	"last_name" varchar(255) NOT NULL,
	CONSTRAINT "customer_pk" PRIMARY KEY ("customer_id")
) WITH (OIDS = FALSE);

CREATE TABLE "invoice" (
	"invoice_id" serial NOT NULL,
	"sales_id" integer NOT NULL,
	"car_id" integer NOT NULL,
	"customer_id" integer NOT NULL,
	"total" numeric NOT NULL,
	CONSTRAINT "invoice_pk" PRIMARY KEY ("invoice_id")
) WITH (OIDS = FALSE);

CREATE TABLE "service_history" (
	"service_history_id" serial NOT NULL,
	"car_id" integer NOT NULL,
	"service_ticket_id" integer NOT NULL,
	CONSTRAINT "service_history_pk" PRIMARY KEY ("service_history_id")
) WITH (OIDS = FALSE);

CREATE TABLE "mechanic" (
	"mechanic_id" serial NOT NULL,
	"first_name" varchar(255) NOT NULL,
	"last_name" varchar(255) NOT NULL,
	CONSTRAINT "mechanic_pk" PRIMARY KEY ("mechanic_id")
) WITH (OIDS = FALSE);

CREATE TABLE "part" (
	"part_id" serial NOT NULL,
	"part_name" varchar(255) NOT NULL,
	CONSTRAINT "part_pk" PRIMARY KEY ("part_id")
) WITH (OIDS = FALSE);

CREATE TABLE "service_mechanic" (
	"service_mechanic_id" serial NOT NULL,
	"service_ticket_id" integer NOT NULL,
	"mechanic_id" integer NOT NULL,
	CONSTRAINT "service_mechanic_pk" PRIMARY KEY (
		"service_mechanic_id",
		"service_ticket_id",
		"mechanic_id"
	)
) WITH (OIDS = FALSE);

CREATE TABLE "service_ticket" (
	"service_ticket_id" serial NOT NULL,
	"invoice_id" integer NOT NULL,
	"part_id" integer NOT NULL,
	CONSTRAINT "service_ticket_pk" PRIMARY KEY ("service_ticket_id")
) WITH (OIDS = FALSE);

ALTER TABLE
	"car"
ADD
	CONSTRAINT "car_fk0" FOREIGN KEY ("sales_id") REFERENCES "salesperson"("sales_id");

ALTER TABLE
	"car"
ADD
	CONSTRAINT "car_fk1" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id");

ALTER TABLE
	"invoice"
ADD
	CONSTRAINT "invoice_fk0" FOREIGN KEY ("sales_id") REFERENCES "salesperson"("sales_id");

ALTER TABLE
	"invoice"
ADD
	CONSTRAINT "invoice_fk1" FOREIGN KEY ("car_id") REFERENCES "car"("car_id");

ALTER TABLE
	"invoice"
ADD
	CONSTRAINT "invoice_fk2" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id");

ALTER TABLE
	"service_history"
ADD
	CONSTRAINT "service_history_fk0" FOREIGN KEY ("car_id") REFERENCES "car"("car_id");

ALTER TABLE
	"service_history"
ADD
	CONSTRAINT "service_history_fk1" FOREIGN KEY ("service_ticket_id") REFERENCES "service_ticket"("service_ticket_id");

ALTER TABLE
	"service_mechanic"
ADD
	CONSTRAINT "service_mechanic_fk0" FOREIGN KEY ("service_ticket_id") REFERENCES "service_ticket"("service_ticket_id");

ALTER TABLE
	"service_mechanic"
ADD
	CONSTRAINT "service_mechanic_fk1" FOREIGN KEY ("mechanic_id") REFERENCES "mechanic"("mechanic_id");

ALTER TABLE
	"service_ticket"
ADD
	CONSTRAINT "service_ticket_fk0" FOREIGN KEY ("invoice_id") REFERENCES "invoice"("invoice_id");

ALTER TABLE
	"service_ticket"
ADD
	CONSTRAINT "service_ticket_fk1" FOREIGN KEY ("part_id") REFERENCES "part"("part_id");

-- Function for adding customers
CREATE
OR REPLACE PROCEDURE addCustomer (
	_first_name varchar(255),
	_last_name varchar(255)
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	customer (first_name, last_name)
VALUES
	(_first_name, _last_name);

END;
$$ 

CALL addCustomer('Matt', 'Whisman');

CALL addCustomer('Victor', 'Contin');

CALL addCustomer('Meilani', 'Nishimura');


Create OR REPLACE PROCEDURE addSalesperson (
	_first_name varchar(255),
	_last_name varchar(255)
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	salesperson(first_name, last_name)
VALUES
	(_first_name,
	_last_name
	);
END;
$$

CALL addSalesperson('Joe', 'Schmoe');
CALL addSalesperson('Sally', 'Johnson');
CALL addSalesperson('Billy', 'Madison');

Create OR REPLACE PROCEDURE addCar (
	_sales_id INTEGER,
	_customer_id INTEGER,
	_vin varchar(17),
	_make varchar(255),
	_model varchar(255),
	_year INTEGER
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	car(sales_id, customer_id, vin, make, model, year)
VALUES
	(_sales_id,
	_customer_id,
	_vin,
	_make,
	_model,
	_year
	);
END;
$$

CALL addCar(1, 2, 'FSDA324238DFSD8d9', 'Ford', 'F150', 2022);
CALL addCar(2, 3, 'FSDA3djsk8DFSD8d9', 'Tesla', 'Cybertruck', 2023);
CALL addCar(3, 1, 'FSDjdk3828DFSD8d9', 'Dodge', 'Challenger', 2020);


Create OR REPLACE PROCEDURE addInvoice (
	_sales_id INTEGER,
	_car_id INTEGER,
	_customer_id INTEGER,
	_total NUMERIC
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	invoice(sales_id, car_id, customer_id, total)
VALUES
	(_sales_id,
	_car_id,
	_customer_id,
	_total
	);
END;
$$

CALL addInvoice(2, 1, 1, 500.37);
CALL addInvoice(3, 3, 2, 1000.99);
CALL addInvoice(1, 2, 3, 647.23);

-- total column needs changed to numeric from integer
alter table invoice
alter column total set data type numeric;

-- sales_id and car_id need unset from 'serial' and set to integer
alter table invoice
alter column sales_id set data type integer;

alter table invoice
alter column car_id set data type integer;

-- change part_name from integer to varchar
alter table part
alter column part_name set data type varchar(255);

-- change service_mechanic.service_ticket_id from serial to integer
alter table service_mechanic
alter column service_ticket_id set data type integer;


Create OR REPLACE PROCEDURE addPart (
	_part_name varchar(255)
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	part(part_name)
VALUES
	(_part_name);
END;
$$

CALL addPart('NOS - Fast and Furious Variety');
CALL addPart('Muffler');
CALL addPart('Big Tires');

select * from part;

Create OR REPLACE PROCEDURE addMechanic (
	_first_name varchar(255),
	_last_name varchar(255)
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	mechanic(first_name, last_name)
VALUES
	(
		_first_name,
		_last_name
	);
END;
$$

CALL addMechanic('Larry', 'Bigdog');
CALL addMechanic('Joe', 'Fixem');
CALL addMechanic('Sue', 'Yew');


-- change 

Create OR REPLACE PROCEDURE addServiceTicket (
	_invoice_id integer,
	_part_id integer
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	service_ticket(invoice_id, part_id)
VALUES
	(
		_invoice_id,
		_part_id
	);
END;
$$

CALL addServiceTicket(3, 1);
CALL addServiceTicket(1, 2);
CALL addServiceTicket(2, 3);

Create OR REPLACE PROCEDURE addServiceMechanic (
	_service_ticket_id integer,
	_mechanic_id integer
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	service_mechanic(service_ticket_id, mechanic_id)
VALUES
	(
		_service_ticket_id,
		_mechanic_id
	);
END;
$$

CALL addServiceMechanic(2, 1);
CALL addServiceMechanic(1, 3);
CALL addServiceMechanic(3, 2);



Create OR REPLACE PROCEDURE addServiceHistory (
	_car_id integer,
	_service_ticket_id integer
) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO
	service_history(car_id, service_ticket_id)
VALUES
	(
		_car_id,
		_service_ticket_id
	);
END;
$$

CALL addServiceHistory(1, 2);
CALL addServiceHistory(2, 3);
CALL addServiceHistory(3, 1);




