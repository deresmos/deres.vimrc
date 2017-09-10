#! /bin/bash

wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O php-cs-fixer &&
sudo chmod a+x php-cs-fixer &&
sudo mv php-cs-fixer /usr/local/bin/php-cs-fixer
