#!/usr/bin/env bash
set -u
reset=0
ACCEPT_ALL=0
scan=0
help=0
tier=4
bench_mode=0
bench_compare=0
bench_a=""
bench_b=""
samsung_mode=0
check_mode=0
verify_mode=0
hacker_mode=0
while [ "$#" -gt 0 ]; do
	case "$1" in
		--help|-h) help=1;;
		--reset) reset=1;;
		--accept-all|-y) ACCEPT_ALL=1;;
		--scan) scan=1;;
		--samsung) samsung_mode=1;;
		--check) check_mode=1;;
		--verify) verify_mode=1;;
		--hacker) hacker_mode=1;;
		--bench) bench_mode=1; if [ $# -ge 2 ] && [ "${2#-}" = "$2" ]; then bench_label="$2"; shift; fi;;
		--bench=*) bench_mode=1; bench_label="${1#--bench=}";;
		--bench-compare) bench_compare=1; bench_a="${2:-}"; bench_b="${3:-}"; shift $(( $# >= 3 ? 2 : ( $# >= 2 ? 1 : 0 ) ));;
		--tier)
			case "${2:-}" in
				1|2|3|4) tier="$2"; shift;;
				*) echo "invalid --tier: ${2:-} (use 1-4)"; exit 1;;
			esac
			;;
		--tier=*) tier="${1#--tier=}";;
		--tier[1-4]) tier="${1#--tier}";;
		*) echo "unknown option: $1 (see --help)"; exit 1;;
	esac
	shift
done
case "$tier" in
	1|2|3|4) : ;;
	*) echo "invalid tier: $tier (use 1-4)"; exit 1;;
esac

if [ "$hacker_mode" = 1 ]; then
	echo -e "\033[1;32m"
	cat <<'EOF'
  ▓▓▓ INITIATING PHONE HARDENING SEQUENCE ▓▓▓
EOF
	echo -e "\033[0m"
	export PS4=$'\033[1;32m▶\033[0m '
	set -x
fi

keep="com.google.android.gms com.google.android.gsf com.google.android.gsf.login com.android.vending com.sec.android.app.launcher"
google=(
	com.google.android.googlequicksearchbox
	com.google.android.apps.maps
	com.google.android.youtube
	com.google.android.apps.tachyon
	com.google.android.apps.photos
	com.google.android.apps.messaging
	com.google.android.apps.wellbeing
	com.google.android.feedback
	com.google.android.apps.googleassistant
	com.google.android.videos
	com.google.android.apps.subscriptions.red
	com.google.android.apps.magazines
	com.google.android.play.games
	com.google.android.apps.docs
	com.google.android.apps.drive
	com.google.android.apps.sheets
	com.google.android.apps.slides
	com.google.android.apps.tasks
	com.google.android.apps.keep
	com.google.android.apps.translate
	com.google.android.apps.walletnfcrel
	com.google.android.syncadapters.contacts
	com.google.android.syncadapters.calendar
)
samsung=(
	com.sec.android.app.desktoplauncher
	com.samsung.android.bixby.wakeup
	com.samsung.android.bixby.vision
	com.samsung.android.app.spage
	com.samsung.android.visionintelligence
	com.samsung.android.bixby.agent
	com.samsung.android.bixby.agent.dummy
	com.samsung.android.app.routines
	com.samsung.android.service.weather
	com.samsung.android.mateagent
	com.samsung.android.app.smartcapture
	com.samsung.android.app.notes
	com.samsung.android.samsungpass
	com.samsung.android.samsungpassautofill
	com.samsung.android.providers.context
	com.samsung.android.game.gamehome
	com.samsung.android.game.gametools
	com.samsung.android.game.gos
	com.samsung.android.lool
	com.samsung.android.smartswitch
	com.samsung.android.mobileservice
	com.samsung.android.weather
	com.samsung.android.video
	com.samsung.android.app.reminder
	com.samsung.android.music
	com.samsung.android.oneconnect
	com.samsung.android.svoiceime
	com.sec.android.app.sbrowser
	com.sec.android.app.billing
	com.samsung.ucs.ucsservice
	com.samsung.android.aremoji
	com.samsung.android.arzone
	com.samsung.android.airviewdictionary
	com.sec.android.daemonapp
)
samsung_deep=(
	com.sec.android.diagmonagent
	com.sec.android.soagent
	com.sec.android.iaft
	com.sec.android.app.personalization
	com.sec.android.app.safetyassurance
	com.sec.automation
	com.sec.bcservice
	com.sec.android.sdhms
	com.sec.imslogger
	com.samsung.slsi.telephony.silentlogging
	com.samsung.android.knox.analytics.uploader
	com.samsung.android.sm.devicesecurity
	com.samsung.android.da.daagent
	com.samsung.android.dqagent
	com.samsung.android.svcagent
	com.samsung.android.mdecservice
	com.samsung.android.fast
	com.samsung.android.scpm
	com.samsung.android.cmh
	com.samsung.android.mydevice
	com.samsung.android.aware.service
	com.samsung.android.beaconmanager
	com.samsung.android.location
	com.samsung.android.samsungpositioning
	com.samsung.android.ipsgeofence
	com.samsung.android.mapsagent
	com.sec.location.nsflp2
	com.samsung.android.mhs.ai
	com.samsung.android.intellivoiceservice
	com.samsung.android.sree
	com.samsung.android.aicore
	com.samsung.android.rubin.app
	com.samsung.android.app.interpreter
	com.samsung.android.offline.languagemodel
	com.samsung.android.bixbyvision.framework
	com.samsung.android.vision.model
	com.samsung.android.bixby.ondevice.dede
	com.samsung.android.bixby.ondevice.engb
	com.samsung.android.callassistant
	com.samsung.android.smartcallprovider
	com.samsung.android.smartface
	com.samsung.android.smartface.overlay
	com.samsung.faceservice
	com.samsung.android.sdk.ocr
	com.samsung.android.aremojieditor
	com.samsung.android.stickercenter
	com.samsung.android.app.camera.sticker.facearavatar.preload
	com.samsung.android.motionphoto.app
	com.samsung.android.liveeffectservice
	com.samsung.android.camerasdkservice
	com.samsung.android.app.dressroom
	com.samsung.android.app.vex.scanner
	com.samsung.android.vexfwk.service
	com.samsung.android.photoremasterservice
	com.samsung.android.visual.cloudcore
	com.samsung.android.smartmirroring
	com.samsung.android.audiomirroring
	com.samsung.android.allshare.service.mediashare
	com.samsung.android.mediasearch
	com.samsung.android.scloud
	com.samsung.android.storyservice
	com.samsung.android.mdx
	com.samsung.android.mdx.kit
	com.samsung.android.mcfds
	com.samsung.android.mcfserver
	com.samsung.android.mcf.autohotspot
	com.samsung.android.app.sharelive
	com.sec.android.app.samsungapps
	com.samsung.android.themestore
	com.samsung.android.themecenter
	com.samsung.android.app.updatecenter
	com.samsung.android.app.tips
	com.samsung.android.smartsuggestions
	com.samsung.android.dynamiclock
	com.samsung.android.wallpaper.live
	com.samsung.android.gpuwatchapp
	com.samsung.android.kidsinstaller
	com.sec.android.app.kidshome
	com.samsung.android.app.parentalcare
	com.samsung.android.app.sketchbook
	com.samsung.android.smartswitchassistant
	com.sec.android.easyMover
	com.sec.android.easyMover.Agent
	com.samsung.android.app.omcagent
	com.samsung.android.app.voicewakeup
	com.hiya.star
	com.samsung.android.forest
	com.samsung.android.dsms
	com.samsung.android.qmdservice
	com.wssyncmldm
	com.samsung.android.singletake.service
	com.samsung.android.networkdiagnostic
	com.samsung.android.service.peoplestripe
	com.samsung.android.app.taskedge
	com.samsung.android.app.clipboardedge
	com.sec.android.mimage.avatarstickers
	com.sec.android.mimage.photoretouching
)
google_deep=(
	com.google.android.apps.bard
	com.google.android.apps.googleapp
	com.google.android.hotwordenrollment.okgoogle
	com.google.android.hotwordenrollment.xgoogle
	com.google.mainline.telemetry
	com.google.mainline.adservices
	com.google.android.adservices.api
	com.google.android.ondevicepersonalization.services
	com.google.android.apps.restore
	com.google.android.apps.setupwizard.searchselector
	com.google.android.projection.gearhead
	com.google.android.gms.location.history
	com.google.ar.core
	com.google.android.glasses.core
	com.google.android.apps.aiwallpapers
	com.facebook.system
	com.facebook.services
	com.facebook.appmanager
	com.google.android.federatedcompute
	com.google.android.configupdater
	com.google.android.onetimeinitializer
	com.google.android.setupwizard
)
tier1=(
	com.android.printspooler
	com.android.bips
	com.sec.android.easyonehand
	com.samsung.knox.securefolder
	com.sec.android.app.shealth
	com.android.dreams.basic
	com.android.dreams.phototable
	com.samsung.android.app.talkback
)
tier2=(com.samsung.android.dialer)
userpicks=(
	com.microsoft.office.outlook
	com.microsoft.skydrive
	com.linkedin.android
	com.sec.android.RilServiceModeApp
	com.google.android.gm
	com.sec.android.gallery3d
	com.samsung.android.messaging
	com.sec.android.app.voicenote
	com.samsung.android.voc
	com.spotify.music
	com.google.android.apps.youtube.music
	com.samsung.android.app.contacts
	com.sec.android.app.clockpackage
	com.sec.android.app.camera
	com.samsung.android.calendar
	com.sec.android.app.popupcalculator
	com.android.chrome
	com.microsoft.office.officehubrow
	com.microsoft.appmanager
	com.sec.android.app.myfiles
)
disable() {
	for pkg in "$@"; do
		case " $keep " in
			*" $pkg "*) echo "  keep: $pkg"; continue ;;
		esac
		if ! adb shell pm path "$pkg" >/dev/null 2>&1; then
			echo "  not installed: $pkg"
		elif adb shell pm uninstall --user 0 "$pkg" >/dev/null 2>&1 \
			&& ! adb shell pm path "$pkg" >/dev/null 2>&1; then
			echo "  uninstalled: $pkg"
		elif adb shell pm disable-user --user 0 "$pkg" >/dev/null 2>&1; then
			echo "  disabled: $pkg"
		else
			echo "  skip: $pkg"
		fi
	done
}

