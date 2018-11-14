# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
function refreshssh(){
 eval $(ssh-agent -s)
 ssh-add ~/.ssh/id_rsa-frankenbuilder
}
refreshssh

alias cd..="cd .."
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rbenv/bin

export PATH

eval "$(rbenv init -)"
export PATH="/home/centos/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias bashrc="vim ~/.bashrc"
alias sourcebashrc="source ~/.bashrc"
alias bi="bundle install --path=./.bundle/gems"
alias bu="bundle update"
alias be="bundle exec"
alias runspec="bundle exec rake spec"

function addupstream(){
  git remote add upstream git@github.com:puppetlabs/$1
  git remote set-url upstream --push push.invalid
}

function addupstreampush(){
  git remote add upstream git@github.com:puppetlabs/$1
}

function clone(){
  git clone git@github.com:$1/$2.git
} 

function frankbase(){
  local workdir=$(mktemp -dp /home/centos/workdirs)
  echo $workdir
  local version=$1
  cd ~/frankenbuilder
  ./frankenbuilder $version --workdir $workdir --install --vmpooler --preserve_hosts=always --keyfile=/home/centos/.ssh/id_rsa-acceptance ${@:2}
}
function frankmono(){
  frankbase $@
}
function franksplit(){
  frankbase $@ --split --master=master.vm --console=console.vm --puppetdb=puppetdb.vm 
}
function frankha(){
  frankbase $@ --ha --provision
}
function franklei(){
  frankbase $@ --lei
}

function beakerrerun(){
  bundle exec beaker --helper lib/beaker_helper.rb --debug --keyfile ~/.ssh/id_rsa-acceptance --no-provision --hosts=$1 --tests=$2
}

alias beakermono="bundle exec beaker --helper lib/beaker_helper.rb --debug --keyfile ~/.ssh/id_rsa-acceptance --provision --hosts ~/repos/hosts/hosts_mono.yml"
alias beakersplit="bundle exec beaker --helper lib/beaker_helper.rb --debug --keyfile ~/.ssh/id_rsa-acceptance --provision --hosts ~/repos/hosts/hosts_split_legacy.yml"
loginvm(){
  ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa centos@$1
}

loginvmpooler(){
  ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa-acceptance $1
}
alias config='/usr/bin/git --git-dir=/home/centos/.cfg/ --work-tree=/home/centos'
