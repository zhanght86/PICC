DT=`date +%Y%m%d%H%M%S`
USER_IP=`who am i|awk '{print $NF}'|sed "s/[()]//g"`
HISTNAME=${USER_IP}_$DT.history
HISTDIR=/tmp/History/$LOGNAME

if [ ! -d /tmp/History ]
then
		mkdir -p /tmp/History
		chmod 777 /tmp/History
fi
if [ ! -d $HISTDIR ]
then
		mkdir -p $HISTDIR
		chmod 300 $HISTDIR
fi

export HISTSIZE=4096
export HISTFILE=$HISTDIR/$HISTNAME