missing_pkgs=()
appops_deny=(
	# keyboards
	"helium314.keyboard CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION GET_ACCOUNTS"
	"org.futo.inputmethod.latin CAMERA FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION GET_ACCOUNTS"
	# dialer / sms / messaging
	"com.fossify.phone CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION BODY_SENSORS ACTIVITY_RECOGNITION READ_CLIPBOARD"
	"dev.octoshrimpy.quik.fdroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CALL_LOG BODY_SENSORS ACTIVITY_RECOGNITION"
	"im.molly.app FINE_LOCATION COARSE_LOCATION BODY_SENSORS ACTIVITY_RECOGNITION"
	# launchers
	"fr.neamar.kiss CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG READ_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION READ_CLIPBOARD"
	"de.jrpie.android.launcher CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG READ_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION READ_CLIPBOARD"
	"com.sec.android.app.launcher CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG READ_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION READ_CLIPBOARD GET_ACCOUNTS"
	# browsers (camera/mic/location left for WebRTC/geolocation API use)
	"org.cromite.cromite READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG READ_SMS WRITE_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.ironfoxoss.ironfox READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG READ_SMS WRITE_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	# auth / password / crypto (camera left where QR scan is a core feature)
	"com.beemdevelopment.aegis RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION GET_ACCOUNTS"
	"com.kunzisoft.keepass.libre RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION GET_ACCOUNTS"
	"proton.android.pass.fdroid RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.pgpony.android RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"de.markusfisch.android.binaryeye RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.cryptomator.lite CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	# mail / cloud / sync
	"ch.protonmail.android FINE_LOCATION COARSE_LOCATION BODY_SENSORS ACTIVITY_RECOGNITION"
	"me.proton.android.drive RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.mozilla.thunderbird CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS"
	"at.bitfire.davdroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.fossify.contacts CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.fossify.calendar CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	# vpn / network / firewall (self-contained, no sensor/contact needs)
	"ch.protonvpn.android CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.torproject.vpn FINE_LOCATION COARSE_LOCATION"
	"eu.faircode.netguard CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.celzero.bravedns CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"dev.clombardo.dnsnet CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.emanuelef.remote_capture CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	# maps/weather/tracker (location left where it's the whole point)
	"app.organicmaps CAMERA RECORD_AUDIO READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.breezyweather CAMERA RECORD_AUDIO READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"de.seemoo.at_tracking_detection CAMERA RECORD_AUDIO READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS"
	# camera (location/mic left as optional geotag/video features)
	"net.sourceforge.opencamera READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION READ_CLIPBOARD"
	# media / downloaders / gallery / files
	"de.danoeh.antennapod CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_SMS"
	"app.zhaobozhen.libre CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.github.libretube CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.brouken.player CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS"
	"com.junkfood.seal CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_SMS"
	"deckers.thibault.aves.libre CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"me.zhanghai.android.files CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_SMS"
	"com.localsend.localsend CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION"
	# productivity/utility
	"com.fossify.clock CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.fossify.calculator CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_SMS"
	"com.fossify.notes CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_SMS"
	"com.trianguloy.urlchecker CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.jarsilio.android.scrambledeggsif RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.github.tmo1.sms_ie CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.f0x1d.logfox CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	# app management / stores (none need sensors/contacts/sms)
	"org.eu.exodus_privacy.exodusprivacy CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.valhalla.thor CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.samo_lego.canta CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"io.github.muntashirakon.AppManager CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"dev.imranr.obtainium.fdroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"eu.darken.myperm CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"net.typeblog.shelter CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.machiav3lli.backup CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.machiav3lli.fdroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.aurora.store CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.fdroid.fdroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"com.looker.droidify CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"eu.bubu1.fdroidclassic CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"app.flicky CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"org.gdroid.gdroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"in.sunilpaulmathew.izzyondroid CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"zed.rainxch.githubstore CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"app.accrescent.client CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
	"dev.zapstore.app CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION READ_CONTACTS READ_CALL_LOG READ_SMS BODY_SENSORS ACTIVITY_RECOGNITION"
)
restore() { # re-enable / re-install system packages removed by disable()
	for pkg in "$@"; do
		if adb shell pm path "$pkg" >/dev/null 2>&1; then
			adb shell pm enable "$pkg" >/dev/null 2>&1
			echo "  enabled: $pkg"
		elif adb shell cmd package install-existing --user 0 "$pkg" >/dev/null 2>&1; then
			echo "  restored: $pkg"
		else
			missing_pkgs+=("$pkg")
			echo "  not in system: $pkg"
		fi
	done
}

np_uid() { # package -> uid (empty if not installed for user 0)
	adb shell pm list packages -U 2>/dev/null | tr -d '\r' | \
		sed -n "s/^package:$1.*uid:\\([0-9]*\\).*/\\1/p" | head -1
}

np_add() { # package: restrict background data
	local uid
	uid="$(np_uid "$1")"
	if [ -n "$uid" ]; then
		adb shell cmd netpolicy add restrict-background-blacklist "$uid" >/dev/null 2>&1 \
			&& echo "  restrict-background: $1 (uid $uid)"
	else
		echo "  skip $1 (not installed)"
	fi
}

np_rm() { # package: remove from background-data blacklist
	local uid
	uid="$(np_uid "$1")"
	[ -n "$uid" ] && adb shell cmd netpolicy remove restrict-background-blacklist "$uid" >/dev/null 2>&1
}

