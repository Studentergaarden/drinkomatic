CREATE TABLE "users" (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
    sponsor INTEGER NOT NULL DEFAULT (0),
	name VARCHAR(60),
	hash VARCHAR(40) UNIQUE,
	keyhash VARCHAR(40) UNIQUE,
	balance FLOAT,
    CONSTRAINT fk_id
    FOREIGN KEY (sponsor) REFERENCES users(id)
);

-- Se sql update command
-- http://stackoverflow.com/questions/13249936/add-a-column-to-a-table-with-a-default-value-equal-to-the-value-of-an-existing-c#comment18055395_13249936

CREATE TABLE "products" (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	barcode VARCHAR(40) UNIQUE,
	price FLOAT,
	name VARCHAR(255)
);

CREATE TABLE "log" (
	dt VARCHAR(23),
	uid INTEGER, --user-id
    sid INTEGER, --sponsor-id
	oid INTEGER, --object-id
	count INTEGER,
	amount FLOAT
);

-- coalesce:
-- goes through all the parameters one by one, and returns the first that is NOT
-- NULL.
-- COALESCE(NULL, NULL, NULL, 1, 2, 3)
-- => 1
CREATE VIEW "full_log" AS SELECT
		dt, uid, sid, oid,
		users.name AS uname,
        sponsor.name AS sname,
		coalesce(object.name,products.name,'<deleted>') AS oname,
		count, amount
	FROM log
		LEFT JOIN users ON uid = users.id
		LEFT JOIN products ON count NOT NULL AND oid = products.id
		LEFT JOIN users AS object ON count IS NULL AND oid = object.id
        LEFT JOIN users AS sponsor ON sid = sponsor.id;
