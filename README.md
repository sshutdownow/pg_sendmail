# pg_sendmail
initial commit

pg_sendmail is [PostgreSQL](https://www.postgresql.org/) extension that implements mail function that rely on sendmail binary.
There are some working examples that implement similar functionality in Perl or TCL. But perl add about 20Megs to every postgresql proccess and if it is the only one function in perl, you, perhaps, prefer my way.
