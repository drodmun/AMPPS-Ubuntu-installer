#!/usr/bin/sudo bash
# --------------------------------------
# @name: AMPPS Ubuntu installer
# @Description: AMPPS Ubuntu installer script, downloads required packages, creates icon and leaves ready to use.
# @author: drodmun@gmail.com
# @version: 0.0.1
# --------------------------------------

clear

echo ""
echo ""

echo "        _     __  __   ___   ___  ____      _   _   ___   _   _   _  _   _____   _   _     _               _            _   _             "
echo "       /_\   |  \/  | | _ \ | _ \ ||       | | | | | _ ) | | | | | \| | |_   _| | | | |   (_)  _ _    ___ | |_   __ _  | | | |  ___   _ _ "
echo "      / _ \  | |\/| | |  _/ |  _/ \`==      | |_| | | _ \ | |_| | | .\ |   | |   | |_| |   | | | ' \  (_-< |  _| / _\ | | | | | / -_) | '_|"
echo "     /_/ \_\ |_|  |_| |_|   |_|   ___|      \___/  |___/  \___/  |_|\_|   |_|    \___/    |_| |_||_| /__/  \__| \__,_| |_| |_| \___| |_|  "

echo ""
echo ""

DEBUG=false
if [[ $* == --debug ]]; then
	DEBUG=true
	echo "------------------------------------------------------------------------------------------------------------------------------------------ "
	echo "---------------------------------------------------- RUNNNING SCRIPT IN DEBUG MODE!! ----------------------------------------------------- "
fi

# -------------------------------------------------------------
# Fixing UI in QT
# -------------------------------------------------------------
fixUIInQT () {
	ROUTE=/etc/environment
	if [ $DEBUG = true ]; then
		ROUTE=/tmp/environment
		touch $ROUTE
	fi
    	#echo $ROUTE
	
	sudo bash -c "echo '' >> $ROUTE"
	sudo bash -c "echo 'export QT_X11_NO_MITSHM=1' >> $ROUTE"
}

# -------------------------------------------------------------
# GNOME Launcher
# -------------------------------------------------------------
createGNOMELauncher () {
	ROUTE=/usr/share/applications/
	if [ $DEBUG = true ]; then
		ROUTE=/tmp
    	fi
    	#echo $ROUTE
    
	cd $ROUTE
	sudo rm ampps.desktop && sudo touch ampps.desktop
	sudo bash -c 'echo "[Desktop Entry]" >> ampps.desktop'
	sudo bash -c 'echo "Name=Ampps" >> ampps.desktop'
	sudo bash -c 'echo "Comment=\"Apache MySQL MongoDB PostgreSQL Perl Php Softaculous Stack\"" >> ampps.desktop'
	sudo bash -c 'echo "GenericName=\"Web Tools Stack\"" >> ampps.desktop'
	sudo bash -c 'echo "Exec=pkexec /usr/local/ampps/Ampps" >> ampps.desktop'
	sudo bash -c 'echo "Icon=/usr/local/ampps/ampps_large.png" >> ampps.desktop'
	sudo bash -c 'echo "Type=Application" >> ampps.desktop'
	sudo bash -c 'echo "Terminal=false" >> ampps.desktop'
	sudo bash -c 'echo "StartupNotify=true" >> ampps.desktop'
	sudo bash -c 'echo "StartupWMClass=\"Web Server\"" >> ampps.desktop'
	sudo bash -c 'echo "Categories=Utility;WebServer;Development;Database;" >> ampps.desktop'
	sudo bash -c 'echo "MimeType=text/plain;inode/directory;" >> ampps.desktop'
	sudo bash -c 'echo "Actions=new-window;" >> ampps.desktop'
	sudo bash -c 'echo "Keywords=ampps;" >> ampps.desktop'

	
	echo "------>   Downloading GNOME icon for the launcher... "
	cd /tmp && wget -q https://raw.githubusercontent.com/alexmigf/setup-ampps-ubuntu/master/ampps_large.png
	sudo mv ampps_large.png /usr/local/ampps/
}

