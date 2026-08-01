#!/usr/bin/env bash
set -u
keep="com.google.android.gms com.google.android.gsf com.google.android.gsf.login com.android.vending"
disable() {
	for pkg in "$@"; do
		case " $keep " in
			*" $pkg "*) echo "  keep: $pkg"; continue ;;
		esac
		if adb shell pm uninstall --user 0 "$pkg" >/dev/null 2>&1; then
			echo "  uninstalled: $pkg"
		elif adb shell pm disable-user --user 0 "$pkg" >/dev/null 2>&1; then
			echo "  disabled (not uninstallable): $pkg"
		else
			echo "  skip: $pkg"
		fi
	done
}

adb get-state >/dev/null 2>&1 || { echo "phone not connected (adb devices)"; exit 1; }

echo "google:"
disable \
	com.google.android.googlequicksearchbox \
	com.google.android.apps.maps \
	com.google.android.youtube \
	com.google.android.apps.tachyon \
	com.google.android.apps.photos \
	com.google.android.apps.messaging \
	com.google.android.apps.wellbeing \
	com.google.android.feedback \
	com.google.android.apps.googleassistant \
	com.google.android.videos \
	com.google.android.apps.subscriptions.red \
	com.google.android.apps.magazines \
	com.google.android.play.games \
	com.google.android.apps.docs \
	com.google.android.apps.drive \
	com.google.android.apps.sheets \
	com.google.android.apps.slides \
	com.google.android.apps.tasks \
	com.google.android.apps.keep \
	com.google.android.apps.translate \
	com.google.android.apps.walletnfcrel \
	com.google.android.syncadapters.contacts \
	com.google.android.syncadapters.calendar

echo "samsung:"
disable \
	com.samsung.android.bixby.wakeup \
	com.samsung.android.bixby.vision \
	com.samsung.android.app.spage \
	com.samsung.android.visionintelligence \
	com.samsung.android.bixby.agent \
	com.samsung.android.bixby.agent.dummy \
	com.samsung.android.app.routines \
	com.samsung.android.service.weather \
	com.samsung.android.mateagent \
	com.samsung.android.app.smartcapture \
	com.samsung.android.app.notes \
	com.samsung.android.samsungpass \
	com.samsung.android.samsungpassautofill \
	com.samsung.android.providers.context \
	com.samsung.android.game.gamehome \
	com.samsung.android.game.gametools \
	com.samsung.android.game.gos \
	com.samsung.android.lool \
	com.samsung.android.smartswitch \
	com.samsung.android.mobileservice \
	com.samsung.android.weather \
	com.samsung.android.video \
	com.samsung.android.app.reminder \
	com.samsung.android.music \
	com.samsung.android.oneconnect \
	com.samsung.android.honeyboard \
	com.samsung.android.svoiceime \
	com.sec.android.app.sbrowser \
	com.sec.android.app.billing \
	com.samsung.ucs.ucsservice \
	com.samsung.android.aremoji \
	com.samsung.android.arzone \
	com.samsung.android.airviewdictionary \
	com.sec.android.daemonapp

