# miniflux-to-sqlite
Script to export Miniflux's database to sqlite

## Usage

```
miniflux-to-sqlite - export miniflux data

Usage: miniflux-to-sqlite.sh database [flags]

options:
-h	the miniflux database host
-u	the miniflux database username
-p	the miniflux database password
-d	the miniflux database
```

### Examples

```sh
# Use default db credentials
./miniflux-to-sqlite.sh miniflux.db

# Provide credentials
./miniflux-to-sqlite.sh miniflux.db -u my_miniflux -p secret -d my_miniflux_db -h 127.0.0.1
```
