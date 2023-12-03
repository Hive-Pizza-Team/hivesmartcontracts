# Hive Smart Contracts [![Build Status](https://app.travis-ci.com/hive-engine/hivesmartcontracts.svg?branch=main)](https://app.travis-ci.com/github/hive-engine/hivesmartcontracts)

 ## 1.  What is it?

Hive Smart Contracts is a sidechain powered by Hive, it allows you to perform actions on a decentralized database via the power of Smart Contracts.

 ## 2.  How does it work?

This is actually pretty easy, you basically need a Hive account and that's it. To interact with the Smart Contracts you simply post a message on the Hive blockchain (formatted in a specific way), the message will then be catched by the sidechain and processed.

 ## 3.  Sidechain specifications
- run on [node.js](https://nodejs.org)
- database layer powered by [MongoDB](https://www.mongodb.com/)
- Smart Contracts developed in Javascript
- Smart Contracts run in a sandboxed Javascript Virtual Machine called [VM2](https://github.com/patriksimek/vm2)
- a block on the sidechain is produced only if transactions are being parsed in a Hive block

## 4. Setup a Hive Smart Contracts node

see wiki: https://github.com/hive-engine/hivesmartcontracts-wiki

In addition, the following is needed to use transaction framework for MongoDB:
- Run MongoDB in replicated mode. This is as simple as changing the mongo config to add replication config:
  ```
    replication:
      replSetName: "rs0"
  ```
  and then enabling replication by using the mongo shell:
  ```
  mongo
  > rs.initiate()
  ``` 
  See https://docs.mongodb.com/manual/tutorial/convert-standalone-to-replica-set/ for details.
  Also, if you are /upgrading/ from a previous MongoDB, you need to take careful extra steps and follow
  https://docs.mongodb.com/manual/release-notes/4.4-upgrade-standalone/
  carefully.
- Need version 3.6.3 mongo node library.

Also, if using PM2, you will need to start the process with --no-treekill for proper shutdown. Also
consider using --no-autorestart with proper monitoring to minimize noise and potential for problematic
looping (though with transactions there is less risk of data corruption). Another oddity with PM2 is
 that you may need to clear node processes after a stop if the process does not terminate on its own. 
Otherwise it will interfere with logging.

E.g.
```
pm2 start app.js --no-treekill --kill-timeout 10000 --no-autorestart
```

### DB Backup and Restore

Backup current state (track current hive blpck in config)

`mongodump -d=hsc --gzip --archive=hsc_50287280.archive`

Restore state

`mongorestore --gzip --archive=hsc_50287280.archive`

Edit config.json to match block number of backup.

### Set up Hive Smart Contracts

#### First time start up

- set configuration in `.env` and `config.json`
- `docker compose build`
- `docker compose up -d mongo initimongo`
- `RESTORE_PARTIAL=1 docker compose up -d he`
- - set RESTORE_PARTIAL environment variable to restore the database from a snapshot. You do not want to do this every time the node starts or re-starts, since it can take 2 hours+ to complete the restore.

#### Normal start up

- `docker compose up -d`

#### Monitor hivesmartcontracts app logs

- `docker compose logs -f --tail=100 he`

## 5. Tests
* npm run test

## 6. Usage/docs

* see wiki: https://github.com/hive-engine/hivesmartcontracts-wiki