echo "samsung deep-clean:"
disable \
	com.sec.android.diagmonagent \
	com.sec.android.soagent \
	com.sec.android.iaft \
	com.sec.android.app.personalization \
	com.sec.android.app.safetyassurance \
	com.sec.automation \
	com.sec.bcservice \
	com.sec.android.sdhms \
	com.sec.imslogger \
	com.samsung.slsi.telephony.silentlogging \
	com.samsung.android.knox.analytics.uploader \
	com.samsung.android.sm.devicesecurity \
	com.samsung.android.da.daagent \
	com.samsung.android.dqagent \
	com.samsung.android.svcagent \
	com.samsung.android.mdecservice \
	com.samsung.android.fast \
	com.samsung.android.scpm \
	com.samsung.android.cmh \
	com.samsung.android.mydevice \
	com.samsung.android.aware.service \
	com.samsung.android.beaconmanager \
	com.samsung.android.location \
	com.samsung.android.samsungpositioning \
	com.samsung.android.ipsgeofence \
	com.samsung.android.mapsagent \
	com.sec.location.nsflp2 \
	com.samsung.android.mhs.ai \
	com.samsung.android.intellivoiceservice \
	com.samsung.android.sree \
	com.samsung.android.aicore \
	com.samsung.android.rubin.app \
	com.samsung.android.app.interpreter \
	com.samsung.android.offline.languagemodel \
	com.samsung.android.bixbyvision.framework \
	com.samsung.android.vision.model \
	com.samsung.android.bixby.ondevice.dede \
	com.samsung.android.bixby.ondevice.engb \
	com.samsung.android.callassistant \
	com.samsung.android.smartcallprovider \
	com.samsung.android.smartface \
	com.samsung.android.smartface.overlay \
	com.samsung.android.sdk.ocr \
	com.samsung.android.aremojieditor \
	com.samsung.android.stickercenter \
	com.samsung.android.app.camera.sticker.facearavatar.preload \
	com.samsung.android.motionphoto.app \
	com.samsung.android.liveeffectservice \
	com.samsung.android.camerasdkservice \
	com.samsung.android.app.dressroom \
	com.samsung.android.app.vex.scanner \
	com.samsung.android.vexfwk.service \
	com.samsung.android.photoremasterservice \
	com.samsung.android.visual.cloudcore \
	com.samsung.android.smartmirroring \
	com.samsung.android.audiomirroring \
	com.samsung.android.allshare.service.mediashare \
	com.samsung.android.mediasearch \
	com.samsung.android.scloud \
	com.samsung.android.storyservice \
	com.samsung.android.mdx \
	com.samsung.android.mdx.kit \
	com.samsung.android.mcfds \
	com.samsung.android.mcfserver \
	com.samsung.android.mcf.autohotspot \
	com.samsung.android.app.sharelive \
	com.sec.android.app.samsungapps \
	com.samsung.android.themestore \
	com.samsung.android.themecenter \
	com.samsung.android.app.updatecenter \
	com.samsung.android.app.tips \
	com.samsung.android.smartsuggestions \
	com.samsung.android.dynamiclock \
	com.samsung.android.wallpaper.live \
	com.samsung.android.gpuwatchapp \
	com.samsung.android.kidsinstaller \
	com.sec.android.app.kidshome \
	com.samsung.android.app.parentalcare \
	com.samsung.android.app.sketchbook \
	com.samsung.android.smartswitchassistant \
	com.sec.android.easyMover \
	com.sec.android.easyMover.Agent \
	com.samsung.android.app.omcagent \
	com.samsung.android.app.voicewakeup \

echo "google deep-clean:"
disable \
	com.google.android.apps.bard \
	com.google.android.apps.googleapp \
	com.google.android.hotwordenrollment.okgoogle \
	com.google.android.hotwordenrollment.xgoogle \
	com.google.mainline.telemetry \
	com.google.mainline.adservices \
	com.google.android.adservices.api \
	com.google.android.ondevicepersonalization.services \
	com.google.android.apps.restore \
	com.google.android.apps.setupwizard.searchselector \
	com.google.android.projection.gearhead \
	com.google.android.gms.location.history \
	com.google.ar.core \
	com.google.android.glasses.core \
	com.google.android.apps.aiwallpapers \
	com.facebook.system \
	com.facebook.services \
	com.facebook.appmanager

echo "settings:"
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.adguard-dns.com
adb shell settings put secure wifi_scan_always_enabled 0
adb shell settings put secure bluetooth_scan_always_enabled 0
adb shell settings put system screen_off_timeout 60000
adb shell settings put secure lock_screen_lock_after_timeout 30000
adb shell settings put secure location_mode 0
echo "settings applied (dns, scanning off, 60s timeout, location off)"

echo "user picks:"
disable \
	com.microsoft.office.outlook \
	com.microsoft.skydrive \
	com.linkedin.android \
	com.google.android.gm \
	com.sec.android.gallery3d \
	com.samsung.android.messaging \
	com.sec.android.app.voicenote \
	com.samsung.android.voc \
	com.spotify.music \
	com.google.android.apps.youtube.music \
	com.samsung.android.app.contacts \
	com.sec.android.app.clockpackage \
	com.sec.android.app.camera \
	com.samsung.android.calendar \
	com.sec.android.app.popupcalculator \
	com.android.chrome \
	com.microsoft.office.officehubrow \
	com.microsoft.appmanager \
	com.sec.android.app.myfiles

echo "obtainium preset:"
preset="$(dirname "$0")/obtainium-preset.json"
if [ -f "$preset" ]; then
	adb push "$preset" /sdcard/Download/obtainium-preset.json >/dev/null && echo "  pushed to /sdcard/Download/obtainium-preset.json"
else
	echo "  skip: $preset not found"
fi

echo done