verify_sigs() {
	if ! command -v apksigner >/dev/null 2>&1; then
		echo "apksigner not found (install Android SDK build-tools, or add it to PATH)"
		return 1
	fi
	# format: package sha256(colon-separated, uppercase) name
	# add more entries as: "package SHA256 Name" -- get the official hash from
	# the project's own README/site (not a mirror) before trusting it here.
	known_sigs=(
		"com.beemdevelopment.aegis C6:DB:80:A8:E1:4E:52:30:C1:DE:84:15:EF:82:0D:13:DC:90:1D:8F:E3:3C:F3:AC:B5:7B:68:62:D8:58:A8:23 Aegis"
	)
	echo "signing certificate verification:"
	for entry in "${known_sigs[@]}"; do
		pkg="$(echo "$entry" | awk '{print $1}')"
		expected="$(echo "$entry" | awk '{print $2}')"
		name="$(echo "$entry" | cut -d' ' -f3-)"
		if ! adb shell pm path "$pkg" >/dev/null 2>&1; then
			echo "  skip $name (not installed)"
			continue
		fi
		apkpath="$(adb shell pm path "$pkg" 2>/dev/null | tr -d '\r' | sed 's/^package://' | head -1)"
		adb shell "cat '$apkpath'" 2>/dev/null > "/tmp/verify_$pkg.apk"
		actual="$(apksigner verify --print-certs "/tmp/verify_$pkg.apk" 2>/dev/null | \
			grep 'SHA-256' | head -1 | awk '{print $NF}' | tr '[:lower:]' '[:upper:]' | \
			sed 's/../&:/g;s/:$//')"
		rm -f "/tmp/verify_$pkg.apk"
		if [ -z "$actual" ]; then
			echo "  WARN $name: could not extract signature"
		elif [ "$actual" = "$expected" ]; then
			echo "  OK   $name: signature matches"
		else
			echo "  MISMATCH $name: expected $expected got $actual"
		fi
	done
}

