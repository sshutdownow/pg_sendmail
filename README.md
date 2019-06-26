# pg_sendmail

pg_sendmail is [PostgreSQL](https://www.postgresql.org/) extension that implements mail function that rely on sendmail binary, say, [ssmtp](https://packages.debian.org/stable/mail/ssmtp).
There are some working examples that implement similar functionality in [Perl](https://ora2pg.darold.net/slides/ora2pg_the_hard_way.pdf#Example%20UTIL_SMTP) or [TCL](https://github.com/captbrando/pgMail). But perl add about 20Megs to every postgresql proccess and if it is the only one function in perl, you, perhaps, prefer my way.

Installation
------------
1. Download and unpack.
2. Compile source code, to fullfill it for RedHat/CentOS postgresql-devel package is required (yum install postgresql-devel), for Debian/Ubuntu you should install postgresql-server-dev package (apt-get install postgresql-server-dev):
`make`
3. Install:
`sudo make install`
4. Register extension in PostgreSQL:
`CREATE EXTENSION pg_sendmail;`

Usage:
------
To send mail wrapper function sendmail(text mailfrom, text rcpto, text subject, text msg_body) is very convinient to use, for example:
`SELECT sendmail('fromme@somedomain.com', 'tomygoodfriend@anotherdomain.com', 'test mail', E'mail message\nalso one line');`

### Copyright

  Copyright (c) 2017-2019 Igor Popov

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
