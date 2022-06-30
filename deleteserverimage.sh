#!/bin/bash

#What do you want back-up Delete instance?
#servername
servername[0]="itda-prd-document-was01"
#servername[1]="itda-prd-document-web01"
#servername[2]="ls-prd-learn-was21"
#servername[3]="ict-prd-batch01"
#servername[4]="ict-prd-aspen-web01"
#servername[5]="ict-prd-aspen-was01"
#servername[6]="ict-prd-aspen-db01"
#servername[7]="ict-prd-ontology-proxy01"
#servername[8]="ict-prd-ontology-ap01"
#servername[9]="ict-prd-ontology-db01"
#servername[10]="edu-lms01"
#servername[11]="edu-db01"
#servername[12]="edu-dev"


#Total number of servers
TotalInstanceNu=1
#for
logNu=`expr $TotalInstanceNu - 1`

#date
date +"%y-%m-%d"
date +%Y%m --date '1 months ago'
date_ago=$(date +%m --date '1 months ago')
#exe path
e_path="/root/shell/ncloud_cli/cli_linux/"
#instance_info path
path="/root/shell/ncloud_cli/cli_linux/instance_info"

#create json instance_info file
$e_path./ncloud vserver getServerInstanceList > $path/total.json

#Get ImageInfo
$e_path./ncloud vserver getMemberServerImageInstanceList > $path/image_info.json


echo $(date +"%y%m%d") Start Delete Back-up------------------------------------------ >> $path/log.txt

for((i=0;i<$TotalInstanceNu;i++)) do

    #Get InstanceNo
    imageNo[i]=`cat $path/image_info.json | jq -r '.getMemberServerImageListResponse.memberServerImageList[] | select(.memberServerImageName == "'${servername[i]}-$date_ago'") | .memberServerImageNo' `


#Delete Image
    $e_path./ncloud server deleteMemberServerImageInstances --memberServerImageNoList ${imageNo[i]}
    sleep 1s
        if [ $i -eq $logNu ];then

            #Get ImageInfo
            $e_path./ncloud vserver getMemberServerImageInstanceList > $path/image_info.json

            #log
            cat $path/image_info.json | jq -r '.getMemberServerImageListResponse.memberServerImageList[] | select(.memberServerImageStatusName == "terminating") | .memberServerImageName' >> $path/log.txt

        fi

    sleep 0.01s

done

echo ----------------------------------------------------------------------- >> $path/log.txt

sleep 5s