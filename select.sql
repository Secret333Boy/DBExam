--- a
CREATE OR REPLACE VIEW a AS
SELECT SUM(count) FROM payedtax
    JOIN payer on payedtax.registrationid = payer.registrationid
    WHERE (quarter = '4' OR (date >= '2021-09-15'::date AND date <= '2021-12-31'::date))
      AND name SIMILAR TO '%ав%' AND
        (SELECT COUNT(*) FROM necessarytaxes
        WHERE necessarytaxes.registrationid = payer.registrationid) = 1;
--- b
CREATE OR REPLACE VIEW b AS
SELECT * FROM payer WHERE
name IN (SELECT name FROM payer GROUP BY name HAVING count(*) > 1)
AND NOT EXISTS(
    SELECT tax_code, COUNT(*) FROM payedtax
    JOIN payer on payedtax.registrationid = payer.registrationid
    WHERE name IN (SELECT name FROM payer GROUP BY name HAVING count(*) > 1)
    GROUP BY tax_code
    HAVING NOT COUNT(*) = 1
);
--- c
CREATE OR REPLACE VIEW c AS
SELECT tax_code, SUM(count) as pay_sum FROM payedtax
WHERE date_part('year', date) = 2021
AND (SELECT type FROM payer
WHERE payer.registrationid = payedtax.registrationid) = 'Приватний підприємець'
GROUP BY tax_code ORDER BY pay_sum;
--- d
CREATE OR REPLACE VIEW d AS
SELECT tax_code, SUM(count) as pay_sum FROM payedtax
WHERE date_part('year', date) = 2021 GROUP BY tax_code
ORDER BY pay_sum DESC LIMIT 2;