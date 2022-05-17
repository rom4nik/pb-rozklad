# pb-rozklad

A shell script (with JS addon for FB Messenger support) that checks [PB schedules](https://degra.wi.pb.edu.pl/rozklady/rozklad.php?page=st) for changes and messages students when they occur, highlighting modified sections of PDFs.

Discord example:

![Screenshot_20220518_000851](https://user-images.githubusercontent.com/46846000/168918926-2398f1d4-e6bc-4928-895a-1fbb22143739.png)


## Setup
Dockerfile defaults to running the script in a cron-like manner, see `docker-compose.yml` for an example deployment. Make sure to set `xx_ENABLED=false` in config.txt if you don't intend to use a particular messaging platform.

## appstate.json for FB Messenger
https://github.com/shellmage/AAAAAAAAAAAAA/blob/main/getAppstate.js

This script is partially broken. Outside container run `npm install puppeteer`, run script above without headless mode, click the login button manually, then move generated appstate.json to `/data` inside container.

## Matrix support
Put https://github.com/fabianonline/matrix.sh/ in `/data`. Run it once inside container using `HOME=/data/matrix.sh /data/matrix.sh/matrix.sh --login` to obtain access token.

E2EE rooms aren't supported for the time being.

## Tests
- no schedule (HTTP 404)
- first schedule
- schedule without changes
- schedule with changes
