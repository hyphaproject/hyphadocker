#!/bin/bash
if [ ! -e "/setup-done" ];
then
  touch "/setup-done"
  touch "/etc/kadnode/keys.txt"
  kadnode --auth-gen-keys >> /etc/kadnode/keys.txt
  sed -i 's/public key: /publickey=/g' /etc/kadnode/keys.txt
  sed -i 's/secret key: /privatekey=/g' /etc/kadnode/keys.txt
  ls /etc/kadnode
  . "/etc/kadnode/keys.txt"
  echo "--auth-add-skey $(hostname).hypha:$privatekey" >> /etc/kadnode/kadnode.conf
  echo "--value-id $(hostname).hypha" >> /etc/kadnode/kadnode.conf
  echo "--query-tld .hypha" >> /etc/kadnode/kadnode.conf
  echo "--verbosity quiet"  
else
  . "/etc/kadnode/keys.txt"
fi

echo "public key: $publickey \n" && kadnode --config /etc/kadnode/kadnode.conf & hyphawebmanager -p80 -f/etc/hypha/hypha.conf -r/usr/local/share/hyphawebmanager/resources --handlersdir=/usr/local/lib/hyphahandlers/ --pluginsdir=/usr/local/lib/hyphaplugins/ 
