# freebsd_update_zabbix
Ajuda o processo de atualização do Zabbix via ports.

Atualiza zabbix_agent e zabbix_proxy instalado via ports no FreeBSD.

Não é para ser usado em  qualquer versão do FreeBSD e nem em qualquer versão do zabbix.

Atualizar o ports antes de executar (portsnap fetch update).

Necessita ter o portmaster instalado.

Comando para executar o script:

fetch -o - https://raw.githubusercontent.com/shastybsd/freebsd_update_zabbix/master/upza.sh | csh

Para atualizar a versão 3.4 para 4.0

fetch -o - https://raw.githubusercontent.com/shastybsd/freebsd_update_zabbix/master/upza3to4.sh | csh


Para atualizar a versão 4.0 para 5.0

fetch -o - https://raw.githubusercontent.com/shastybsd/freebsd_update_zabbix/master/upza4to5.sh | csh
