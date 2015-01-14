#!/bin/bash

echo "transform"
cmark.py index.md > index.html
cmark.py tamara/index.md > tamara/index.html
cmark.py tamara/tamara-timmons-cv.md > tamara/tamara-timmons-cv.html

echo "additionally gzip"
find . -type f -name "*.html" -exec sh -c 'gzip {} --stdout > {}.gz' \;

echo "sync"
aws --profile pjnet s3 sync --exclude "*" --include "*.html" --cache-control "max-age=43200" . s3://timmons-dot-me/
aws --profile pjnet s3 sync --exclude "*" --include "*.html.gz" --cache-control "max-age=43200" --content-encoding="gzip" . s3://timmons-dot-me/

echo "done"