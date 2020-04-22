#!/bin/bash
#This Script is for setting up Local Repository with online sync
#Script Name            : centos7_reposync.sh
#Dated                  : September 2018
#Author                 : M.S. Arun
#Email                  : msarun003@gmail.com
#Usage                  : ./centos7_reposync.sh
#Last Update            : December 2018


#****************************************************************** Start of Script ********************************************************************#


export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin

web_url="mirror.centos.org"
base_dir="/var/www/html/yum7"


connectivity_status() {
pid="$(echo $$)"
wget --tries=2 --spider --timeout=5 --no-check-certificate http://$web_url -o $base_dir/connectivity_status_$pid.log
grep -q 'Connecting.*connected' $base_dir/connectivity_status_$pid.log
if [ "$?" != 0 ]; then
echo -e "Unable to Connect / Failed to Download: $web_url"
/bin/rm -rf $base_dir/connectivity_status_$pid.log
exit
fi
/bin/rm -rf $base_dir/connectivity_status_$pid.log
}
connectivity_status


mkdir -p $base_dir/centos7 $base_dir/centos7/centos-7-server-rpms $base_dir/centos7/centos-7-server-optional-rpms $base_dir/centos7/centos-7-server-extras-rpms


/bin/rm -rf $base_dir/centos7/centos-7-server-rpms/repodata > /dev/null 2>&1
/bin/rm -rf $base_dir/centos7/centos-7-server-rpms/$web_url/centos/7/os/x86_64/repodata > /dev/null 2>&1
/bin/rm -rf $base_dir/centos7/centos-7-server-optional-rpms/repodata > /dev/null 2>&1
/bin/rm -rf $base_dir/centos7/centos-7-server-extras-rpms/repodata > /dev/null 2>&1


directory_touch() {
status_code="$1"
dir_path="$2"
if [ "$status_code" == 0 ]; then
touch "$dir_path" > /dev/null 2>&1
fi
}


#CentOS 7 Repos - centos-7-server-rpms
wget --mirror --no-parent --reject "*index.html*" --accept "*.rpm" -P $base_dir/centos7/centos-7-server-rpms http://$web_url/centos/7/os/x86_64/Packages/
wget --mirror --no-parent --reject "*index.html*" --accept "*.xml" -P $base_dir/centos7/centos-7-server-rpms http://$web_url/centos/7/os/x86_64/repodata/
ln -sfn $base_dir/centos7/centos-7-server-rpms/$web_url/centos/7/os/x86_64/Packages $base_dir/centos7/centos-7-server-rpms/Packages > /dev/null 2>&1
createrepo -g $base_dir/centos7/centos-7-server-rpms/$web_url/centos/7/os/x86_64/repodata/*comps.xml $base_dir/centos7/centos-7-server-rpms
directory_touch "$?" "$base_dir/centos7/centos-7-server-rpms"


#CentOS 7 Repos - centos-7-server-optional-rpms
wget --mirror --no-parent --reject "*index.html*" --accept "*.rpm" -P $base_dir/centos7/centos-7-server-optional-rpms http://$web_url/centos/7/updates/x86_64/Packages/
ln -sfn $base_dir/centos7/centos-7-server-optional-rpms/$web_url/centos/7/updates/x86_64/Packages $base_dir/centos7/centos-7-server-optional-rpms/Packages > /dev/null 2>&1
createrepo $base_dir/centos7/centos-7-server-optional-rpms
directory_touch "$?" "$base_dir/centos7/centos-7-server-optional-rpms"


#CentOS 7 Repos - centos-7-server-extras-rpms
wget --mirror --no-parent --reject "*index.html*" --accept "*.rpm" -P $base_dir/centos7/centos-7-server-extras-rpms http://$web_url/centos/7/extras/x86_64/Packages/
ln -sfn $base_dir/centos7/centos-7-server-extras-rpms/$web_url/centos/7/extras/x86_64/Packages $base_dir/centos7/centos-7-server-extras-rpms/Packages > /dev/null 2>&1
createrepo $base_dir/centos7/centos-7-server-extras-rpms
directory_touch "$?" "$base_dir/centos7/centos-7-server-extras-rpms"


touch "$base_dir/centos7" > /dev/null 2>&1


#****************************************************************** End of the Script ******************************************************************#
