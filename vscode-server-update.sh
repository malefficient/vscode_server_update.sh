#!/bin/bash
# usage: ./update-vs-server GITVER 
# Descr: Minimal bash script to bootstrap a specific version of vscode server via wget on linux host
#        Extra wget arguments can be specified in the variable below       

# WGET_OPT_ARGS=" --no-check-certificate"  #Warning! Do not do this


## Argument parsing
GITVER=$1
BRANCH="stable"
D_DIR="$HOME/.vscode-server"
if [ ${#GITVER} -ne 40 ]; then
	echo "invalid SHA1SUM: $GITVER"
	echo "usage: $0 GITVER"
	exit -1
fi

echo "Downloading git revsion:  $GITVER"
##### main 
#remove previously downloaded results 
t_path="/tmp/vscode-server-linux-x64-$GITVER.tar.gz"
cmd="rm -f $t_path"
$cmd

##Initially check stable branch:

wget_cmd="wget $WGET_OPT_ARGS  -O $t_path https://update.code.visualstudio.com/commit:$GITVER/server-linux-x64/$BRANCH"
echo $wget_cmd
$wget_cmd

if [[ ! -s $t_path ]]; then
	echo "Download failure. Trying insider branch.."
	BRANCH="insider"
	D_DIR=$D_DIR-insiders
fi

wget_cmd="wget $WGET_OPT_ARGS -nv -O $t_path https://update.code.visualstudio.com/commit:$GITVER/server-linux-x64/$BRANCH"
echo $wget_cmd
$wget_cmd

if [[ ! -s $t_path ]]; then
	echo "Fatal error. Could not find $GITREV in insider or stable branches"
	exit -1
fi
## If we make it this far, download was successfull
D_DIR=$D_DIR/bin/$GITVER
echo "Destination: $D_DIR"
cmd="mkdir -p $D_DIR"
$cmd 
if [ $? -ne 0 ]; then
	echo "Error creating $D_DIR"
fi
echo 

echo "Extracting to: $D_DIR"
cmd="tar -zxf $t_path --strip 1 -C $D_DIR"
echo $cmd
$cmd
if [ $? -ne 0 ]; then
	echo "Error extracting to: $D_DIR"
	exit -1
fi
echo "Successfully installed: $D_DIR"
exit 0
### 
