# Start up

установим редис
```shell 
sudo apt install redis
```
установим модуль json 
```shell
git clone --recursive https://github.com/RedisJSON/RedisJSON.git
mv RedisJSON Mipt/sber/db_bit
cd RedisJSON
./sbin/setup
make build
./deps/readies/bin/getredis
```

запуск сервера
```shell
redis-server --loadmodule ./bin/linux-x64-release/target/release/librejson.so
```

запуск клиента
```shell
redis-cli
```
# playing

попробуем повставлять данные
```shell
127.0.0.1:6379> keys *
1) "large"
2) "m"
3) "mykey"
4) "k"
127.0.0.1:6379> get large
(error) WRONGTYPE Operation against a key holding the wrong kind of value
127.0.0.1:6379> get k
"{\"name\":\"John Doe\",\"age\":30,\"email\":\"john@example.com\"}"
127.0.0.1:6379> get mykey
(error) WRONGTYPE Operation against a key holding the wrong kind of value
127.0.0.1:6379> json.get mykey
"{\"name\":\"John Doe\",\"age\":30,\"email\":\"john@example.com\"}"
127.0.0.1:6379> get m
(error) WRONGTYPE Operation against a key holding the wrong kind of value
127.0.0.1:6379> json.get m
"{}"
127.0.0.1:6379> SET users:1:name "Sasha"
OK
127.0.0.1:6379> SET users:1:age 21
OK
127.0.0.1:6379> GET users:1:name
"Sasha"
127.0.0.1:6379> SET db:visits 0
OK
127.0.0.1:6379> INCR db:visits
(integer) 1
127.0.0.1:6379> INCR db:visits
(integer) 2
127.0.0.1:6379> del db:visits
(integer) 1
127.0.0.1:6379> del users:1
(integer) 0
127.0.0.1:6379> keys *
1) "large"
2) "users:1:age"
3) "mykey"
4) "k"
5) "m"
6) "users:1:name"
127.0.0.1:6379> del users:1:age k mmykey
(integer) 2
127.0.0.1:6379> keys *
1) "large"
2) "mykey"
3) "m"
4) "users:1:name"
127.0.0.1:6379> del users:1:name m mykey
(integer) 3
127.0.0.1:6379> ls
(error) ERR unknown command 'ls', with args beginning with: 
127.0.0.1:6379> keys *
1) "large"
127.0.0.1:6379>
```

# benchmark

создадим массив(лист)
```shell
127.0.0.1:6379> LPUSH 1 2
(integer) 1
127.0.0.1:6379> LPUSH 1 3
(integer) 2
127.0.0.1:6379> LRANGE 1 0 -1
1) "3"
2) "2"
```

посмотрим время запроса к длинному массиву
```shell
time (for i in {0..10000}; do echo lpush test_list $i | redis-cli; done > /dev/null) 

real    96.38s
user    46.97s
sys     43.07s
cpu     93%


14213:M 02 Apr 2024 06:07:11.770 * Background saving terminated with success
14213:M 02 Apr 2024 06:10:41.858 * 10000 changes in 60 seconds. Saving...
14213:M 02 Apr 2024 06:10:41.860 * Background saving started by pid 64240
64240:C 02 Apr 2024 06:10:42.099 * DB saved on disk
```

замеры
```shell
time redis-cli LINDEX test_list 50
"9950"

real    0.01s
user    0.00s
sys     0.01s
cpu     73%
                                                                                            
time redis-cli LINDEX test_list 9000
"1000"

real    0.05s
user    0.02s
sys     0.01s
cpu     56%

time (for i in {0..100}; do redis-cli LINDEX test_list 9000 > /dev/null; done)

real    0.62s
user    0.25s
sys     0.36s
cpu     98%

time (for i in {0..1000}; do redis-cli LINDEX test_list 9000 > /dev/null; done)

real    6.20s
user    2.89s
sys     3.23s
cpu     98%
```

теперь словарь
```shell
127.0.0.1:6379> hset test_dist 1 1
(integer) 1
127.0.0.1:6379> HGETALL test_dist
1) "1" # key
2) "1" # value
```

посмотрим время запроса к длинному массиву
```shell
time (for i in {0..10000}; do echo hset test_dict $i $i | redis-cli; done > /dev/null)

real    96.47s
user    47.85s
sys     42.21s
cpu     93%
```
заметим, что время вставки почти идентично времени вставки в массив

теперь поиск
```shell
time (for i in {0..100}; do redis-cli hget test_dict $i > /dev/null; done)    

real    0.63s
user    0.22s
sys     0.40s
cpu     98%

time (for i in {0..1000}; do redis-cli hget test_dict $i > /dev/null; done)    

real    6.16s
user    2.71s
sys     3.37s
cpu     98%
```

что интересно взятие из хеш-таблицы стабильно чуть быстрее взятие элемента из листа

измерим хеш-сет
```shell
127.0.0.1:6379> sadd test_set 1
(integer) 1
127.0.0.1:6379> smembers test_set
1) "1"
```

замеры
```shell
time (for i in {0..10000}; do echo sadd test_set $i | redis-cli; done > /dev/null) 

real    98.08s
user    48.86s
sys     42.62s
cpu     93%
```

