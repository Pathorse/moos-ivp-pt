#!/bin/bash -e
#----------------------------------------------------------
#  Script: launch.sh
#  Author: Michael Benjamin
#  Edit: Paal Arthur S. Thorseth
#  LastEd: Nov 3th 2020
#----------------------------------------------------------
#  Part 1: Set Exit actions and declare global var defaults
#----------------------------------------------------------
trap "kill -- -$$" EXIT SIGTERM SIGHUP SIGINT SIGKILL
TIME_WARP=1
JUST_MAKE="no"
LAUNCH_GUI="yes"

#-------------------------------------------------------
#  Part 2: Check for and handle command-line arguments
#-------------------------------------------------------
for ARGI; do
    if [ "${ARGI}" = "--help" -o "${ARGI}" = "-h" ] ; then
	echo "launch.sh [SWITCHES] [time_warp]  "
	echo "  --just_make, -j    " 
	echo "  --help, -h         " 
        echo "  --no_gui, -n       " 
	exit 0;
    elif [ "${ARGI//[^0-9]/}" = "$ARGI" -a "$TIME_WARP" = 1 ]; then 
        TIME_WARP=$ARGI
    elif [ "${ARGI}" = "--just_make" -o "${ARGI}" = "-j" ] ; then
	JUST_MAKE="yes"
    elif [ "${ARGI}" = "--no_gui" -o "${ARGI}" = "-n" ] ; then
	LAUNCH_GUI="no"
    else 
	echo "launch.sh: Bad Arg:" $ARGI
	exit 0
    fi
done

#-------------------------------------------------------
#  Part 2: Create the .moos and .bhv files. 
#-------------------------------------------------------
VNAME1="os"           # The first vehicle Community
VNAME2="cn"           # The second vehicle Community
START_POS1="-50,-50"         
START_POS2="50,50"        
START_HEADING1="90"
START_HEADING2="180"
SPD1="1.2"
SPD2="1.2"
PTS1="{150,-50}"
PTS2="{50,-150}"
COLREGS_COMPLIANCE1="true"
COLREGS_COMPLIANCE2="true"
SHORE_LISTEN="9300"

nsplug meta_vehicle.moos targ_os.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME1          SHARE_LISTEN="9301"            \
    VPORT="9001"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS1  START_HEADING=$START_HEADING1

nsplug meta_vehicle.moos targ_cn.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME2          SHARE_LISTEN="9302"            \
    VPORT="9002"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS2  START_HEADING=$START_HEADING2

nsplug meta_shoreside.moos targ_shoreside.moos -f WARP=$TIME_WARP \
    SNAME="shoreside"  SHARE_LISTEN=$SHORE_LISTEN                 \
    SPORT="9000"       VNAME1=$VNAME1                             \
    VNAME2=$VNAME2     LAUNCH_GUI=$LAUNCH_GUI

nsplug meta_vehicle.bhv targ_os.bhv -f VNAME=$VNAME1               \
    START_POS=$START_POS1                       PTS=$PTS1          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE1     TRANSIT_SPD=$SPD1
  
nsplug meta_vehicle.bhv targ_cn.bhv -f VNAME=$VNAME2               \
    START_POS=$START_POS2                       PTS=$PTS2          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE2     TRANSIT_SPD=$SPD2
    

if [ ! -e targ_os.moos ]; then echo "no targ_os.moos"; exit; fi
if [ ! -e targ_os.bhv  ]; then echo "no targ_os.bhv "; exit; fi
if [ ! -e targ_cn.moos ]; then echo "no targ_cn.moos"; exit; fi
if [ ! -e targ_cn.bhv  ]; then echo "no targ_cn.bhv "; exit; fi
if [ ! -e targ_shoreside.moos ]; then echo "no targ_shoreside.moos";  exit; fi

if [ ${JUST_MAKE} = "yes" ] ; then
    exit 0
fi


#-------------------------------------------------------
#  Part 3: Launch the processes
#-------------------------------------------------------
echo "Launching $SNAME MOOS Community with WARP:" $TIME_WARP
pAntler targ_shoreside.moos >& /dev/null &
echo "Launching $VNAME1 MOOS Community with WARP:" $TIME_WARP
pAntler targ_os.moos >& /dev/null &
echo "Launching $VNAME2 MOOS Community with WARP:" $TIME_WARP
pAntler targ_cn.moos >& /dev/null &
echo "Done "

uMAC targ_shoreside.moos