reset() {
	echo "reset to stock:"
	echo "restore system apps:"
	restore "${google[@]}" "${samsung[@]}" "${samsung_deep[@]}" "${google_deep[@]}" "${tier1[@]}" "${userpicks[@]}" "${tier2[@]}"
	echo "remove foss apps:"
	for pkg in $(grep -oP '^\tyes_install \K\S+' "$0") org.futo.inputmethod.latin; do
		if adb shell pm path "$pkg" >/dev/null 2>&1; then
			adb shell pm uninstall --user 0 "$pkg" >/dev/null 2>&1
			adb uninstall "$pkg" >/dev/null 2>&1
			echo "  removed: $pkg"
		else
			echo "  not installed: $pkg"
		fi
	done
	echo "keyboard:"
	adb shell pm enable com.samsung.android.honeyboard >/dev/null 2>&1
	local svc
	svc="$(adb shell ime list -s -a 2>/dev/null | tr -d '\r' | grep honeyboard | head -1)"
	[ -z "$svc" ] && svc="com.samsung.android.honeyboard/.service.HoneyBoardService"
	if [ -n "$svc" ]; then
		adb shell ime enable "$svc" >/dev/null 2>&1
		adb shell ime set "$svc" >/dev/null 2>&1
		echo "  default: $svc"
	else
		echo "  warn: samsung keyboard not available"
	fi
	echo "launcher:"
	if adb shell pm path com.sec.android.app.launcher >/dev/null 2>&1 \
		|| adb shell cmd package install-existing --user 0 com.sec.android.app.launcher >/dev/null 2>&1; then
		adb shell pm enable com.sec.android.app.launcher >/dev/null 2>&1
		adb shell cmd package set-home-activity com.sec.android.app.launcher/com.sec.android.app.launcher.activities.LauncherActivity >/dev/null 2>&1 \
			|| adb shell cmd package set-home-activity com.sec.android.app.launcher/.activities.LauncherActivity >/dev/null 2>&1
		echo "  home: one ui"
	else
		echo "  warn: one ui home not available"
	fi
	echo "settings:"
	for k in private_dns_mode private_dns_specifier window_animation_scale transition_animation_scale \
		animator_duration_scale adaptive_battery_management_enabled app_standby_enabled mobile_data_always_on \
		package_verifier_enable verifier_verify_installs verifier_verify_adb_installs hide_error_dialogs \
		backup_enabled adb_require_authorization bixby_pregranted_permissions \
		link_to_windows_pregranted_permissions link_to_windows_service_pregranted_permissions \
		always_on_vpn_package always_on_vpn_lockdown captive_portal_detection_enabled \
		stay_on_while_plugged_in wifi_networks_available_notification_on \
		wifi_wakeup_enabled adb_wifi_enabled wifi_p2p_pending_factory_reset \
		bluetooth_discoverability bluetooth_discoverability_timeout; do
		adb shell settings delete global "$k" >/dev/null 2>&1
	done
	for k in wifi_scan_always_enabled bluetooth_scan_always_enabled lock_screen_lock_after_timeout \
		location_mode doze_pulse_on_pick_up double_tap_to_wake wake_gesture_enabled aod_mode screensaver_enabled \
		lock_screen_show_notifications lock_screen_allow_private_notifications nfc_on auto_revoke_permissions \
		nearby_scanning_enabled location_scanning_enabled nearby_sharing_enabled; do
		adb shell settings delete secure "$k" >/dev/null 2>&1
	done
	for k in aod_mode aod_tap_to_show_mode aod_show_state aod_notifications double_tab_to_wake_up; do
		adb shell settings delete system "$k" >/dev/null 2>&1
	done
	for k in screen_off_timeout screen_brightness_mode; do
		adb shell settings delete system "$k" >/dev/null 2>&1
	done
	adb shell pm enable com.google.android.gms.nearby.sharing >/dev/null 2>&1
	adb shell am set-standby-bucket --user 0 com.samsung.android.kgclient active >/dev/null 2>&1
	adb shell cmd appops reset com.google.android.gms >/dev/null 2>&1
	adb shell cmd appops reset com.android.vending >/dev/null 2>&1
	for entry in "${appops_deny[@]}"; do
		adb shell cmd appops reset "${entry%% *}" >/dev/null 2>&1
	done
	adb shell cmd package install-existing --user 0 com.android.vending >/dev/null 2>&1
	for p in com.facebook.appmanager com.facebook.services com.facebook.system \
		com.google.android.adservices.api com.samsung.android.da.daagent \
		com.samsung.android.dqagent com.samsung.android.knox.analytics.uploader \
		com.sec.android.app.launcher com.google.android.gms; do
		np_rm "$p"
	done
	echo "  defaults restored"
	if [ ${#missing_pkgs[@]} -gt 0 ]; then
		echo "not in /system (user-installed, must come from play store):"
		printf '  %s\n' "${missing_pkgs[@]}"
	fi
	echo "done"
}

adb get-state >/dev/null 2>&1 || { echo "phone not connected (adb devices)"; exit 1; }

usage() {
	cat <<EOF
usage: phone-hardener.sh [options]

hardens a samsung galaxy via adb: debloats google/samsung apps,
installs foss replacements, hardens privacy settings.

options:
  --accept-all|-y   auto-yes every prompt (incl. app installs, lockdowns)
  --tier N          debloat depth 1-4 (1=google+samsung, 2=+deep-clean,
                    3=+safe extras/dialer+keyboard swap/user picks, 4=all)
  --reset           undo everything: restore apps, settings, default keyboard
  --scan            list preinstalled packages not covered by this script
  --samsung         list ALL preinstalled samsung/sec packages with state
  --bench[=label]   snapshot perf metrics (mem/procs/packages) to a file
  --bench-compare A B  diff two snapshots saved with --bench
  --check           print privacy audit of the current device state
  --verify          verify signing certs of security-critical apps against known hashes
  --hacker          echo every command as it runs (verbose green tracing)
  --help|-h         show this help

no options runs the full hardening interactively (per-app y/n/all prompts).
require an authorized device: adb devices

note: one ui home (com.sec.android.app.launcher) is always kept enabled
(required for recents/gesture-nav) and cannot be disabled by this script.
it is instead heavily restricted via app-ops and background-data policy.
EOF
}

if [ "$help" = 1 ]; then
	usage
	exit 0
fi

if [ "$reset" = 1 ]; then
	reset
	exit 0
fi

scan() { # list preinstalled packages not referenced anywhere in this script
	known="$(grep -oP 'com\.[a-zA-Z0-9_.-]+' "$0" | sort -u)"
	noise="(\.overlay|\.resources|auto_generated|\.rro_|SMT\.lang_|com\.monotype\.|navbar\.|cutout\.emulation|hotwordenrollment)"
	core="^(com.android.systemui|com.android.settings|com.android.phone|com.android.shell|com.android.bluetooth|com.android.nfc|com.android.ons|com.android.se|com.android.permissioncontroller|com.android.packageinstaller|com.android.server.telecom|com.android.providers\..*|com.android.sharedstoragebackup|com.android.defcontainer|com.android.cellbroadcastreceiver|com.android.cellbroadcastservice|com.android.captiveportallogin|com.android.egg|com.android.keychain|com.android.webview|com.android.inputmethod.*|com.android.launcher3.*|com.android.stk|com.android.stk2|com.android.carrierconfig|com.android.mtp|com.android.externalstorage|com.android.documentsui|com.android.mediaprovider.*|com.android.incallui)$"
	keep="^(com.samsung.android.incallui|com.samsung.android.app.telephonyui|com.samsung.android.emergency|com.samsung.android.biometrics.app.setting|com.samsung.android.fmm|com.samsung.android.spayfw|com.samsung.android.carkey|com.samsung.android.ese|com.samsung.android.kmxservice|com.samsung.android.appseparation|com.samsung.android.rampart|com.samsung.klmsagent|com.samsung.android.knox.*|com.samsung.android.privateaccesstokens|com.samsung.android.messageguardsync|com.samsung.android.dkey|com.samsung.android.cameraxservice|com.samsung.android.service.stplatform|com.google.android.ext.*|com.google.android.modulemetadata|com.google.android.rkpdapp|com.google.android.documentsui|com.google.android.photopicker|com.google.android.appsearch.*|com.google.android.sdksandbox|com.google.android.networkstack.*|com.google.android.safetycenter.*|com.google.android.supervision)$"
	echo "scanning for preinstalled packages not covered by this script..."
	adb shell pm list packages -f 2>/dev/null | tr -d '\r' | \
		sed -n 's#^package:\(/system[^=]*\|/product[^=]*\|/omc[^=]*\|/vendor[^=]*\|/prism[^=]*\|/apex[^=]*\)=\([^=]*\)$#\2#p' | \
		while read -r p; do
			echo "$known" | grep -qx "$p" && continue
			echo "$p" | grep -Eq "$noise" && continue
			echo "$p" | grep -Eq "$core" && continue
			echo "$p" | grep -Eq "$keep" && continue
			printf '  %s\n' "$p"
		done
	echo "done (nothing above = every preinstalled app is covered)"
}

samsung_list() { # every samsung/sec package (incl. removed for user 0), with state
	adb shell pm list packages -u 2>/dev/null | tr -d '\r' | \
		sed -n 's#^package:\(com\.\(samsung\|sec\)\.[a-zA-Z0-9_.]*\)$#\1#p' | sort -u > /tmp/samsung-all.txt
	adb shell pm list packages -d 2>/dev/null | tr -d '\r' | \
		sed -n 's#^package:\(com\.\(samsung\|sec\)\.[a-zA-Z0-9_.]*\)$#\1#p' | sort -u > /tmp/samsung-disabled.txt
	adb shell pm list packages 2>/dev/null | tr -d '\r' | \
		sed -n 's#^package:\(com\.\(samsung\|sec\)\.[a-zA-Z0-9_.]*\)$#\1#p' | sort -u > /tmp/samsung-installed.txt
	echo "all samsung/sec packages (enabled / DISABLED / REMOVED-for-user0):"
	while read -r p; do
		[ -z "$p" ] && continue
		if grep -qx "$p" /tmp/samsung-disabled.txt; then
			printf '  %-58s DISABLED\n' "$p"
		elif grep -qx "$p" /tmp/samsung-installed.txt; then
			printf '  %-58s enabled\n' "$p"
		else
			printf '  %-58s REMOVED\n' "$p"
		fi
	done < /tmp/samsung-all.txt
	echo "total: $(grep -c '^com\.' /tmp/samsung-all.txt)  (enabled: $(grep -c '^com\.' /tmp/samsung-installed.txt), disabled: $(grep -c '^com\.' /tmp/samsung-disabled.txt), removed: $(( $(grep -c '^com\.' /tmp/samsung-all.txt) - $(grep -c '^com\.' /tmp/samsung-installed.txt) )))"
	rm -f /tmp/samsung-all.txt /tmp/samsung-disabled.txt /tmp/samsung-installed.txt
}

privacy_check() { # audit current posture: settings, vpn, packages
	g() { local v; v="$(adb shell settings get global "$1" 2>/dev/null | tr -d '\r')"; printf '  %-40s %s\n' "$1" "${v:-unset}"; }
	s() { local v; v="$(adb shell settings get secure "$1" 2>/dev/null | tr -d '\r')"; printf '  %-40s %s\n' "$1" "${v:-unset}"; }
	sy() { local v; v="$(adb shell settings get system "$1" 2>/dev/null | tr -d '\r')"; printf '  %-40s %s\n' "$1" "${v:-unset}"; }
	echo "privacy audit:"
	echo "dns (private dns / dot):"
	g private_dns_mode
	g private_dns_specifier
	echo "tracking/scanning:"
	s wifi_scan_always_enabled
	s bluetooth_scan_always_enabled
	s nearby_scanning_enabled
	s location_scanning_enabled
	s location_mode
	echo "nearby/sharing/bluetooth:"
	s nearby_sharing_enabled
	g bluetooth_discoverability
	g bluetooth_discoverability_timeout
	g wifi_p2p_pending_factory_reset
	echo "aod (samsung reads system namespace):"
	sy aod_mode
	sy aod_tap_to_show_mode
	sy double_tab_to_wake_up
	echo "network/radio:"
	g adb_enabled
	g adb_wifi_enabled
	g wifi_networks_available_notification_on
	g wifi_wakeup_enabled
	s nfc_on
	echo "vpn kill-switch:"
	g always_on_vpn_package
	g always_on_vpn_lockdown
	echo "misc:"
	g backup_enabled
	g captive_portal_detection_enabled
	g stay_on_while_plugged_in
	g package_verifier_enable
	echo "mac randomization:"
	if adb shell dumpsys wifi 2>/dev/null | tr -d '\r' | grep -q 'isMacRandomizationOn=true'; then
		echo "  on (persistent per-network)"
	else
		echo "  off/unreadable"
	fi
	local allpkg still=0 fos=0 total
	allpkg="$(adb shell pm list packages 2>/dev/null | tr -d '\r' | sed 's/^package://')"
	for p in "${google[@]}" "${samsung[@]}" "${samsung_deep[@]}" "${google_deep[@]}" "${tier1[@]}" "${tier2[@]}" "${userpicks[@]}"; do
		echo "$allpkg" | grep -qx "$p" && still=$((still+1))
	done
	total=$(grep -oP '^\tyes_install \K\S+' "$0" | wc -l)
	for p in $(grep -oP '^\tyes_install \K\S+' "$0"); do
		echo "$allpkg" | grep -qx "$p" && fos=$((fos+1))
	done
	echo "packages:"
	printf '  installed (user 0): %s\n' "$(echo "$allpkg" | grep -c '^com\.')"
	printf '  disabled:           %s\n' "$(adb shell pm list packages -d 2>/dev/null | tr -d '\r' | grep -c '^package:')"
	printf '  debloat targets still present: %s\n' "$still"
	printf '  foss apps installed: %s/%s\n' "$fos" "$total"
	echo "play store:"
	if echo "$allpkg" | grep -qx com.android.vending; then
		echo "  present"
	else
		echo "  removed (aurora/f-droid only)"
	fi
	echo "accounts:"
	local accts
	accts="$(adb shell dumpsys account 2>/dev/null | tr -d '\r' | grep -oE 'type=[a-zA-Z0-9_.]+' | cut -d= -f2 | sort -u)"
	if [ -n "$accts" ]; then
		echo "$accts" | sed 's/^/  signed in: /'
	else
		echo "  none detected"
	fi
}

bench() { # snapshot key performance metrics; --bench label
	label="${1:-snapshot}"
	out="$HOME/phone-bench-$label.txt"
	{
		echo "=== phone benchmark snapshot: $label ==="
		echo "date: $(date '+%Y-%m-%d %H:%M:%S')"
		echo "uptime: $(adb shell uptime 2>/dev/null | tr -d '\r')"
		echo "packages installed: $(adb shell pm list packages 2>/dev/null | tr -d '\r' | grep -c '^package:')"
		echo "running processes: $(adb shell ps -A 2>/dev/null | tr -d '\r' | grep -vc '^PID')"
		adb shell cat /proc/meminfo 2>/dev/null | tr -d '\r' | grep -E '^(MemTotal|MemFree|MemAvailable|Buffers|Cached):'
		echo "load: $(adb shell cat /proc/loadavg 2>/dev/null | tr -d '\r')"
		echo "storage: $(adb shell df /data 2>/dev/null | tr -d '\r' | tail -1)"
	} | tee "$out"
	echo "saved: $out (compare with: --bench-compare <label> <label>)"
}

pval() { # file key -> first number on matching line
	grep -F "$2" "$1" | head -1 | grep -oE '[0-9.]+' | head -1
}

bench_compare() { # --bench-compare A B
	local a="$HOME/phone-bench-$1.txt" b="$HOME/phone-bench-$2.txt"
	[ -f "$a" ] || { echo "missing $a (run: --bench $1 first)"; exit 1; }
	[ -f "$b" ] || { echo "missing $b (run: --bench $2 first)"; exit 1; }
	printf '%-22s %14s %14s %14s\n' metric "$1" "$2" "delta($2-$1)"
	for m in "MemAvailable:" "MemFree:" "Cached:" "packages installed:" "running processes:" "load:"; do
		local x y
		x="$(pval "$a" "$m")"; y="$(pval "$b" "$m")"
		local d=""
		[ -n "$x" ] && [ -n "$y" ] && d="$(echo "$y $x" | awk '{printf "%.2f", $1-$2}')"
		printf '%-22s %14s %14s %14s\n' "${m%:}" "$x" "$y" "$d"
	done
	echo "(higher MemAvailable/MemFree/Cached = better; lower processes/packages/load = better)"
}

if [ "$bench_compare" = 1 ]; then
	bench_compare "$bench_a" "$bench_b"
	exit 0
fi
if [ "$bench_mode" = 1 ]; then
	bench "${bench_label:-snapshot}"
	exit 0
fi
if [ "$samsung_mode" = 1 ]; then
	samsung_list
	exit 0
fi
if [ "$check_mode" = 1 ]; then
	privacy_check
	exit 0
fi
if [ "$verify_mode" = 1 ]; then
	verify_sigs
	exit 0
fi

if [ "$scan" = 1 ]; then
	scan
	exit 0
fi

echo "tier $tier debloat:"
if [ "$tier" -ge 1 ]; then
	echo "google:"
	disable "${google[@]}"
	echo "samsung:"
	disable "${samsung[@]}"
fi
if [ "$tier" -ge 2 ]; then
	echo "samsung deep-clean:"
	disable "${samsung_deep[@]}"
	echo "google deep-clean:"
	disable "${google_deep[@]}"
fi
if [ "$tier" -ge 3 ]; then
	echo "tier 3 extras:"
	disable "${tier1[@]}"
fi

echo "foss private apps:"
tmp="$(mktemp -d)"
ask() {
	[ "$ACCEPT_ALL" = 1 ] && { echo "  [accept-all] $1: yes"; return 0; }
	[ "$YESALL" = 1 ] && { echo "  [all] $1: yes"; return 0; }
	local r
	while :; do
		printf '  %s [y/n/all] ' "$1"
		read -r r || return 1
		case "$r" in
			a|all|ALL) YESALL=1; echo "  -> yes to all"; return 0;;
			y|Y|yes|YES) return 0;;
			n|N|no|NO) return 1;;
			*) ;;
		esac
	done
}
install_apk() { # file name
	echo "    installing $2 (may take a minute)..."
	if out="$(adb install -r "$1" 2>&1)"; then
		echo "    installed $2"
	else
		err="$(printf '%s' "$out" | tr -d '\r' | grep -oE 'INSTALL_FAILED_[A-Z_]+' | head -1)"
		echo "    FAILED $2 ${err:+($err)}"
	fi
}
install_fd() { # id name
	echo "    fetching $2 from f-droid... "
	local vc
	vc="$(curl -fsSL --max-time 30 "https://f-droid.org/api/v1/packages/$1" | python3 -c 'import json,sys; print(json.load(sys.stdin)["suggestedVersionCode"])' 2>/dev/null)"
	[ -n "$vc" ] && echo "    downloading ${1}_${vc}.apk..." && curl -fsSL --progress-bar --max-time 300 -o "$tmp/$1.apk" "https://f-droid.org/repo/${1}_${vc}.apk"
	[ -f "$tmp/$1.apk" ] && install_apk "$tmp/$1.apk" "$2" || echo "    FAILED $2 (fetch)"
}
install_gh() { # repo id name [filter]
	echo "    fetching release info for $1..."
	local rel pick
	rel="$(gh api "repos/$1/releases/latest" -q '{tag: .tag_name, assets: [.assets[].name]} | @json' 2>/dev/null)"
	if [ -z "$rel" ]; then
		rel="$(curl -s --max-time 30 "https://api.github.com/repos/$1/releases/latest" | python3 -c '
import json, sys
try:
	d = json.load(sys.stdin)
	print(json.dumps({"tag": d["tag_name"], "assets": [a["name"] for a in d.get("assets", [])]}))
except Exception:
	pass' 2>/dev/null)"
	fi
	[ -z "$rel" ] && { echo "    FAILED ${4:-} (release info)"; return; }
	pick="$(printf '%s' "$rel" | python3 -c '
import json, re, sys
d = json.load(sys.stdin)
flt = sys.argv[1] if len(sys.argv) > 1 else ""
if flt.startswith("!"):
	m = [n for n in d["assets"] if n.endswith(".apk") and not re.search(flt[1:], n)]
elif flt:
	m = [n for n in d["assets"] if n.endswith(".apk") and re.search(flt, n)]
else:
	m = []
if not m:
	m = [n for n in d["assets"] if n.endswith(".apk") and re.search(r"arm64[-_]?v?8a", n)]
if not m:
	m = [n for n in d["assets"] if n.endswith(".apk") and "universal" in n]
if not m:
	m = [n for n in d["assets"] if n.endswith(".apk")]
if len(m) == 1:
	print(d["tag"] + "\n" + m[0])
else:
	sys.exit(1)
' "${4:-}")" || { echo "    FAILED ${4:-} (no matching apk)"; return; }
	local tag apk
	tag="${pick%%$'\n'*}"; apk="${pick#*$'\n'}"
	echo "    downloading $apk ($tag)..."
	if curl -fsSL --progress-bar --max-time 300 -o "$tmp/$2.apk" "https://github.com/$1/releases/download/$tag/$apk"; then
		install_apk "$tmp/$2.apk" "$3"
	else
		echo "    FAILED $3 (fetch)"
	fi
}
install_ironfox() { # arm64-v8a from custom fdroid repo
	echo "    fetching IronFox release info..."
	local apk
	apk="$(curl -s --max-time 90 https://fdroid.ironfoxoss.org/fdroid/repo/index-v1.json | python3 -c '
import json, sys
d = json.load(sys.stdin)
best = None
for v in d["packages"]["org.ironfoxoss.ironfox"]:
	nc = v.get("nativecode") or []
	if "arm64-v8a" in nc or not nc:
		if best is None or v["versionCode"] > best[0]:
			best = (v["versionCode"], v["apkName"])
if best:
	print(best[1])
else:
	sys.exit(1)
' 2>/dev/null)"
	[ -n "$apk" ] && echo "    downloading $apk..." && curl -fsSL --progress-bar --max-time 300 -o "$tmp/ironfox.apk" "https://fdroid.ironfoxoss.org/fdroid/repo/$apk"
	[ -f "$tmp/ironfox.apk" ] && install_apk "$tmp/ironfox.apk" "IronFox" || echo "    FAILED IronFox (fetch)"
}
yes_install() { # id name
	if adb shell pm path "$1" >/dev/null 2>&1; then
		echo "    $2: already installed"
		return 1
	fi
	if ask "install $2?"; then
		return 0
	fi
	return 1
}
foss_count=65
YESALL=0
echo "  $foss_count apps:"
if ask "would you like to install these FOSS private apps?"; then
	adb shell settings put global verifier_verify_adb_installs 0 >/dev/null 2>&1
	adb shell settings put global verifier_verify_installs 0 >/dev/null 2>&1
	echo "  (package verifier disabled for installs; re-enabled in settings section)"
	yes_install helium314.keyboard "HeliBoard" && install_fd helium314.keyboard "HeliBoard"
	yes_install com.fossify.phone "Fossify Phone" && install_gh FossifyOrg/Phone com.fossify.phone "Fossify Phone"
	yes_install fr.neamar.kiss "KISS Launcher" && install_fd fr.neamar.kiss "KISS Launcher"
	yes_install org.cromite.cromite "Cromite" && install_gh uazo/cromite org.cromite.cromite "Cromite" 'arm64_ChromePublic\.apk'
	yes_install org.ironfoxoss.ironfox "IronFox" && install_ironfox
	yes_install com.beemdevelopment.aegis "Aegis" && install_gh beemdevelopment/Aegis com.beemdevelopment.aegis "Aegis"
	yes_install com.kunzisoft.keepass.libre "KeePassDX" && install_fd com.kunzisoft.keepass.libre "KeePassDX"
	yes_install im.molly.app "Molly" && install_gh mollyim/mollyim-android im.molly.app "Molly"
	yes_install de.danoeh.antennapod "AntennaPod" && install_fd de.danoeh.antennapod "AntennaPod"
	yes_install com.aurora.store "Aurora Store" && install_fd com.aurora.store "Aurora Store"
	yes_install com.machiav3lli.fdroid "Neo Store" && install_gh NeoApplications/Neo-Store com.machiav3lli.fdroid "Neo Store" 'release'
	yes_install app.zhaobozhen.libre "InnerTune" && install_gh z-huang/InnerTune app.zhaobozhen.libre "InnerTune" 'foss'
	yes_install com.github.libretube "LibreTube" && install_gh libre-tube/LibreTube com.github.libretube "LibreTube"
	yes_install com.brouken.player "Just Player" && install_gh moneytoo/Player com.brouken.player "Just Player" '!legacy'
	yes_install com.junkfood.seal "Seal" && install_gh JunkFood02/Seal com.junkfood.seal "Seal"
	yes_install deckers.thibault.aves.libre "Aves Gallery" && install_gh deckerst/aves deckers.thibault.aves.libre "Aves Gallery" 'app-libre-arm64-v8a-release\.apk'
	yes_install com.fossify.contacts "Fossify Contacts" && install_gh fossifyorg/Contacts com.fossify.contacts "Fossify Contacts"
	yes_install com.fossify.calendar "Fossify Calendar" && install_gh fossifyorg/Calendar com.fossify.calendar "Fossify Calendar"
	yes_install com.fossify.clock "Fossify Clock" && install_gh fossifyorg/Clock com.fossify.clock "Fossify Clock"
	yes_install com.fossify.calculator "Fossify Calculator" && install_gh fossifyorg/Calculator com.fossify.calculator "Fossify Calculator"
	yes_install com.fossify.notes "Fossify Notes" && install_gh fossifyorg/Notes com.fossify.notes "Fossify Notes"
	yes_install net.sourceforge.opencamera "Open Camera" && install_fd net.sourceforge.opencamera "Open Camera"
	yes_install me.zhanghai.android.files "Material Files" && install_gh zhanghai/MaterialFiles me.zhanghai.android.files "Material Files" 'fdroid'
	yes_install eu.faircode.netguard "NetGuard" && install_gh M66B/NetGuard eu.faircode.netguard "NetGuard"
	yes_install app.organicmaps "Organic Maps" && install_gh organicmaps/organicmaps app.organicmaps "Organic Maps"
	yes_install com.breezyweather "Breezy Weather" && install_gh breezy-weather/breezy-weather com.breezyweather "Breezy Weather"
	yes_install ch.protonmail.android "Proton Mail" && install_gh ProtonMail/proton-mail-android ch.protonmail.android "Proton Mail"
	yes_install proton.android.pass.fdroid "Proton Pass" && install_fd proton.android.pass.fdroid "Proton Pass"
	yes_install me.proton.android.drive "Proton Drive" && install_gh ProtonDriveApps/android-drive me.proton.android.drive "Proton Drive"
	yes_install ch.protonvpn.android "Proton VPN" && install_gh ProtonVPN/android-app ch.protonvpn.android "Proton VPN"
	yes_install dev.octoshrimpy.quik.fdroid "QUIK" && install_gh quik-sms/quik dev.octoshrimpy.quik.fdroid "QUIK" 'fdroid'
	yes_install org.mozilla.thunderbird "Thunderbird" && install_gh thunderbird/thunderbird-android org.mozilla.thunderbird "Thunderbird"
	yes_install com.localsend.localsend "LocalSend" && install_gh localsend/localsend com.localsend.localsend "LocalSend" 'arm64v8'
	yes_install com.pgpony.android "PGPony" && install_fd com.pgpony.android "PGPony"
	yes_install org.eu.exodus_privacy.exodusprivacy "Exodus Privacy" && install_fd org.eu.exodus_privacy.exodusprivacy "Exodus Privacy"
	yes_install com.termux "Termux" && install_fd com.termux "Termux"
	yes_install com.valhalla.thor "Thor App Manager" && install_gh trinadhthatakula/Thor com.valhalla.thor "Thor App Manager" 'foss-release'
	yes_install org.torproject.vpn "Tor VPN" && install_fd org.torproject.vpn "Tor VPN"
	yes_install de.markusfisch.android.binaryeye "Binary Eye" && install_fd de.markusfisch.android.binaryeye "Binary Eye"
	yes_install dev.imranr.obtainium.fdroid "Obtainium" && install_fd dev.imranr.obtainium.fdroid "Obtainium"
	yes_install org.samo_lego.canta "Canta" && install_fd org.samo_lego.canta "Canta"
	yes_install com.emanuelef.remote_capture "PCAPdroid" && install_fd com.emanuelef.remote_capture "PCAPdroid"
	yes_install eu.darken.myperm "Permission Pilot" && install_fd eu.darken.myperm "Permission Pilot"
	yes_install de.seemoo.at_tracking_detection "AirGuard" && install_fd de.seemoo.at_tracking_detection "AirGuard"
	yes_install net.typeblog.shelter "Shelter" && install_fd net.typeblog.shelter "Shelter"
	yes_install org.cryptomator.lite "Cryptomator" && install_fd org.cryptomator.lite "Cryptomator"
	yes_install org.fdroid.fdroid "F-Droid" && { echo "    fetching F-Droid client..."; curl -fsSL --progress-bar --max-time 300 -o "$tmp/fdroid.apk" "https://f-droid.org/F-Droid.apk" && install_apk "$tmp/fdroid.apk" "F-Droid"; }
	yes_install com.looker.droidify "Droid-ify" && install_fd com.looker.droidify "Droid-ify"
	yes_install eu.bubu1.fdroidclassic "F-Droid Classic" && install_fd eu.bubu1.fdroidclassic "F-Droid Classic"
	yes_install app.flicky "Flicky" && install_fd app.flicky "Flicky"
	yes_install org.gdroid.gdroid "G-Droid" && install_fd org.gdroid.gdroid "G-Droid"
	yes_install in.sunilpaulmathew.izzyondroid "IzzyOnDroid" && install_fd in.sunilpaulmathew.izzyondroid "IzzyOnDroid"
	yes_install zed.rainxch.githubstore "Github Store" && install_fd zed.rainxch.githubstore "Github Store"
	yes_install app.accrescent.client "Accrescent" && install_gh accrescent/accrescent app.accrescent.client "Accrescent"
	yes_install dev.zapstore.app "Zapstore" && install_gh zapstore/zapstore dev.zapstore.app "Zapstore"
	yes_install de.jrpie.android.launcher "µLauncher" && install_fd de.jrpie.android.launcher "µLauncher"
	yes_install com.celzero.bravedns "Rethink DNS + Firewall" && install_fd com.celzero.bravedns "Rethink DNS + Firewall"
	yes_install io.github.muntashirakon.AppManager "AppManager" && install_fd io.github.muntashirakon.AppManager "AppManager"
	yes_install com.machiav3lli.backup "Neo Backup" && install_fd com.machiav3lli.backup "Neo Backup"
	yes_install com.trianguloy.urlchecker "URLCheck" && install_fd com.trianguloy.urlchecker "URLCheck"
	yes_install com.jarsilio.android.scrambledeggsif "Scrambled Exif" && install_fd com.jarsilio.android.scrambledeggsif "Scrambled Exif"
	yes_install at.bitfire.davdroid "DAVx⁵" && install_fd at.bitfire.davdroid "DAVx⁵"
	yes_install com.github.tmo1.sms_ie "SMS Import / Export" && install_fd com.github.tmo1.sms_ie "SMS Import / Export"
	yes_install com.f0x1d.logfox "LogFox" && install_fd com.f0x1d.logfox "LogFox"
	yes_install dev.clombardo.dnsnet "DNSNet" && install_fd dev.clombardo.dnsnet "DNSNet"