поиск
```shell
time (for i in {0..1000}; do echo sismember test_set $i | redis-cli; done > /dev/null) 

real    9.66s
user    4.74s
sys     4.30s
cpu     93%
             
time (for i in {0..1000}; do echo sismember test_set $(($i-100)) | redis-cli; done > /dev/null)   

real    10.12s
user    4.79s
sys     4.54s
cpu     92%


time (for i in {0..10000}; do echo sismember test_set $(($i-100)) | redis-cli; done > /dev/null)  

real    97.44s
user    48.64s
sys     42.91s
cpu     93%
                                                                                            
time (for i in {0..10000}; do echo sismember test_set $i | redis-cli; done > /dev/null)

real    98.86s
user    49.53s
sys     42.68s
cpu     93%
                                                                                            
time (for i in {0..10000}; do echo sismember test_set $i | redis-cli; done > /dev/null)

real    96.67s
user    47.91s
sys     42.49s
cpu     93%
```

время поиска не зависит от того присутствует ли элемент в множестве, однако колеблется в пределах (~2%)

измерим сет
```shell
127.0.0.1:6379> zadd test_zset 1 "one"
(integer) 1
127.0.0.1:6379> zadd test_zset 3 "three"
(integer) 1
127.0.0.1:6379> zadd 2 "two"
(error) ERR wrong number of arguments for 'zadd' command
127.0.0.1:6379> zadd test_zset 2 "two"
(integer) 1
127.0.0.1:6379> zrange test_zset 0 -1
1) "one"
2) "two"
3) "three"
```

большой сет
```shell
time (for i in {0..10000}; do echo zadd test_zset $i $i | redis-cli; done > /dev/null)

real    96.17s
user    47.49s
sys     42.40s
cpu     93%
```

запросы
```shell
time (for i in {0..10000}; do echo zrank $i | redis-cli; done > /dev/null) 

real    96.57s
user    48.38s
sys     42.00s
cpu     93%

time (for i in {0..10000}; do echo zrank 100000 | redis-cli; done > /dev/null) 

real    96.66s
user    48.46s
sys     41.85s
cpu     93%
```
запрос должен выполняться за лог от размера дерева, однако на таком малом объеме это незаметно,
но ждать пока нальется база несколько дней не хочется

сгенерируем большой json файл
```python
import json

d = []
for i in range(100000):
    d.append({"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "ab": 15, "cd": 25, "ef": 100, "gh": 4058, "jj": 8000})
    d.append({1: "a", 2: "b", 3: "c", 4: "d", 5: "e", 15: "ab", 25: "cd", 100: "ef", 4058: "gh", 8000: "jj"})

with open("test.json", "w") as f:
    f.write(json.dumps(d))
```

вставим большой json в базу
```shell
echo json.set large . $(cat test.json | jq -c | jq -R) | redis-cli                
OK
```

измерим некоторые запросы
```
127.0.0.1:6379> json.arrlen large
(integer) 200000
127.0.0.1:6379> json.arrindex large . {}
(integer) -1
127.0.0.1:6379> json.arrindex large . 100
(integer) -1
127.0.0.1:6379> json.arrindex large . "{\"a\": 1, \"b\": 2, \"c\": 3, \"d\": 4, \"e\": 5, \"ab\": 15, \"cd\": 25, \"ef\": 100, \"gh\": 4058, \"jj\": 8000}"
(integer) 0
```

измерим время
```shell
time (for i in {0..1000}; do echo json.arrindex large . 100 | redis-cli; done > /dev/null)

real    12.13s
user    4.69s
sys     4.27s
cpu     73%


time (for i in {0..1000}; do echo json.arrindex large . \"{\\\"a\\\": 1, \\\"b\\\": 2, \\\"c\\\": 3, \\\"d\\\": 4, \\\"e\\\": 5, \\\"ab\\\": 15, \\\"cd\\\": 25, \\\"ef\\\": 100, \\\"gh\\\": 4058, \\\"jj\\\": 8000}\" | redis-cli; done > /dev/null)

real    9.63s
user    4.75s
sys     4.22s
cpu     93%
```

# создадим кластер

```shell
mkdir cluster-test
cd cluster-test
mkdir 7000 7001 7002 7003 7004 7005

# redis.conf
port 7000 # num of dir 
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
```

sturtup
```shell
┌──(ltlo㉿ltlo)-[~/cluster-test/7003]
└─$ redis-server ./redis.conf

┌──(ltlo㉿ltlo)-[~/cluster-test/7005]
└─$ redis-server ./redis.conf

┌──(ltlo㉿ltlo)-[~/cluster-test/7004]
└─$ redis-server ./redis.conf

...

redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 \
--cluster-replicas 3
...

[OK] All nodes agree about slots configuration.
>>> Check for open slots...                                                                 
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

```shell
redis-cli -c -p 7000
redis 127.0.0.1:7000> set foo bar
-> Redirected to slot [12182] located at 127.0.0.1:7002
OK
redis 127.0.0.1:7002> set hello world
-> Redirected to slot [866] located at 127.0.0.1:7000
OK
redis 127.0.0.1:7000> get foo
-> Redirected to slot [12182] located at 127.0.0.1:7002
"bar"
redis 127.0.0.1:7002> get hello
-> Redirected to slot [866] located at 127.0.0.1:7000
"world"
```