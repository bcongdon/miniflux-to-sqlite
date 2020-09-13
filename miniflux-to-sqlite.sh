#!/usr/bin/env bash
set -e

print_usage() {
	echo "miniflux-to-sqlite - export miniflux data"
	echo " "
	echo "Usage: miniflux-to-sqlite.sh database [flags]"
	echo " "
	echo "options:"
	echo "-h	the miniflux database host"
	echo "-u	the miniflux database username"
	echo "-p	the miniflux database password"
	echo "-d	the miniflux database"
	exit 0
}

verbose='false'
user='miniflux'
pass='secret'
host='localhost'
database='miniflux'
while getopts 'uphd:v' flag; do
  case "${flag}" in
    u) user="${OPTARG}" ;;
    p) pass="${OPTARG}" ;;
    h) host="${OPTARG}" ;;
    d) database="${OPTARG}" ;;
    v) verbose='true' ;;
    *) print_usage ;;
  esac
done

db_file="$1"
if [ -z "$db_file" ]; then
	echo "No database file provided."
	print_usage
fi

connection_str="postgresql://$user:$pass@$host/$database"

echo "Exporting database..."
db-to-sqlite $connection_str $db_file --all --redact entries document_vectors --progress

echo "Cleaning up removed entries..."
sqlite-utils query $db_file "DELETE FROM entries WHERE status == 'removed';"

has_fts=$(sqlite-utils query $db_file "SELECT name FROM sqlite_master WHERE type='table' AND name='entries_fts';")
if [[ -z $has_fts ]]; then
	echo "Enabling fts..."
	sqlite-utils enable-fts $db_file entries content --create-triggers
fi

echo "Optimizing db..."
sqlite-utils optimize $db_file
