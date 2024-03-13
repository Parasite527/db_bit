# Установка

Установить по инструкции из файла с лекции не получилось на моей ОС, 
поэтому устанавливал архивом:
```shell
curl -O http://downloads.mongodb.org/linux/mongodb-linux-x86_64-2.6.12.tgz
tar -zxvf mongodb-linux-x86_64-2.6.12.tgz
ls
rm mongodb-linux-x86_64-2.6.12.tgz
ls mongodb-linux-x86_64-2.6.12
ls mongodb-linux-x86_64-2.6.12/bin
sudo apt-key list
cd mongodb-linux-x86_64-2.6.12/bin
./mongod --dbpath ~/test_mon
./mongo
```
Вывод:
```shell
┌──(ltlo㉿ltlo)-[~/mongodb-linux-x86_64-2.6.12/bin]
└─$ ./mongo                     
MongoDB shell version: 2.6.12
connecting to: test
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
        http://docs.mongodb.org/
Questions? Try the support group
        http://groups.google.com/group/mongodb-user
> help
        db.help()                    help on db methods
        db.mycoll.help()             help on collection methods
        sh.help()                    sharding helpers
        rs.help()                    replica set helpers
        help admin                   administrative help
        help connect                 connecting to a db help
        help keys                    key shortcuts
        help misc                    misc things to know
....
```
# Операции

Создание
```shell
> db.createCollection("Base")
{ "ok" : 1 }
```

