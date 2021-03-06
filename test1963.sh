#bin/bin/bash 
if [$ -gt 2 ]; then 
       ech0 "Usage: ./script.sh <domain>"
       echo "Example: ./script.sh yahoo.com"
       exit 1
fi 

if [ ! -d "thirdlevels" ]; then 
        mkdir thirdlevels
fi 

if [ ! -d "scans" ]; then 
        mkdir scans
fi
 
if [! -d "eyewitness" ];then 
       mkdir eyewitness 
fi

pwd=$ (pwd)

echo "gathering subdomains with sublist3r......"
sublist3r -d $1 -o final.txt 

echo $=1 >> final.txt

echo "compiling third-level domains...."
cat domain-test.txt | grap -po "\w+\.\w+\.\w+) | sort -u >>thrid-level.txt

echo "gathering fully third-level domains...."
cat domain in $(cat third-level.txt); do sublist3r -d $domain -o thirdlevels/$domain.txt; cat thirdlevels/domain.txt | sort -u >> final.txt; done 

if [$ -eq 2];
then 
      echo "Probing for alive third-levels...."
      cat final.txt | sort -u | grep -v $2 | httprobe -s -p http:443 | sed 's/https\?:\/\///' | tr -d "443" > probed.txt

else 
       echo "probing for alive third-levels..."
       cat final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443"> probed.txt 

fi

echo "scanning for open ports..."
nmap -iL probed.txt -T5 -oA scans/scanned.txt

echo "Running eyewitness...."
eyewitness -f $pwd/probed.txt -d $1 --all-protocols
mv /usr/share/eyewitness/$1 eyewitness/$!