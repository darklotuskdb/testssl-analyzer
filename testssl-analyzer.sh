#!/bin/bash

ifile="$1"

banner(){
printf "
 _____         _   ____ ____  _
|_   _|__  ___| |_/ ___/ ___|| |
  | |/ _ \/ __| __\___ \___ \| |
  | |  __/\__ \ |_ ___) |__) | |___
  |_|\___||___/\__|____/____/|_____|
    _                _
   / \   _ __   __ _| |_   _ _______ _ __
  / _ \ | '_ \ / _' | | | | |_  / _ \ '__|
 / ___ \| | | | (_| | | |_| |/ /  __/ |
/_/   \_\_| |_|\__,_|_|\__, /___\___|_|
                       |___/
"
echo -e "\e[31m\tBy @DarkLotusKDB <3\e[0m"
echo
}

Cert(){
a=$(cat ${ifile} | grep -i 'Certificate Validity')
b=$(echo "$a" | cut -d ' ' -f 7)

	if echo "${a}" | grep -i 'expired' &> /dev/null
	then echo -e "\e[93m[+] X.509 Certificate Expired (SSL/TLS) \n\t\e[0m ${a}";
	elif echo "${a}" | grep -i 'expires' &> /dev/null
	then echo -e "\e[93m[+] X.509 Certificate About to Expire (SSL/TLS) \n\t\e[0m ${a}";
	elif echo "$b" | grep [0-9] &> /dev/null
	then echo -e "$b" "${a}" | xargs -l bash -c 'if [ $0 -le 90 ] ; then echo -e "\e[93m[+] X.509 Certificate About to Expire (SSL/TLS) \n\t\e[0m $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12}"; else echo -e "\e[93m[+] Certificate Validity (OK) \n\t\e[0m $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12}"; fi'
	else
	echo -e "\e[32m[/] Something Went Wrong While Checking Certificate Validity..\e[0m"
fi
}

Wcip(){
echo -e "\e[93m[+] Searching For Weak Ciphers\e[0m"

cat ${ifile} | grep '_CBC_' | grep -w 'AES'

Cip="TLS_RSA_WITH_3DES_EDE_CBC_SHA TLS_RSA_WITH_RC4_128_MD5 TLS_RSA_WITH_RC4_128_SHA TLS_DH_Anon_WITH_SEED_CBC_SHA TLS_DH_Anon_WITH_AES_128_GCM_SHA256 TLS_ECDH_Anon_WITH_AES_128_CBC_SHA TLS_ECDH_Anon_WITH_AES_256_CBC_SHA"
for Per in $Cip;
        do
          cat ${ifile} | grep "${Per}"
        done
}

Vchk(){
echo -e "\e[93m[+] Checking For SSL/TLS Version Used\e[0m"

Vrn="SSLv2 SSLv3 TLSv1 TLSv1.1 TLSv1.2 TLSv1.3"

for i in $Vrn
  do
        if ! cat ${ifile} | grep -w ${i} -A1 | grep -v '\--' | grep -w '-' &> /dev/null
          then echo -e "\t ${i}"
        fi
done
}

Vsof(){
echo -e "\e[93m[+] Checking For Vulnerabilities\e[0m"
V=$(cat ${ifile} | grep 'Testing vulnerabilities' -A30 | grep 'VULNERABLE' | cut -d ' ' -f 2)
for i in $V
	do echo -e "\t ${i}"
done
}

banner
Wcip
Vsof
Vchk
Cert
