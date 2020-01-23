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
27 16 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXECB >> CRON_FXECB.log
0,10,20,30,40,50 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXCCYUPDATE >> CRON_FXCCYUPDATE.log
5,15,25,35,45,55 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO BCFXSP >> CRON_BCFXSP.log
2,37 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXFWD >> CRON_BCFXFWD.log
29 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO CHECKIN >> CRON_CHECKIN.log
```
