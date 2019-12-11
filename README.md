# UTILITIES [Price Rate & Index Consumer]
## Purpose
Queries a public rates source (mid rates only) to extract FX spot rates, EONIA & Libor rates which will in time form the basis of a rate import into siena.


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


## Installation
### 1) Installing Linux Tools
#### Installing on Debian
```shell
$ sudo apt-get install figlet curl jq xmlstarlet git
```
#### Installing on mac with Homebrew
```shell
$ brew install figlet curl jq xmlstarlet git
```

### 2) Installing QM
QM is Free to use (for 1 user) product from Zumasys which provides powerful string manipulation and data processing capabilities.

https://www.openqm.com/
Downloads can be found at: https://www.openqm.com/downloads/

As OpenQM is a 3rd party product its installation instructions may change, therefore please follow the instructions on the OpenQM website.

#### QM for Windows
Please use the "Self extracting archive for full Windows installation including documentation and QMClient".
#### QM for Linux
Please use the "Self extracting archive for Linux installation (Red Hat, Fedora, Debian, Ubuntu, Suse, Centos, etc)"".

### 3) Installing Product
Change location to the home directory you wish to use going foward e.g.
"/home/sales/qm/account/"
``` shell
git clone https://github.com/mt1976/mwt-QM-dev.git
```
A new folder will be created call mwt-QM-dev

### 4) Installing Processing Tools
When you LOGIN to QM for the first time QM will ask if you wish to create a new 'Account'. Change directory into the directory that was just created by git.
``` shell
$ cd mwt-QM-dev
$ qm
[ QM Rev 3.4-14   Copyright Zumasys Inc., 2019 ]
[ 0103035549  For personal use only ]

Current directory /home/sales/qm/account/mwt-QM-dev is not a valid account. Create account?
```
Type 'Yes', then from the ':' prompt type the following;
``` shell
:COPY FROM $ACC TO VOC INSTALL.UTILS
:INSTALL.UTILS
:COPY FROM $ACC TO VOC INSTALL.SIENA.TOOLS
:INSTALL INSTALL.SIENA.TOOLS
```
Congraturlations! The software is now installed!

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
```
## Support Scripts
All support scripts are held in .../SIENA.SCRIPTS
* * * * *
### mdsInit.sh - Purpose
Call by support scripts to initialise shared parameters.

#### Usage
``` bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
initLoc=$DIR"/mdsInit.sh"
. $initLoc
```
* * * * *
### fxSPfetch.sh - Purpose
Queries a public rates source (mid rates only) to extract FX spot rates which will in time form the basis of a rate import into siena.

* API KEY     : `c3811be81a6df1db0e14304d77b3a23d`
* Series Key  : `USD,JPY,GBP,BTC,CAD,AUD,XAU,CHF,MXN,STD,NOK,DKK,RUR,RMB,HKD,CAD,CHF,DKK,GBP,HKD,JPY,NOK,SEK,SGD,USD,ZAR`
* Source Site : `http://data.fixer.io/api/`
---
### ecbEoniaFetch.sh - Purpose
To collect EONIA data from the ECB
* Series Key  : `198.EON.D.EONIA_TO.RATE`
* Source Site : `https://sdw.ecb.europa.eu`
---
### liborFetch.sh - Purpose
To collect Libor data from the "FRED"

* API KEY : `d4d50b886c05baa2795c363319ca64db`
* Series Key : `CHF12MD156N	CHF1MTD156N	CHF1WKD156N	CHF3MTD156N	CHF6MTD156N	CHFONTD156N	EUR12MD156N	EUR1MTD156N	EUR1WKD156N	EUR2MTD156N	EUR3MTD156N	EUR6MTD156N	EURONTD156N	GBP12MD156N	GBP1MTD156N	GBP1WKD156N	GBP2MTD156N	GBP3MTD156N	GBP6MTD156N	GBPONTD156N	JPY12MD156N	JPY1MTD156N	JPY1WKD156N	JPY2MTD156N	JPY3MTD156N	JPY6MTD156N	JPYONTD156N	USD12MD156N	USD1MTD156N	USD1WKD156N	USD2MTD156N	USD3MTD156N	USD6MTD156N	USDONTD156N
`
* Source Site : `https://api.stlouisfed.org/fred/series/`
---
### cpiFetch.sh - Purpose
To collect cpi data from the "FRED"
* API KEY : `d4d50b886c05baa2795c363319ca64db`
* Series Key: `GBRCPIALLMINMEI CPALCY01USQ661N`
* Source Site : `https://api.stlouisfed.org/fred/series/`
---
# Running on Ubuntu Windows Subsystem
Before running please use dos2unix to remove any CRLF charcters that git introduces when it downloads the file and helpfully thinks its downloading to an windows OS.
```shell
$ dos2unix mdsInit.sh
$ dos2unix fxSPfetch.sh
$ dos2unix ecbFetch.sh
$ dos2unix liborFetch.sh
$ dos2unix cpiFetch.sh
```
## Dependancies
* dos2unix

```shell
$ sudo apt-get install dos2unix
```
---
