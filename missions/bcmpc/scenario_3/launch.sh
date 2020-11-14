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
VNAME2="cn_1"           # The second vehicle Community
VNAME3="cn_2"           # The second vehicle Community
VNAME4="cn_3"           # The second vehicle Community
START_POS1="0,-145"
START_POS2="50,50"        
START_POS3="150,-50"        
START_POS4="50,-150"        
START_HEADING1="90"
START_HEADING2="180"
START_HEADING3="270"
START_HEADING4="0"
SPD1="1.2"
SPD2="1.2"
SPD3="1.2"
SPD4="1.2"
PTS1="{150,-50}"
PTS2="{50,-150}"
PTS3="{-50,-50}"
PTS4="{50,50}"
COLREGS_COMPLIANCE1="true"
COLREGS_COMPLIANCE2="true"
COLREGS_COMPLIANCE3="true"
COLREGS_COMPLIANCE4="true"
SHORE_LISTEN="9300"

nsplug meta_vehicle.moos targ_$VNAME1.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME1          SHARE_LISTEN="9301"            \
    VPORT="9001"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS1  START_HEADING=$START_HEADING1

nsplug meta_vehicle.moos targ_$VNAME2.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME2          SHARE_LISTEN="9302"            \
    VPORT="9002"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS2  START_HEADING=$START_HEADING2

nsplug meta_vehicle.moos targ_$VNAME3.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME3          SHARE_LISTEN="9303"            \
    VPORT="9003"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS3  START_HEADING=$START_HEADING3

nsplug meta_vehicle.moos targ_$VNAME4.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME4          SHARE_LISTEN="9304"            \
    VPORT="9004"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS4  START_HEADING=$START_HEADING4

nsplug meta_shoreside.moos targ_shoreside.moos -f WARP=$TIME_WARP \
    SNAME="shoreside"  SHARE_LISTEN=$SHORE_LISTEN                 \
    SPORT="9000"       VNAME1=$VNAME1                             \
    VNAME2=$VNAME2     VNAME3=$VNAME3                             \
    VNAME2=$VNAME4     LAUNCH_GUI=$LAUNCH_GUI

nsplug meta_vehicle.bhv targ_$VNAME1.bhv -f VNAME=$VNAME1               \
    START_POS=$START_POS1                       PTS=$PTS1          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE1     TRANSIT_SPD=$SPD1
  
nsplug meta_vehicle.bhv targ_$VNAME2.bhv -f VNAME=$VNAME2               \
    START_POS=$START_POS2                       PTS=$PTS2          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE2     TRANSIT_SPD=$SPD2
    
nsplug meta_vehicle.bhv targ_$VNAME3.bhv -f VNAME=$VNAME3               \
    START_POS=$START_POS3                       PTS=$PTS3          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE3     TRANSIT_SPD=$SPD3

nsplug meta_vehicle.bhv targ_$VNAME4.bhv -f VNAME=$VNAME4               \
    START_POS=$START_POS4                       PTS=$PTS4          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE4     TRANSIT_SPD=$SPD4

if [ ! -e targ_$VNAME1.moos ]; then echo "no targ_$VNAME1.moos"; exit; fi
if [ ! -e targ_$VNAME1.bhv  ]; then echo "no targ_$VNAME1.bhv "; exit; fi
if [ ! -e targ_$VNAME2.moos ]; then echo "no targ_$VNAME2.moos"; exit; fi
if [ ! -e targ_$VNAME2.bhv  ]; then echo "no targ_$VNAME2.bhv "; exit; fi
if [ ! -e targ_$VNAME3.moos ]; then echo "no targ_$VNAME3.moos"; exit; fi
if [ ! -e targ_$VNAME3.bhv  ]; then echo "no targ_$VNAME3.bhv "; exit; fi
if [ ! -e targ_$VNAME4.moos ]; then echo "no targ_$VNAME4.moos"; exit; fi
if [ ! -e targ_$VNAME4.bhv  ]; then echo "no targ_$VNAME4.bhv "; exit; fi
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
pAntler targ_$VNAME1.moos >& /dev/null &
echo "Launching $VNAME2 MOOS Community with WARP:" $TIME_WARP
pAntler targ_$VNAME2.moos >& /dev/null &
echo "Launching $VNAME3 MOOS Community with WARP:" $TIME_WARP
pAntler targ_$VNAME3.moos >& /dev/null &
echo "Launching $VNAME4 MOOS Community with WARP:" $TIME_WARP
pAntler targ_$VNAME4.moos >& /dev/null &
echo "Done "

uMAC targ_shoreside.moos