#!/bin/csh
# recomendado usar em freebsd com zabbix instalado via ports
# comando para executar o scritp:
# fetch -o - https://raw.githubusercontent.com/shastybsd/freebsd_update_zabbix/master/upza.sh | csh

# Atualiza o ports
portsnap fetch update

# Destrava pkg
echo "Destravando pkg"
foreach p ( `pkg lock -l | grep zabbix` )
	pkg unlock -y $p
end

# Para servicos
/usr/local/etc/rc.d/zabbix_proxy stop
/usr/local/etc/rc.d/zabbix_agentd stop

# Remove zabbix
echo "Removendo zabbix antigos"
foreach p ( `pkg info | grep zabbix | cut -f1 -d" "` )
	pkg remove -y $p
end

cd /usr/ports/net-mgmt/zabbix34-proxy && make config-recursive && make -s install clean
if ( $? == 0 ) then
	echo "Sem falha na instalacao do proxy, continuando"
	pkg lock -y zabbix34-proxy
	rehash
else if ( $? > 0 ) then
	echo "Falhou ao instalar proxy, favor reparar"
	sleep 3
	exit 1
endif

echo "Instalou proxy"
sleep 10

cd /usr/ports/net-mgmt/zabbix34-agent && make config-recursive && make -s install clean
if ( $? == 0 ) then 
        echo "Sem falha na instalacao do agente, continuando"
	pkg lock -y zabbix34-agent
	rehash
else if ( $? > 0 ) then
        echo "Falhou ao instalar agente, favor reparar"
	sleep 3
        exit 1
endif

echo "Instalou agente"
sleep 10

if ( -d /usr/local/etc/zabbix3 ) cd /usr/local/etc/zabbix3 && mv * ../zabbix34

if ( -e /var/db/zabbix/proxy.db ) rm -vf /var/db/zabbix/proxy.db

sqlite3 /var/db/zabbix/proxy.db < /usr/local/share/zabbix34/proxy/database/sqlite3/schema.sql
chown zabbix:zabbix /var/db/zabbix/proxy.db

/usr/local/etc/rc.d/zabbix_agentd start
/usr/local/etc/rc.d/zabbix_proxy start
