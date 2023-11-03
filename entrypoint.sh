#!/bin/sh

cleanup() {
    su actions-runner -c './config.sh remove --token ${token}'
}

trap 'cleanup' HUP
trap 'cleanup' INT
trap 'cleanup' QUIT
trap 'cleanup' ABRT
trap 'cleanup' KILL
trap 'cleanup' STOP
trap 'cleanup' TERM
trap 'cleanup' USR1
trap 'cleanup' USR2

chmod 666 /var/run/docker.sock

if [ ! -f .credentials ]; then 
    echo 'Configuring runner ...'
    su actions-runner -c './config.sh --unattended --replace --work /tmp/actions-runner -- --url ${url} --token ${token} --name ${name} --runnergroup ${group}'
fi

echo 'Starting runner ...'
su actions-runner -c './run.sh & wait $!'