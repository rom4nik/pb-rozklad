# pb-rozklad


## Docker:
Build: `docker build . --tag rom4nik/pb-rozklad`

Run: `docker run --rm --name pb-rozklad-test --volume "<ścieżka-do-danych>:/data" rom4nik/pb-rozklad`


## Debian:
### Wymagane:
Shell: bash, curl, diff, imagemagick (convert, compare), ghostscript

Python3: fbchat, pyotp

### Konfiguracja:
- Odblokowanie konwersji PDF w ImageMagick: https://stackoverflow.com/a/59193253
- Problemy z HTTPS na PB: https://imlc.me/dh-key-too-small


## Testy:
- 404 (brak rozkładu)
- pierwszy rozkład
- powtórka rozkładu
- zmieniony rozkład