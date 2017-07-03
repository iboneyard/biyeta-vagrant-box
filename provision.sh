#!/usr/bin/env bash
sudo apt-get update
sudo apt-get -y upgrade

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server libmysqlclient-dev

if [ -d /usr/local/rbenv ]; then
  echo '########## rbenv already installed, skipping.'
else
  echo "########## Installing rbenv ..."
  sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev git g++ make
  sudo git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv
  pushd /usr/local/rbenv/src/configure && make -C src && popd
  sudo mkdir -p /usr/local/rbenv/plugins
  pushd /usr/local/rbenv/plugins
  sudo git clone git://github.com/rbenv/ruby-build.git
  sudo git clone https://github.com/rbenv/rbenv-default-gems.git
  popd
  echo "bundler" | sudo tee /usr/local/rbenv/default-gems

  echo "#!/usr/bin/env bash" | sudo tee -a /etc/profile.d/rbenv.sh
  echo 'export RBENV_ROOT=\"/usr/local/rbenv\"' | sudo tee -a /etc/profile.d/rbenv.sh
  echo 'export PATH=\"$RBENV_ROOT/bin:$PATH\"' | sudo tee -a /etc/profile.d/rbenv.sh
  echo 'which rbenv > /dev/null && eval \"$(rbenv init -)\"' | sudo tee -a /etc/profile.d/rbenv.sh
fi


sudo RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv install 2.1.5
sudo RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv global 2.1.5

RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv versions

cd /app

RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv exec bundle config --local path vendor
RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv exec bundle 
RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv exec bundle exec rake db:create
RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv exec bundle exec rake db:migrate

echo "#####################################################################################################"
echo 
echo "RBENV_ROOT=/usr/local/rbenv /usr/local/rbenv/bin/rbenv exec bundle exec rails s"
echo
echo "#####################################################################################################"
