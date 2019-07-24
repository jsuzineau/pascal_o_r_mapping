SELECT
      conrelid::regclass AS NomTable,
      conname as "Constraint",
      pg_get_constraintdef(c.oid) as Definition
FROM
    pg_constraint c
JOIN
    pg_namespace n
    ON
      n.oid = c.connamespace
WHERE
     contype IN ('p')
AND
   n.nspname = 'public' -- your schema here
ORDER  BY
       conrelid::regclass::text,
       contype DESC;
