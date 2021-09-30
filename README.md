# pb-rozklad

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