# -------------------------------------------------------------
# PolicyKit
# -------------------------------------------------------------
updatePolicyKit () {
	ROUTE=/usr/share/polkit-1/actions/
	if [ $DEBUG = true ]; then
		ROUTE=/tmp
  fi
  #echo $ROUTE
    
	cd $ROUTE
	sudo rm com.ubuntu.ampps.policy && sudo touch com.ubuntu.ampps.policy
	sudo bash -c 'echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "<!DOCTYPE policyconfig PUBLIC \"-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN\" \"http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd\">" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "<policyconfig>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "  <vendor>Ampps</vendor>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "  <vendor_url>ampps</vendor_url>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "  <icon_name>ampps</icon_name>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "  <action id=\"org.freedesktop.policykit.pkexec.ampps\">" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "   <description>Run \"ampps\"</description>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "   <message>Authentication is required to run Ampps</message>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "   <defaults>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "     <allow_any>auth_admin</allow_any>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "     <allow_inactive>auth_admin</allow_inactive>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "     <allow_active>auth_admin</allow_active>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "   </defaults>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "     <annotate key=\"org.freedesktop.policykit.exec.path\">/usr/local/ampps/Ampps</annotate>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "     <annotate key=\"org.freedesktop.policykit.exec.allow_gui\">true</annotate>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "   </action>" >> com.ubuntu.ampps.policy'
	sudo bash -c 'echo "</policyconfig>" >> com.ubuntu.ampps.policy'
}


echo "------------------------------------------------------------------------------------------------------------------------------------------ "

echo ""
echo ""

echo "------>   Installing needed dependencies... "
sudo apt-get -qq update && sudo apt-get -y -qq install libfontconfig1 libxrender1
if [ $DEBUG = false ]; then
	read -n 1 -s -r -p "Installing needed dependencies DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo "------>   Downloading installation file... "
if [ $DEBUG = true ]; then
	echo "          ... would run \"cd /tmp && wget http://s4.softaculous.com/a/ampps/files/Ampps-3.8-x86_64.run\""
else
	cd /tmp && wget http://s4.softaculous.com/a/ampps/files/Ampps-3.8-x86_64.run
	read -n 1 -s -r -p "Downloading installation file DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo "------>   Giving file execution permissions... "
if [ $DEBUG = true ]; then
	echo "          ... would run \"sudo chmod 0755 Ampps-3.8-x86_64.run\""
else
	sudo chmod 0755 Ampps-3.8-x86_64.run
	read -n 1 -s -r -p "Giving file execution permissions DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo "------>   Installing... "
if [[ $* == *--debug* ]]; then
	echo "          ... would run \"sudo ./Ampps-3.8-x86_64.run\""
else
	sudo ./Ampps-3.8-x86_64.run
	read -n 1 -s -r -p "Installing DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo "------>   Fixing UI in QT... "
fixUIInQT
if [ $DEBUG = false ]; then
	read -n 1 -s -r -p "Fixing UI in QT DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo -e '\e[1A\e[K'
echo "------>   Fix Apache and PHP not running... "
if [ $DEBUG = true ]; then
	echo "          ... would run \"cd /usr/local/ampps/apache/lib\""
	echo "          ... would run \"sudo mkdir backup && sudo mv ./libapr* ./backup/\""
	echo "          ... would run \"sudo apt-get -y -q install --reinstall libaprutil1 libaprutil1-dev libapr1 libapr1-dev\""
else
	cd /usr/local/ampps/apache/lib
	sudo mkdir backup && sudo mv ./libapr* ./backup/
	sudo apt-get -y -qq install --reinstall libaprutil1 libaprutil1-dev libapr1 libapr1-dev
	read -n 1 -s -r -p "Fix Apache and PHP not running DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo "------>   Create a GNOME Launcher... "
createGNOMELauncher
if [ $DEBUG = false ]; then
	read -n 1 -s -r -p "Create a GNOME Launcher DONE, press any key to continue"
	echo -e '\e[1A\e[K'
fi


echo "------>   Updating PolicyKit to avoid errors... "
updatePolicyKit

echo ""
echo ""

echo "------------------------------------------------------------------------------------------------------------------------------------------ "
echo "--------------------------------------------- All done, now you should be able to run APPS!! --------------------------------------------- "
echo "------------------------------------------------------------------------------------------------------------------------------------------ "

exit