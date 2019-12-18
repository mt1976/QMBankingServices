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
├── $COMO
├── $HOLD
├── $HOLD.DIC
├── SIENA.BP
├── SIENA.BP.DIC
├── SIENA.BP.OUT
├── SIENA.CONFIG
├── SIENA.CONFIG.DIC
├── SIENA.DEST
├── SIENA.DEST.DIC
├── SIENA.IN
├── SIENA.IN.BK
├── SIENA.IN.BK.DIC
├── SIENA.IN.DIC
├── SIENA.LOC1
├── SIENA.LOC1.DIC
├── SIENA.LOC2
├── SIENA.LOC2.DIC
├── SIENA.PROCESSED
├── SIENA.PROCESSED.DIC
├── SIENA.SCRIPTS
├── SIENA.SCRIPTS.DIC
├── SIENA.STAGING
├── SIENA.STAGING.DIC
├── SIENA.TEMP
├── SIENA.TEMP.DIC
├── stacks
├── SUPPORT.DOCUMENTS
├── $SVLISTS
├── UTIL.BACKUP
├── UTIL.BACKUP.DIC
├── UTIL.BP
├── UTIL.BP.DIC
├── UTIL.BP.OUT
├── UTIL.CMD.EVENT
├── UTIL.CMD.EVENT.DIC
├── UTIL.CMD.LOG
├── UTIL.CMD.LOG.DIC
├── UTIL.CONFIG
├── UTIL.CONFIG.DIC
├── UTIL.FILE.DEFINITIONS
├── UTIL.FILE.DEFINITIONS.DIC
├── UTIL.FILE.HELPER
├── UTIL.LOG
├── UTIL.LOG.DIC
├── UTIL.TRANSFER
├── UTIL.TRANSFER.DIC
├── UTIL.TRANSLATE
├── UTIL.TRANSLATE.DIC
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
0 16 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXECB >> CRON_FXECB.log
0 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXSPOT >> CRON_FXSPOT.log
15 10 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO FXFWD >> CRON_FXFWD.log
20 6-18 * * 1-5 cd /home/sales/qm/account/mwt-QM-dev && /usr/local/bin/qm SIENA.DO CHECKIN >> CRON_CHECKIN.log
```
