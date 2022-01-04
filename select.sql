--- a
SELECT SUM(count) FROM payedtax
    JOIN payer on payedtax.registrationid = payer.registrationid
    WHERE (quarter = '4' OR (age(date) <= '92 days 6 hours'::interval))
      AND name SIMILAR TO '%ав%' AND
        (SELECT COUNT(*) FROM necessarytaxes
        WHERE necessarytaxes.registrationid = payer.registrationid) = 1;
--- b
SELECT * FROM payer;
--- c
--- d
SELECT tax_code, SUM(count) as pay_sum FROM payedtax group by tax_code
ORDER BY pay_sum DESC LIMIT 2;