Вставка + простой поиск
```shell
> db.Base.getDB()
> db.Base.insert({
...             "fname":"Ron", 
...             "city":"United States of America", 
...             "courses":[
...                          "python", 
...                          "django", 
...                          "node"
...                       ]
... })
sber_mongo
> db.Base.count()
1
> db.Base.insert({             "fname":"Ron",              "city":"United States of America",              "courses":[                          "python",                           "django",                           "node"                       ] })
WriteResult({ "nInserted" : 1 })
> db.Base.count()
2
> db.Base.find()
{ "_id" : ObjectId("65f1bf6745672db219d5a4dc"), "fname" : "Ron", "city" : "United States of America", "courses" : [ "python", "django", "node" ] }
{ "_id" : ObjectId("65f1c07445672db219d5a4dd"), "fname" : "Ron", "city" : "United States of America", "courses" : [ "python", "django", "node" ] }
> 
```
Вставка датасета:
```shell
┌──(ltlo㉿ltlo)-[~/mongodb-linux-x86_64-2.6.12/bin]
└─$ ./mongoimport --db sber_mongo --collection Base --file ~/data.json --jsonArray
connected to: 127.0.0.1
2024-03-13T06:12:40.016-1000 check 9 100
2024-03-13T06:12:40.016-1000 imported 100 objects
                                                                                            
┌──(ltlo㉿ltlo)-[~/mongodb-linux-x86_64-2.6.12/bin]
└─$ for i in {0..1000}; do ./mongoimport --db sber_mongo --collection Base --file ~/data.json --jsonArray; done
connected to: 127.0.0.1
2024-03-13T06:14:29.604-1000 check 9 100
2024-03-13T06:14:29.604-1000 imported 100 objects
connected to: 127.0.0.1
2024-03-13T06:14:29.654-1000 check 9 100
2024-03-13T06:14:29.654-1000 imported 100 objects
connected to: 127.0.0.1
....
```
Проверка (в терминале mongo)
до удаления
```shell
> db.Base.count()
100
> db.Base.count({"hash": "aab976bdf7091a6dbd024000c091e901c8b3a2deb614f4c50a57afdf30a21e8e"})
1
> db.Base.find()
{ "_id" : ObjectId("65f1bf6745672db219d5a4dc"), "fname" : "Ron", "city" : "United States of America", "courses" : [ "python", "django", "node" ] }
{ "_id" : ObjectId("65f1c07445672db219d5a4dd"), "fname" : "Ron", "city" : "United States of America", "courses" : [ "python", "django", "node" ] }
{ "_id" : ObjectId("65f1c3fda44ee5c91d7ceaf2"), "txs" : [ { "hash" : "467289197176efa9bd53f46e82e9453e0622f8e08678cac5c84f19e0d63f5bfa", "ver" : 1, "vin_sz" : 1, "vout_sz" : 1, "size" : 194, "weight" : 449, "fee" : 3051, "relayed_by" : "0.0.0.0", "lock_time" : 0, "tx_index" : NumberLong("8808634240467753"), "double_spend" : false, "time" : 1710341474, "block_index" : null, "block_height" : null, "inputs" : [ { "sequence" : NumberLong("4294967295"), "witness" : "0247304402206689a4643c651bb43153a7dace67a5b5d6e027cd468c3689a6f8fcf7877ee4e0022033b0c2b1f1144930c67db005bccbaec92cdafa154d164b0c20b49ca80223c07e0121029478c91e97929d4fbd615ed2ca89222059ef2989d5dd809d317fb3843169c403", "script" : "", "index" : 0, "prev_out" : { "addr" : "bc1q7u0n77wfp8pky7lmxhjcrjrj4vlx8d66druq0q", "n" : 20, "script" : "0014f71f3f79c909c3627bfb35e581c872ab3e63b75a", "spending_outpoints" : [ { "n" : 0, "tx_index" : NumberLong("8808634240467753") } ], "spent" : true, "tx_index" : NumberLong("2713558354784762"), "type" : 0, "value" : 735395 } } ], "out" : [ { "type" : 0, "spent" : false, "value" : 732344, "spending_outpoints" : [ ], "n" : 0, "tx_index" : NumberLong("8808634240467753"), "script" : "76a91445a70579cb2c7b6f51e4a38c1e01a9ae5e3fbae488ac", "addr" : "17MHi5yy9kwbhKqAydiLwyTkkaXF48MAGv" } ] }, { "hash" : "26104a6c4524f1e8bd46a5123f02311889bb1b2ccab5c580986e8e27696415fa", "ver" : 2, "vin_sz" : 3, "vout_sz" : 5, "size" : 559, "weight" : 1507, "fee" : 6384, "relayed_by" : "0.0.0.0", "lock_time" : 0, "tx_index" : NumberLong("8799033147847117"), "double_spend" : false, "time" : 1710341474, "block_index" : null, "block_height" : null, "inputs" : [ { "sequence" : NumberLong("4294967295"), "witness" : "01411ad0d1d8d3315cd019158185e54c407a21a59ae4a4a0b50573e06b514d76367f27cf8f2ee11e5d7cb02efb4cd2ad4d88a62711cc1c585cd2034c7aa3ba1fc43283", "script" : "", "index" : 0, "prev_out" : { "addr" : "bc1pfxls7lxtkqgqj8c6knfj7s854ceu4vwswve2r37lmp0qlhj7d4dslsmr8l", "n" : 0, "script" : "512049bf0f7ccbb010091f1ab4d32f40f4ae33cab1d07332a1c7dfd85e0fde5e6d5b", "spending_outpoints" : [ { "n" : 0, "tx_index" : NumberLong("8799033147847117") } ], "spent" : true, "tx_index" : NumberLong("1557628348959093"), "type" : 0, "value" : 546 } }, { "sequence" : NumberLong("4294967295"), "witness" : "0248304502210088594cac42332518f293eeb4d49765d407447b5ac60280e51bf861e3d7ce30d90220373256862606a46d9f51f28369b2b547f7fe5c9b9ae9027f233b9563f583c9be812103b9bcae8a5c484676b2a3fffb15a623b98809a9fe1d22ef1ee137e3a363903afe", "script" : "", "index" : 1, "prev_out" : { "addr" : "bc1qe6g7m504uvgtjqnm6p427fz8w5tyq6mzwcfafh", "n" : 3, "script" : "0014ce91edd1f5e310b9027bd06aaf24477516406b62", "spending_outpoints" : [ { "n" : 1, "tx_index" : NumberLong("8799033147847117") } ], "spent" : true, "tx_index" : NumberLong("3602058553230036"), "type" : 0, "value" : 4999 } }, { "sequence" : NumberLong("4294967295"),
...
```
Очистим
```shell
> db.Base.remove({})
WriteResult({ "nRemoved" : 100 })
>
```
После заупска цикла на 1000:
```shell
> db.Base.count()
96508
>
```
Запрос на больших данных + настройка времени запросов (таблица db.system.profile)
```shell
> db.setProfilingLevel(0)
{ "was" : 2, "slowms" : 100, "ok" : 1 }
> db.system.profile.drop()
true
> db.setProfilingLevel(2)
{ "was" : 0, "slowms" : 100, "ok" : 1 }
> db.system.profile.find()
> db.system.profile.find()
{ "op" : "query", "ns" : "sber_mongo.system.profile", "query" : {  }, "ntoreturn" : 0, "ntoskip" : 0, "nscanned" : 0, "nscannedObjects" : 0, "keyUpdates" : 0, "numYield" : 0, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(99), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(4), "w" : NumberLong(3) } }, "nreturned" : 0, "responseLength" : 20, "millis" : 0, "execStats" : { "type" : "COLLSCAN", "works" : 2, "yields" : 0, "unyields" : 0, "invalidates" : 0, "advanced" : 0, "needTime" : 1, "needFetch" : 0, "isEOF" : 1, "docsTested" : 0, "children" : [ ] }, "ts" : ISODate("2024-03-13T16:16:29.093Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
> db.Base.count({"hash": "aab976bdf7091a6dbd024000c091e901c8b3a2deb614f4c50a57afdf30a21e8e"})
965
> db.system.profile.find()
{ "op" : "query", "ns" : "sber_mongo.system.profile", "query" : {  }, "ntoreturn" : 0, "ntoskip" : 0, "nscanned" : 0, "nscannedObjects" : 0, "keyUpdates" : 0, "numYield" : 0, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(99), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(4), "w" : NumberLong(3) } }, "nreturned" : 0, "responseLength" : 20, "millis" : 0, "execStats" : { "type" : "COLLSCAN", "works" : 2, "yields" : 0, "unyields" : 0, "invalidates" : 0, "advanced" : 0, "needTime" : 1, "needFetch" : 0, "isEOF" : 1, "docsTested" : 0, "children" : [ ] }, "ts" : ISODate("2024-03-13T16:16:29.093Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
{ "op" : "query", "ns" : "sber_mongo.system.profile", "query" : {  }, "ntoreturn" : 0, "ntoskip" : 0, "nscanned" : 1, "nscannedObjects" : 1, "keyUpdates" : 0, "numYield" : 0, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(91), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(2), "w" : NumberLong(3) } }, "nreturned" : 1, "responseLength" : 568, "millis" : 0, "execStats" : { "type" : "COLLSCAN", "works" : 3, "yields" : 0, "unyields" : 0, "invalidates" : 0, "advanced" : 1, "needTime" : 1, "needFetch" : 0, "isEOF" : 1, "docsTested" : 1, "children" : [ ] }, "ts" : ISODate("2024-03-13T16:16:32.962Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
{ "op" : "command", "ns" : "sber_mongo.$cmd", "command" : { "count" : "Base", "query" : { "hash" : "aab976bdf7091a6dbd024000c091e901c8b3a2deb614f4c50a57afdf30a21e8e" }, "fields" : {  } }, "keyUpdates" : 0, "numYield" : 0, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(86054), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(4), "w" : NumberLong(2) } }, "responseLength" : 48, "millis" : 86, "execStats" : {  }, "ts" : ISODate("2024-03-13T16:16:38.240Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
>
```
Долгий запрос:
```shell
> db.Base.find({"hash": "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1}).count()
1966
> db.system.profile.find({millis: {$gt: 3}})
{ "op" : "command", "ns" : "sber_mongo.$cmd", "command" : { "count" : "Base", "query" : { "hash" : "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1 }, "fields" : {  } }, "keyUpdates" : 0, "numYield" : 9, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(1802628), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(31), "w" : NumberLong(2) } }, "responseLength" : 48, "millis" : 1018, "execStats" : {  }, "ts" : ISODate("2024-03-13T18:11:36.296Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
> 
```
Создадим индекс:

