  The software for an article in International Spectrum Magazine 2012 about REST and WEB using openqm.
  Date: 21 March 2012, Abingdon, England

  Copyright (c) 2010 TO 2012 to 2008 mike.ryder@pwchest.com, All Rights Reserved
  This program suite is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2, or (at your option)
  any later version.
  This program suite is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  The code included in this package was written to demonstrate the REST capability of openqm
  and should not be taken as a definitive way of coding or operation.

  My environment consists of a virtual machine with 1GB memory and 10GB of disk,
  32 bit ubuntu11.10 and qm_2-12-8.
  I have no MASTER.LOGIN or LOGIN paragraphs which is important.
  I use joe as my unix editor and most of the editable bits I have created as directories for this reason.
  It also means that I can easily copy from a unix directory.
  Within this code package are some utilities to facilitate some database stuff.
  They are primitive but serve the purpose for the sandbox.

  All server access uses ssh so you will need an ssh client like putty if you want to connect
  from another workstation. There is no root access in ubuntu and all root-like access is
  handled by sudo, for which you need your login password.

  Once you have openqm up and running, do everything from the openqm prompt.
  Notice that !cmd executes a unix shell command.

  This is a development account so set permissions as everything (777).
  You will probably fall over permissions at least once.

  The logfiles you need are at /etc/apache2/log, webdev/logfile and /usr/qmsys/errlog.

  After you have installed your server, you will need some additional bits for your Linux server:

  sudo apt-get install openssh apache2 joe unzip php5-cli

  Not necessary, but you may like:

  sudo apt-get install subversion gnome-terminal mc php5

  Head off to http://www.openqm.com and download openqm for Linux, get a 30 day licence and install.

  Create a data account for the website as follows:

  sudo bash
  mkdir p /usr/qmaccounts/webdev
  chmod R 777 /usr/qmaccounts/webdev
  cd /usr/qmaccounts/webdev
  qm

  You will need the code package at http://openqm.com/cgi/docs/webbp.tar which was built for this article.

  cd /var/qmaccounts/webdev
  qm
  !wget http://openqm.com/cgi/docs/webbp.tar
  !tar xvf webbp.tar
  CREATE-FILE WEB.BP DIRECTORY
  !cp SOURCE/WSH WEB.BP
  BASIC WEB.BP WSH
  WSH SOURCE/I_INSTALL.SH
  OFF

  Login again
  qm -awebdev

  At this point, we have an account and the database is up and running and we are logged in.
  Test the result.
  OFF
  qm -awebdev -quiet WEBAPP
  This is not using the web but determines if you have any errors.
  Take a look at the log and check for any errors.

  INSTALLWEB to setup the web bits

  CLEARLOG to clear the logfile
  WS to display the logfile

  Create an apache site for our website from the openqm shell.

  INSTALLWEB

  Test your new website. Dial up http://localhost/qmweb/webapp

Last Build:

Wed Mar 28 10:46:57 BST 2012
