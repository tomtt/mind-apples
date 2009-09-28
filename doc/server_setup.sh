sudo apt-get update
sudo apt-get dist-upgrade

sudo apt-get install build-essential
sudo apt-get install ruby ri rdoc mysql-server libmysql-ruby ruby1.8-dev irb1.8 libdbd-mysql-perl libdbi-perl libmysql-ruby1.8 libmysqlclient15off libnet-daemon-perl libplrpc-perl libreadline-ruby1.8 libruby1.8 mysql-client-5.0 mysql-common mysql-server-5.0 rdoc1.8 ri1.8 ruby1.8 irb libopenssl-ruby libopenssl-ruby1.8 libhtml-template-perl mysql-server-core-5.0

mkdir ~/install
cd ~/install
wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz
tar zxf rubygems-1.3.5.tgz
cd ~/install/rubygems-1.3.5
sudo ruby setup.rb
sudo ln -s /usr/bin/gem1.8 /usr/local/bin/gem
sudo ln -s /usr/bin/ruby1.8 /usr/local/bin/ruby
sudo ln -s /usr/bin/rdoc1.8 /usr/local/bin/rdoc
sudo ln -s /usr/bin/ri1.8 /usr/local/bin/ri
sudo ln -s /usr/bin/irb1.8 /usr/local/bin/irb

sudo gem install rails --no-rdoc --no-ri

sudo apt-get install libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g zlib1g-dev lsb-base
sudo apt-get install apache2-prefork-dev libapr1-dev libaprutil1-dev

mkdir -p ~/mindapples/current
sudo chown -R www-data:www-data ~/mindapples/current

sudo gem install passenger

(
cat <<EOF
   <VirtualHost *:80>
      ServerName mindapples.org
      DocumentRoot /home/mindapples/mindapples/current/public
   </VirtualHost>
EOF
) > /tmp/site
sudo mv /tmp/site /etc/apache2/sites-available/mindapples
sudo a2ensite mindapples
sudo /etc/init.d/apache2 reload

sudo gem install mysql --no-rdoc --no-ri

sudo apt-get install git-core