```shell
> db.Base.createIndex({"hash": 1})
{
        "createdCollectionAutomatically" : false,
        "numIndexesBefore" : 1,
        "numIndexesAfter" : 2,
        "ok" : 1
}
> db.Base.getIndexes()
[
        {
                "v" : 1,
                "key" : {
                        "_id" : 1
                },
                "name" : "_id_",
                "ns" : "sber_mongo.Base"
        },
        {
                "v" : 1,
                "key" : {
                        "hash" : 1
                },
                "name" : "hash_1",
                "ns" : "sber_mongo.Base"
        }
]
>
```
Повторим запрос и измерим скорость с индексом:
```shell
> db.Base.find({"hash": "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1}).count()
1966
> db.system.profile.find({millis: {$gt: 100}})
{ "op" : "command", "ns" : "sber_mongo.$cmd", "command" : { "count" : "Base", "query" : { "hash" : "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1 }, "fields" : {  } }, "keyUpdates" : 0, "numYield" : 9, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(1802628), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(31), "w" : NumberLong(2) } }, "responseLength" : 48, "millis" : 1018, "execStats" : {  }, "ts" : ISODate("2024-03-13T18:11:36.296Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
{ "op" : "command", "ns" : "sber_mongo.$cmd", "command" : { "createIndexes" : "Base", "indexes" : [ { "key" : { "hash" : 1 }, "name" : "hash_1" } ] }, "keyUpdates" : 0, "numYield" : 0, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(29055), "w" : NumberLong(7858235) }, "timeAcquiringMicros" : { "r" : NumberLong(2), "w" : NumberLong(33) } }, "responseLength" : 113, "millis" : 7896, "execStats" : {  }, "ts" : ISODate("2024-03-13T18:19:43.518Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
{ "op" : "command", "ns" : "sber_mongo.$cmd", "command" : { "count" : "Base", "query" : { "hash" : "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1 }, "fields" : {  } }, "keyUpdates" : 0, "numYield" : 4, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(8296015), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(40), "w" : NumberLong(7) } }, "responseLength" : 48, "millis" : 4284, "execStats" : {  }, "ts" : ISODate("2024-03-13T18:22:25.931Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }

```
Индекс неудчный, поэтому быстрее не стало (наоборот ощутимо медленнее, хотя у меня сейчас достаточно нагружен компьютер)

