#TODO
## Randomizer
* Move data-load out of loop to start of loop, then do lookup into array.
* Create a new job - PayloadControl - with in/out folders, this allows variables such as batch size/sample number to be setup.
* Create a new job - PayloadRunner  - allows user to drop in a file with commands in "BATCH.DO/JOB.DO" format
* Expose SIENA.TXN.TEMPLATES through SAMBA - Allow users to defined templates to use to generate data
* Expost PayloadControl_IN through SAMBA - Allows users to setup batch sizes etc.
* Expose PayloadRunner_IN through SAMBA - Runs a BATCH/JOB.DO job - "JOB.DO RANDOMIZER"
* Expose SIENA.TXN.OUT though SAMBA - Destination Path for output dat
