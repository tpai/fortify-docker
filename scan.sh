#!/usr/bin/env bash

repo=git@gitlab:app/backend.git
branch=develop
target=/src

echo "--------- Clone repository ------------"

mkdir -p ./scan
git clone $repo ./scan
git checkout $branch

echo "--------- Create container ------------"

docker run --name=fortify -d -v $(pwd)/scan:/scan:rw -i fortify:23.1.0

echo "--------- Create scan mission ---------"

docker exec -it fortify bash -c "sourceanalyzer -b app -python-version 3 -python-path /usr/bin/python3 /scan$target"

echo "--------- Start scan ------------------"

mv bypass.txt ./scan/bypass.txt
docker exec -it fortify bash -c "sourceanalyzer -b app -scan -filter /scan/bypass.txt -f result.fpr"

echo "--------- Generator report ------------"

docker exec -it fortify bash -c "BIRTReportGenerator -template 'Developer Workbook' -source result.fpr -format HTML -output /scan/report.html"

echo "--------- Upload report ---------------"

open ./scan/report.html

echo "--------- Remove container ------------"

docker rm -f fortify
