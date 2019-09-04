--
-- This gets rid of my abortive attempts at normalisation
-- of UKDS datasets from the dictionaries schema, as
-- the weird views and enums I created make loading
-- the schema difficult from saved files. In any case
-- the normalisations never worked and wouldn't be
--  needed now we're targetting dataframes rather than SQL tables
-- for data storage.
--
alter table dictionaries.tables drop column table_type;
alter table dictionaries.tables drop column  key1;
alter table dictionaries.tables drop column  key1_type;
alter table dictionaries.tables drop column  key2;
alter table dictionaries.tables drop column  key2_type;
alter table dictionaries.tables drop column  key3;
alter table dictionaries.tables drop column  key3_type;
drop view dictionaries.efs_normalisations ;

alter table dictionaries.variables drop column normalised_variable;

-- forgot to downcase new FRS variables
update dictionaries.variables set name=lower(name) where dataset in ('frs', 'lcf', 'shs' ) and year >= 2016;
