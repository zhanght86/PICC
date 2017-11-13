#!/usr/bin/env bash
#coding:utf-8

. ${EPICC_FUNCTION}

while true
do
    cat << EOF
########################################################################################################################
<1> 停止weblogic 服务
<2> 重启weblogic 服务
<0> 返回上一级菜单
########################################################################################################################
EOF
    
    read choice
    if [ "$choice" = 0 ]
        then break

    elif [ "$choice" = "1" ]
        then logging "没有写停止的脚本，手动杀吧！"
        sleep 3

    elif [ "$choice" = 2 ]
        then
        logging "您选择了重启weblogic 服务"
        n=1
        declare restart
        restart[0]="<0> 返回上一级菜单"
        #遍历restart—shell目录下的重启脚本
        #for i in `find /home/weblogic/yunwei/restart_shell -name *restart.sh`;do restart[$n]=$i;n=`expr $n + 1`;done
        for i in `find ${RESTART_DIR} -name *restart.sh`;do restart[$n]=$i; n=`expr $n + 1`;done
        echo "########################################################################################################################"
        for i in ${!restart[@]};do if [ $i = 0 ];then echo -e ${restart[$i]};else echo -e "<$i>" `basename ${restart[$i]}`;fi;done
        echo "########################################################################################################################"
        read choice
        if [ "$choice" = "0" ]
            then continue

        elif [[ ${!restart[@]} =~ $choice ]]
            then logging "您选择了重启${restart[$choice]}"
            sh ${restart[$choice]}
        else
            logging "为啥不按提示的输呢？"
        fi
    else
        continue
    fi
done

