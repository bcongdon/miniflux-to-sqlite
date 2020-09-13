#!/usr/bin/env bash
set -e

database="postgresql://miniflux:secret@localhost/miniflux"
db-to-sqlite $database miniflux.db --all --redact entries document_vectors
sqlite-utils query miniflux.db "DELETE FROM entries WHERE status == 'removed';"
sqlite-utils enable-fts miniflux.db entries content
sqlite-utils optimize miniflux.db
