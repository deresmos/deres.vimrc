#! /bin/bash

if [ ! -d ./composer ]; then
	mkdir composer
fi

cd composer

curl -sS https://getcomposer.org/installer | php &&
echo 'Move composer.phar to /usr/local/bin/composer'
sudo mv composer.phar /usr/local/bin/composer
