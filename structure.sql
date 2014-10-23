CREATE TABLE "users" (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name VARCHAR(60),
	hash VARCHAR(40) UNIQUE,
	balance FLOAT
);

CREATE TABLE "products" (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	barcode VARCHAR(40) UNIQUE,
	price FLOAT,
	name VARCHAR(255)
);

CREATE TABLE "log" (
	dt VARCHAR(23),
	uid INTEGER,
	oid INTEGER,
	count INTEGER,
	amount FLOAT
);

-- coalesce:
-- goes through all the parameters one by one, and returns the first that is NOT
-- NULL.
-- COALESCE(NULL, NULL, NULL, 1, 2, 3)
-- => 1
CREATE VIEW "full_log" AS SELECT
		dt, uid, oid,
		users.name AS uname,
		coalesce(object.name,products.name,'<deleted>') AS oname,
		count, amount
	FROM log
		LEFT JOIN users ON uid = users.id
		LEFT JOIN products ON count NOT NULL AND oid = products.id
		LEFT JOIN users AS object ON count IS NULL AND oid = object.id;