else
	echo "  skipped"
fi

echo "vpn kill-switch:"
if adb shell pm path ch.protonvpn.android >/dev/null 2>&1; then
	r=n
	echo -n "  enable always-on vpn (proton) + lockdown? make sure you're logged into proton first [y/n] "
	read -r r
	case "$r" in
		y|Y|yes|YES)
			adb shell settings put global always_on_vpn_package ch.protonvpn.android
			adb shell settings put global always_on_vpn_lockdown 1
			echo "  always-on vpn + lockdown enabled (blocks all non-vpn traffic)"
			;;
	esac
else
	echo "  skip (proton vpn not installed)"
fi
# manual apps (play-store only, not on f-droid): cloudflare 1.1.1.1 warp vpn (com.cloudflare.onedotonedotonedotone)

if [ "$tier" -ge 3 ]; then
	echo "tier 3 removals (dialer/keyboard swap):"
	echo "  one ui home: kept enabled, heavily restricted via app-ops"
	if ! adb shell pm path com.sec.android.app.launcher >/dev/null 2>&1; then
		adb shell cmd package install-existing --user 0 com.sec.android.app.launcher >/dev/null 2>&1
	fi
	adb shell pm enable com.sec.android.app.launcher >/dev/null 2>&1
	if adb shell pm path com.fossify.phone >/dev/null 2>&1; then
		disable com.samsung.android.dialer
	else
		echo "  skip samsung dialer (fossify phone not installed)"
	fi
	kb="$(adb shell ime list -s -a 2>/dev/null | tr -d '\r' | grep '^helium314.keyboard' | head -1)"
	if [ -n "$kb" ]; then
		disable com.samsung.android.honeyboard
		adb shell ime enable "$kb" >/dev/null 2>&1
		adb shell ime set "$kb" >/dev/null 2>&1
		echo "  default keyboard -> HeliBoard (honeyboard disabled)"
	else
		echo "  skip keyboard swap (HeliBoard not installed)"
	fi
	if adb shell pm path de.jrpie.android.launcher >/dev/null 2>&1; then
		ulauncher_act="$(adb shell cmd package resolve-activity --brief de.jrpie.android.launcher 2>/dev/null | tail -1 | tr -d '\r')"
		if [ -n "$ulauncher_act" ] && [ "$ulauncher_act" != "No activity found" ]; then
			adb shell cmd package set-home-activity "$ulauncher_act" >/dev/null 2>&1 \
				&& echo "  default launcher -> µLauncher ($ulauncher_act)" \
				|| echo "  warn: could not set µLauncher as default home"
		else
			echo "  warn: could not resolve µLauncher's launch activity"
		fi
	else
		echo "  skip default launcher swap (µLauncher not installed)"
	fi
