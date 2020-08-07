# UTILITIES [Price Rate & Index Consumer]
## Purpose
Queries a public rates source (mid rates only) to extract FX spot rates, EONIA & Libor rates which will in time form the basis of a rate import into siena.

http://www.mannyneira.com/universe/basic-practice.html?news
## Structure
```
TBC
```

## Dependancies
* figlet
* curl
* jq
* xmlstarlet
* qm
* git
* chrome


Setup key with:

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
Setup repository with:

sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
Setup package with:
sudo apt-get update
sudo apt-get install google-chrome
sudo apt-get install -f

---
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
sudo apt-get update
sudo apt-get install mssql-cli


---

After installation a number of new directories will have been created;
``` ls
.
├── cat
└── VOC
```
NEVER delete VOC or any folder prefixed with a $ sign!
# Scheduling
Online cron string generater can be found here https://crontab-generator.org/

Add the following to the cron

``` bash
crontab -e
```

``` cron
* 0 * * * cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO PURGE NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_PURGE.log
* 1 * * * cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO CHECKIN NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_GIT.log
25 16 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXECB NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_ECB.log
0 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXREFRESH NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_FXREFRESH.log
10,20,30,40,50 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO BCFXSP NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_FXSP.log
30 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXFWD NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_FXFWD.log
45 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO CHECKIN NOPAGE >> LOGS/$(date +20\%y\%m\%d\%H\%M)_GIT.log
```
