#!/bin/bash

echo "ENTRYPOINT"
until nc -z -v -w30 20.2.0.31 5432 > /dev/null 2>&1
do
	echo "Waiting for db connection..."
	sleep 2
done

echo "is working"

cat config/database.yml

echo "EXECUTING exec rake db:schema:load"
bundle exec rake db:schema:load
bundle exec rake db:migrate

bundle exec rake ts:index
bundle exec rake ts:config
bundle exec rake db:install
bundle exec rake ts:rebuild
rails s