fi

echo "settings:"
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.adguard-dns.com
adb shell settings put secure wifi_scan_always_enabled 0
adb shell settings put global wifi_scan_always_enabled 0
adb shell settings put secure bluetooth_scan_always_enabled 0
adb shell settings put global bluetooth_scan_always_enabled 0
adb shell settings put secure location_scanning_enabled 0
adb shell settings put global wifi_networks_available_notification_on 0
adb shell settings put system screen_off_timeout 60000
adb shell settings put secure lock_screen_lock_after_timeout 30000
adb shell settings put secure location_mode 0
adb shell settings put secure lock_screen_show_notifications 0
adb shell settings put secure lock_screen_allow_private_notifications 0
adb shell settings put secure auto_revoke_permissions 1
adb shell settings put global package_verifier_enable 1
adb shell settings put global verifier_verify_installs 1
adb shell settings put global verifier_verify_adb_installs 1
adb shell settings put global hide_error_dialogs 1
adb shell settings put global backup_enabled 0
adb shell settings put global adb_require_authorization 1
adb shell "settings put global bixby_pregranted_permissions ''"
adb shell "settings put global link_to_windows_pregranted_permissions ''"
adb shell "settings put global link_to_windows_service_pregranted_permissions ''"
adb shell settings put secure nearby_scanning_enabled 0
adb shell settings put secure nfc_on 0
adb shell settings put global wifi_wakeup_enabled 0
adb shell settings put global adb_wifi_enabled 0
adb shell settings put global captive_portal_detection_enabled 0
adb shell settings put global stay_on_while_plugged_in 0
# nearby share / quick share (BLE beacon advertising surface)
adb shell settings put secure nearby_sharing_enabled 0
adb shell pm disable-user --user 0 com.google.android.gms.nearby.sharing >/dev/null 2>&1
# wifi p2p auto-reset / WPS UI entry point
adb shell settings put global wifi_p2p_pending_factory_reset 0
# bluetooth discoverability (radio stays on, but not advertising/pairable by default)
adb shell settings put global bluetooth_discoverability 0
adb shell settings put global bluetooth_discoverability_timeout 0
if adb shell dumpsys wifi 2>/dev/null | tr -d '\r' | grep -q 'isMacRandomizationOn=true'; then
	echo "  mac randomization: on (default persistent per-network)"