Построим другой индекс:
```shell
> db.Base.dropIndexes()
{
        "nIndexesWas" : 2,
        "msg" : "non-_id indexes dropped for collection",
        "ok" : 1
}
> db.Base.getIndexes()
[
        {
                "v" : 1,
                "key" : {
                        "_id" : 1
                },
                "name" : "_id_",
                "ns" : "sber_mongo.Base"
        }
]
> db.Base.createIndex({"hash": 1, "ver" : 1, "vin_sz" : 1})
{
        "createdCollectionAutomatically" : false,
        "numIndexesBefore" : 1,
        "numIndexesAfter" : 2,
        "ok" : 1
}
> db.Base.find({"hash": "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1}).count()
1966
...
{ "op" : "command", "ns" : "sber_mongo.$cmd", "command" : { "count" : "Base", "query" : { "hash" : "5d336b01245fbd8c0ae55d5b2889e318bcbc565df348f36801f178f935fd919c", "ver" : 1, "vin_sz" : 1 }, "fields" : {  } }, "keyUpdates" : 0, "numYield" : 0, "lockStats" : { "timeLockedMicros" : { "r" : NumberLong(1143), "w" : NumberLong(0) }, "timeAcquiringMicros" : { "r" : NumberLong(3), "w" : NumberLong(4) } }, "responseLength" : 48, "millis" : 1, "execStats" : {  }, "ts" : ISODate("2024-03-13T18:32:26.356Z"), "client" : "127.0.0.1", "allUsers" : [ ], "user" : "" }
```
Время 1ms запрос стал работать в ~1000 раз быстрее

Изменим данные:
```shell
> db.Base.update({"fee" : 3660}, {$set: {"fee": 0}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
>
```