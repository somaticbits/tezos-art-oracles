#!/bin/sh

echo "[*] Compiling contracts and storage."

rm ./contracts/*.tz	

if ligo compile contract ./contracts/main.mligo -e main -o ./contracts/main.tz 
then
	if ligo compile storage ./contracts/main.mligo `cat ./contracts/init_main_storage.mligo` -e main -o ./contracts/main_storage.tz;
	then 
		echo "[*] Compilation successful."
	else
		echo "[*] Compilation failure."
	fi	
fi
