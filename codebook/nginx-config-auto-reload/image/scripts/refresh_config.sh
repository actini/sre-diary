#! /bin/sh

function read_configmap() {
    CONFIGMAP=$1
    SERVICEACCOUNT="/var/run/secrets/kubernetes.io/serviceaccount"
    TOKEN="$(cat $SERVICEACCOUNT/token)"
    NAMESPACE="$(cat ${SERVICEACCOUNT}/namespace)"

    curl -s --cacert "${SERVICEACCOUNT}/ca.crt" \
         --header "Authorization: Bearer ${TOKEN}" \
         "https://kubernetes.default/api/v1/namespaces/${NAMESPACE}/configmaps/${CONFIGMAP}"
}

function list_config_files() {
    read_configmap $CONFIGMAP | jq -r '.data | keys[]'
}

function read_config_file() {
    read_configmap $CONFIGMAP | jq -r ".data.\"$1\""
}

function check_diff() {
    if [ ! -e $1 ]
    then
        echo "File $1 not found!"
        return 1
    elif [ ! -e $2 ]
    then
        echo "File $2 not found!"
        return 1
    else
        diff -wa $1 $2
        return $?
    fi
}

function refresh() {
    for FILE in $(list_config_files)
    do
        read_config_file $FILE > $TEMP_FOLDER/$FILE

        if [ -z "$(check_diff $TEMP_FOLDER/$FILE $CONFIG_FOLDER/$FILE)" ]
        then
            rm $TEMP_FOLDER/$FILE
            continue
        fi
    done

    for FILE in $(find $TEMP_FOLDER -type f -exec basename {} \;)
    do
        cp $TEMP_FOLDER/$FILE $CONFIG_FOLDER/$FILE
    done
}

function main() {
    while [ 1 ]
    do
        refresh
        sleep $INTERVAL
    done
}

main
