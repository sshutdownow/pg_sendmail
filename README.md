# pg_sendmail
initial commit

pg_sendmail is [PostgreSQL](https://www.postgresql.org/) extension that implements mail function that rely on sendmail binary, say, [ssmtp](https://packages.debian.org/stable/mail/ssmtp).
There are some working examples that implement similar functionality in [Perl](https://ora2pg.darold.net/slides/ora2pg_the_hard_way.pdf#Example%20UTIL_SMTP) or [TCL](https://github.com/captbrando/pgMail). But perl add about 20Megs to every postgresql proccess and if it is the only one function in perl, you, perhaps, prefer my way.

### Copyright

  Copyright (c) 2017 Igor Popov

License
-------
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

### Authors

  Igor Popov
  (ipopovi |at| gmail |dot| com)