else
	echo "  warn: mac randomization appears OFF - check Settings > Wi-Fi > network > Privacy"
fi
echo "settings applied (dns, scanning off, 60s timeout, location off, lock-screen notif hidden, verifier on, backup off, nearby-scan off, captive-portal check off, wifi-open-net-notif off, nearby-share off, bluetooth discoverability off)"

echo "gms (google play services) lockdown:"
gms_uid="$(adb shell pm list packages -U 2>/dev/null | tr -d '\r' | sed -n 's/^package:com.google.android.gms.*uid:\([0-9]*\).*/\1/p' | head -1)"
	if [ -n "$gms_uid" ]; then
		for op in CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION \
			READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG WRITE_CALL_LOG \
			READ_SMS WRITE_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION \
			READ_CLIPBOARD READ_PHONE_STATE GET_ACCOUNTS; do
			adb shell cmd appops set --uid "$gms_uid" "$op" deny >/dev/null 2>&1
		done
		adb shell cmd netpolicy add restrict-background-blacklist "$gms_uid" >/dev/null 2>&1 \
			&& echo "  background-data restricted for gms"
		echo "  denied sensitive app-ops for gms (uid $gms_uid); push/network untouched"
	else
		echo "  skip (gms not present)"
	fi

echo "play store (com.android.vending) lockdown:"
vending_uid="$(adb shell pm list packages -U 2>/dev/null | tr -d '\r' | sed -n 's/^package:com.android.vending.*uid:\([0-9]*\).*/\1/p' | head -1)"
if [ -n "$vending_uid" ]; then
	for op in CAMERA RECORD_AUDIO FINE_LOCATION COARSE_LOCATION \
		READ_CONTACTS WRITE_CONTACTS READ_SMS WRITE_SMS RECEIVE_SMS SEND_SMS; do
		adb shell cmd appops set --uid "$vending_uid" "$op" deny >/dev/null 2>&1
	done
	echo "  denied sensitive app-ops for play store (uid $vending_uid)"
