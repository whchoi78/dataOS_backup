!/bin/bash
#What do you want back-up instance?
#servername
servername[0]="test-backup"
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
 #exe path
 e_path="/root/shell/ncloud_cli/cli_linux/"
 #instance_info path
 path="/root/shell/ncloud_cli/cli_linux/instance_info"

 #create json instance_info file
 $e_path./ncloud vserver getServerInstanceList > $path/total.json


 echo $(date +"%y%m%d%H%M%S") Start Back-up------------------------------------------------- >> $path/log.txt

for((i=0;i<$TotalInstanceNu;i++)) do
  #Get InstanceNo
  serverNo[i]=`cat $path/total.json | /bin/jq -r '.getServerInstanceListResponse.serverInstanceList[] | select(.serverName == "'${servername[i]}'") | .serverInstanceNo' `

      #Create Image
      $e_path/ncloud vserver createMemberServerImageInstance --serverInstanceNo ${serverNo[i]} --memberServerImageName ${servername[i]}-$(date +"%m")


      if [ $i -eq $logNu ];then
          #Get ImageInfo
          $e_path/ncloud vserver getMemberServerImageInstanceList > $path/image_info.json

          for((j=0;j<$TotalInstanceNu;j++)) do
              #log
          cat $path/image_info.json | /bin/jq -r '.getMemberServerImageInstanceListResponse.memberServerImageInstanceList[] | select(.originalServerInstanceNo == "'${serverNo[j]}'") | .memberServerImageName' >> $path/log.txt
          done
      fi

      sleep 0.01s

  done

  echo $(date +"%y%m%d%H%M%S") END Back-up --------------------------------------------------- >> $path/log.txt

  sleep 5s
#ima
