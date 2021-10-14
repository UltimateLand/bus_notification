# Bus No.672 notification

Send notification to registered emails if No.672 is arriving in 10 minutes.

## Prerequisite

* Work under Linux environment.

* PostgreSQL installed.

## Get started
Set environment variables `SMTP_SERVER`, `DOMAIN_NAME`, `SMTP_USER_NAME`, `SMTP_PASSWORD` in `~/.bashrc` for using SMTP service. Then change directory into project, use command `source script/setup` to setup environment, and use command `source script/register $YOUR_EMAIL` to register notification.