else
	echo "  skip (play store not present)"
fi

echo "app-ops lockdown (extra apps):"
for entry in "${appops_deny[@]}"; do
	pkg="${entry%% *}"
	ops="${entry#* }"
	if adb shell pm path "$pkg" >/dev/null 2>&1; then
		uid="$(adb shell pm list packages -U 2>/dev/null | tr -d '\r' | sed -n "s/^package:$pkg.*uid:\\([0-9]*\\).*/\\1/p" | head -1)"
		if [ -n "$uid" ]; then
			for op in $ops; do
				adb shell cmd appops set --uid "$uid" "$op" deny >/dev/null 2>&1
			done
			echo "  denied ops for $pkg (uid $uid)"
		fi
	else
		echo "  skip $pkg (not installed)"
	fi
done

echo "play store removal:"
echo "  warn: removes play store for user 0 (aurora store remains); reversible via --reset"
if [ "$ACCEPT_ALL" = 1 ]; then
	echo "  (--accept-all does not skip this one)"
fi
echo -n "  remove play store entirely? (aurora store remains) [y/n] "
read -r r
case "$r" in
	y|Y|yes|YES)
		adb shell pm uninstall --user 0 com.android.vending >/dev/null 2>&1
		if adb shell pm path com.android.vending >/dev/null 2>&1; then
			echo "  play store removal failed (still present)"
		else
			echo "  play store removed (aurora store only)"
		fi
		;;
esac

echo "background-data restriction (netpolicy blacklist, applied only if present):"
for p in com.facebook.appmanager com.facebook.services com.facebook.system \
	com.google.android.adservices.api com.samsung.android.da.daagent \
	com.samsung.android.dqagent com.samsung.android.knox.analytics.uploader \
	com.sec.android.app.launcher; do
	np_add "$p"
done

echo "performance:"
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
adb shell settings put system screen_brightness_mode 1
adb shell settings put secure doze_pulse_on_pick_up 0
adb shell settings put secure double_tap_to_wake 0
adb shell settings put system double_tab_to_wake_up 0
adb shell settings put secure wake_gesture_enabled 0
adb shell settings put global adaptive_battery_management_enabled 1
adb shell settings put global app_standby_enabled 1
adb shell settings put secure aod_mode 0
adb shell settings put system aod_mode 0
adb shell settings put system aod_tap_to_show_mode 0
adb shell settings put system aod_show_state 0
adb shell settings put system aod_notifications 0
adb shell settings put global mobile_data_always_on 0
adb shell settings put secure screensaver_enabled 0
adb shell settings put secure nfc_on 0   # breaks NFC (e.g. YubiKey); uncomment to keep
# adb shell settings put secure haptic_feedback_enabled 0   # optional: no vibration at all
# adb shell am set-standby-bucket --user 0 com.google.android.gms restricted   # optional: may delay play updates/push
for pkg in com.samsung.android.kgclient; do
	if adb shell pm path "$pkg" >/dev/null 2>&1; then
		adb shell am set-standby-bucket --user 0 "$pkg" restricted >/dev/null 2>&1 && echo "  restricted standby: $pkg"
	fi
done
echo "performance applied (0.5x animations, auto-brightness, wake gestures off, adaptive battery, AOD off, mobile data idle)"

echo "futo keyboard:"
futo="org.futo.inputmethod.latin"
if adb shell pm path "$futo" >/dev/null 2>&1; then
	echo "  installed"
else
	echo "  fetching latest stable release info (needs curl + network)..."
	url=""
	if command -v gh >/dev/null 2>&1; then
		url="$(gh api "repos/futo-org/android-keyboard/releases?per_page=5" \
			-q '.[] | select(.prerelease == false) | .assets[] | select(.name | test("^keyboard-.*\\.apk$")) | .browser_download_url' 2>/dev/null | head -1)"
	fi
	if [ -z "$url" ] && command -v python3 >/dev/null 2>&1; then
		url="$(curl -s --max-time 30 "https://api.github.com/repos/futo-org/android-keyboard/releases?per_page=5" | python3 -c "
import json, sys
try:
	for rel in json.load(sys.stdin):
		if rel.get('prerelease'):
			continue
		for a in rel.get('assets', []):
			if a['name'].startswith('keyboard-') and a['name'].endswith('.apk'):
				print(a['browser_download_url'])
				sys.exit(0)
except Exception:
	pass
" 2>/dev/null)"
	fi
	[ -z "$url" ] && url="https://github.com/futo-org/android-keyboard/releases/download/0.1.29.1/keyboard-0.1.29.1.apk"
	tmp="$(mktemp -d)/futo.apk"
	out=""
	adb shell settings put global verifier_verify_adb_installs 0 >/dev/null 2>&1
	if curl -fsSL --progress-bar --max-time 300 -o "$tmp" "$url" && out="$(adb install -r "$tmp" 2>&1)"; then
		echo "  installed $url"
	else
		err="$(printf '%s' "$out" | tr -d '\r' | grep -oE 'INSTALL_FAILED_[A-Z_]+' | head -1)"
		echo "  install failed ${err:+($err)}"
	fi
	adb shell settings put global verifier_verify_adb_installs 1 >/dev/null 2>&1
fi
if adb shell pm path "$futo" >/dev/null 2>&1; then
	adb shell ime enable "$futo/.LatinIME" >/dev/null 2>&1
	adb shell ime set "$futo/.LatinIME" >/dev/null 2>&1
	echo "  default input method: $futo"
fi

echo "other keyboards:"
for ime in $(adb shell ime list -s 2>/dev/null | tr -d '\r'); do
	pkg="${ime%%/*}"
	case "$pkg" in
		"$futo") echo "  keep: $pkg (futo)" ;;
		*) disable "$pkg" ;;
	esac
done

if [ "$tier" -ge 3 ]; then
	echo "user picks:"
	disable "${userpicks[@]}"
fi

echo "final lock-down:"
r=n
if [ "$ACCEPT_ALL" = 1 ]; then
	r=y
else
	echo -n "  disable adb/usb debugging? (re-enable in developer options later) [y/n] "
	read -r r
fi
case "$r" in
	y|Y|yes|YES)
		adb shell settings put global adb_enabled 0
		adb shell settings put global adb_wifi_enabled 0
		adb shell settings put secure adb_wifi_enabled 0
		echo "  adb disabled"
		;;
esac

echo done
