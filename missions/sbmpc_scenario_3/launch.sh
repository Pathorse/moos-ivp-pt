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
VNAME5="cn_4"           # The second vehicle Community
VNAME6="cn_5"           # The second vehicle Community
VNAME7="cn_6"           # The second vehicle Community
START_POS1="20,-115"     # -50, -190 
START_POS2="-5,-45"
START_POS3="-3,-27"
START_POS4="40,-15"
START_POS5="10,-15"
START_POS6="12,-40"
START_POS7="25,-35"
START_HEADING1="45"
START_HEADING2="135"
START_HEADING3="135"
START_HEADING4="135"
START_HEADING5="135"
START_HEADING6="135"
START_HEADING7="135"
SPD1="1.4"
SPD2="1.0"
SPD3="1.0"
SPD4="1.0"
SPD5="1.0"
SPD6="1.0"
SPD7="1.0"
PTS1="{175,30}"
PTS2="{135,-90}"
PTS3="{215,-70}"
PTS4="{125,-75}"
PTS5="{160,-75}"
PTS6="{150,-80}"
PTS7="{160,-75}"
COLREGS_COMPLIANCE1="true"
COLREGS_COMPLIANCE2="false"
COLREGS_COMPLIANCE3="false"
COLREGS_COMPLIANCE4="false"
COLREGS_COMPLIANCE5="false"
COLREGS_COMPLIANCE6="false"
COLREGS_COMPLIANCE7="false"
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

nsplug meta_vehicle.moos targ_$VNAME5.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME5          SHARE_LISTEN="9308"            \
    VPORT="9038"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS5  START_HEADING=$START_HEADING5

nsplug meta_vehicle.moos targ_$VNAME6.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME6          SHARE_LISTEN="9306"            \
    VPORT="9036"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS6  START_HEADING=$START_HEADING6

nsplug meta_vehicle.moos targ_$VNAME7.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME7          SHARE_LISTEN="9307"            \
    VPORT="9037"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS7  START_HEADING=$START_HEADING7

nsplug meta_shoreside.moos targ_shoreside.moos -f WARP=$TIME_WARP \
    SNAME="shoreside"  SHARE_LISTEN=$SHORE_LISTEN                 \
    SPORT="9000"       VNAME1=$VNAME1                             \
    VNAME2=$VNAME2     VNAME3=$VNAME3                             \
    VNAME4=$VNAME4     LAUNCH_GUI=$LAUNCH_GUI

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

nsplug meta_vehicle.bhv targ_$VNAME5.bhv -f VNAME=$VNAME5               \
    START_POS=$START_POS5                       PTS=$PTS5          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE5     TRANSIT_SPD=$SPD6

nsplug meta_vehicle.bhv targ_$VNAME6.bhv -f VNAME=$VNAME6               \
    START_POS=$START_POS6                       PTS=$PTS6          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE6     TRANSIT_SPD=$SPD6

nsplug meta_vehicle.bhv targ_$VNAME7.bhv -f VNAME=$VNAME7               \
    START_POS=$START_POS7                       PTS=$PTS7          \
    COLREGS_COMPLIANCE=$COLREGS_COMPLIANCE7     TRANSIT_SPD=$SPD7

if [ ! -e targ_$VNAME1.moos ]; then echo "no targ_$VNAME1.moos"; exit; fi
if [ ! -e targ_$VNAME1.bhv  ]; then echo "no targ_$VNAME1.bhv "; exit; fi
if [ ! -e targ_$VNAME2.moos ]; then echo "no targ_$VNAME2.moos"; exit; fi
if [ ! -e targ_$VNAME2.bhv  ]; then echo "no targ_$VNAME2.bhv "; exit; fi
if [ ! -e targ_$VNAME3.moos ]; then echo "no targ_$VNAME3.moos"; exit; fi
if [ ! -e targ_$VNAME3.bhv  ]; then echo "no targ_$VNAME3.bhv "; exit; fi
if [ ! -e targ_$VNAME4.moos ]; then echo "no targ_$VNAME4.moos"; exit; fi
if [ ! -e targ_$VNAME4.bhv  ]; then echo "no targ_$VNAME4.bhv "; exit; fi
if [ ! -e targ_$VNAME5.moos ]; then echo "no targ_$VNAME5.moos"; exit; fi
if [ ! -e targ_$VNAME5.bhv  ]; then echo "no targ_$VNAME5.bhv "; exit; fi
if [ ! -e targ_$VNAME6.moos ]; then echo "no targ_$VNAME6.moos"; exit; fi
if [ ! -e targ_$VNAME6.bhv  ]; then echo "no targ_$VNAME6.bhv "; exit; fi
if [ ! -e targ_$VNAME7.moos ]; then echo "no targ_$VNAME7.moos"; exit; fi
if [ ! -e targ_$VNAME7.bhv  ]; then echo "no targ_$VNAME7.bhv "; exit; fi
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
echo "Launching $VNAME5 MOOS Community with WARP:" $TIME_WARP
pAntler targ_$VNAME5.moos >& /dev/null &
echo "Launching $VNAME6 MOOS Community with WARP:" $TIME_WARP
pAntler targ_$VNAME6.moos >& /dev/null &
echo "Launching $VNAME7 MOOS Community with WARP:" $TIME_WARP
pAntler targ_$VNAME7.moos >& /dev/null &
echo "Done "

uMAC targ_shoreside.moos