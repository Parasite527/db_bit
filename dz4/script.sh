#! /usr/bin/zsh

curl -X PUT 'http://localhost:6333/collections/test_collection/points?wait=true' -H 'Content-Type: application/json' -d \
"$(echo "$(echo "{ \"points\": [ $(for id in {0..500}; do 
        echo \{
        echo \"id\": $id,
        echo \"vector\": \[0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc), 0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc), 0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc), 0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc)\],
        echo \"payload\": \{\"city\": \"$(( $id % 5 ))\"\}
        echo \},
    done
        echo \{
        echo \"id\": 500,
        echo \"vector\": \[0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc), 0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc), 0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc), 0$(echo "scale=2 ; $(od -An -N2 -i /dev/urandom) / 65536" | bc)\],
        echo \"payload\": \{\"city\": \"$(( $id % 5 ))\"\};
        echo \}
    )
]
}")" | jq)"