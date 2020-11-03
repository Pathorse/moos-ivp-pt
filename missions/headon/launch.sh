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
VNAME1="ownship"           # The first vehicle Community
VNAME2="contact"           # The second vehicle Community
START_POS1="0,-70"         
START_POS2="200,-70"        
START_HEADING1="90"
START_HEADING2="270"
PTS1="{0,-70:200,-70}"
PTS2="{200,-70:0,-70}"
SHORE_LISTEN="9300"

nsplug meta_vehicle.moos targ_ownship.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME1          SHARE_LISTEN="9301"            \
    VPORT="9001"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS1  START_HEADING=$START_HEADING1

nsplug meta_vehicle.moos targ_contact.moos -f WARP=$TIME_WARP \
    VNAME=$VNAME2          SHARE_LISTEN="9302"            \
    VPORT="9002"           SHORE_LISTEN=$SHORE_LISTEN     \
    START_POS=$START_POS2  START_HEADING=$START_HEADING2

nsplug meta_shoreside.moos targ_shoreside.moos -f WARP=$TIME_WARP \
    SNAME="shoreside"  SHARE_LISTEN=$SHORE_LISTEN                 \
    SPORT="9000"       VNAME1=$VNAME1                             \
    VNAME2=$VNAME2     LAUNCH_GUI=$LAUNCH_GUI

nsplug meta_vehicle.bhv targ_ownship.bhv -f VNAME=$VNAME1     \
    START_POS=$START_POS1     PTS=$PTS1
  
nsplug meta_vehicle.bhv targ_contact.bhv -f VNAME=$VNAME2     \
    START_POS=$START_POS2     PTS=$PTS2
    

if [ ! -e targ_ownship.moos ]; then echo "no targ_ownship.moos"; exit; fi
if [ ! -e targ_ownship.bhv  ]; then echo "no targ_ownship.bhv "; exit; fi
if [ ! -e targ_contact.moos ]; then echo "no targ_contact.moos"; exit; fi
if [ ! -e targ_contact.bhv  ]; then echo "no targ_contact.bhv "; exit; fi
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
pAntler targ_ownship.moos >& /dev/null &
echo "Launching $VNAME2 MOOS Community with WARP:" $TIME_WARP
pAntler targ_contact.moos >& /dev/null &
echo "Done "

uMAC targ_shoreside.moos
