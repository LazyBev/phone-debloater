#!/usr/bin/env bash
set -u
reset=0
ACCEPT_ALL=0
for arg in "$@"; do
	case "$arg" in
		--reset) reset=1;;
		--accept-all|-y) ACCEPT_ALL=1;;
	esac
done
keep="com.google.android.gms com.google.android.gsf com.google.android.gsf.login com.android.vending"
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
	com.samsung.android.honeyboard
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
tier2=(com.sec.android.app.launcher com.samsung.android.dialer)
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

reset() {
	echo "reset to stock:"
	echo "restore system apps:"
	restore "${google[@]}" "${samsung[@]}" "${samsung_deep[@]}" "${google_deep[@]}" "${tier1[@]}" "${userpicks[@]}" "${tier2[@]}"
	echo "remove foss apps:"
	for pkg in $(grep -oP '^\tyes_install \K\S+' "$0"); do
		adb shell pm uninstall --user 0 "$pkg" >/dev/null 2>&1 && echo "  removed: $pkg"
	done
	if adb shell pm uninstall --user 0 org.futo.inputmethod.latin >/dev/null 2>&1; then
		echo "  removed: futo keyboard"
	fi
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
		always_on_vpn_package always_on_vpn_lockdown; do
		adb shell settings delete global "$k" >/dev/null 2>&1
	done
	for k in wifi_scan_always_enabled bluetooth_scan_always_enabled lock_screen_lock_after_timeout \
		location_mode doze_pulse_on_pick_up double_tap_to_wake wake_gesture_enabled aod_mode screensaver_enabled \
		lock_screen_show_notifications lock_screen_allow_private_notifications nfc_on auto_revoke_permissions; do
		adb shell settings delete secure "$k" >/dev/null 2>&1
	done
	for k in screen_off_timeout screen_brightness_mode; do
		adb shell settings delete system "$k" >/dev/null 2>&1
	done
	adb shell am set-standby-bucket --user 0 com.samsung.android.kgclient active >/dev/null 2>&1
	adb shell cmd appops reset com.google.android.gms >/dev/null 2>&1
	echo "  defaults restored"
	if [ ${#missing_pkgs[@]} -gt 0 ]; then
		echo "not in /system (user-installed, must come from play store):"
		printf '  %s\n' "${missing_pkgs[@]}"
	fi
	echo "done"
}

adb get-state >/dev/null 2>&1 || { echo "phone not connected (adb devices)"; exit 1; }

if [ "$reset" = 1 ]; then
	reset
	exit 0
fi

echo "google:"
disable "${google[@]}"

echo "samsung:"
disable "${samsung[@]}"

echo "samsung deep-clean:"
disable "${samsung_deep[@]}"

echo "google deep-clean:"
disable "${google_deep[@]}"

echo "tier 1 (safe extras):"
disable "${tier1[@]}"

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
	if adb install -r "$1" >/dev/null 2>&1; then
		echo "    installed $2"
	else
		echo "    FAILED $2"
	fi
}
install_fd() { # id name
	local vc
	vc="$(curl -fsSL --max-time 30 "https://f-droid.org/api/v1/packages/$1" | python3 -c 'import json,sys; print(json.load(sys.stdin)["suggestedVersionCode"])' 2>/dev/null)"
	[ -n "$vc" ] && curl -sL --max-time 300 -o "$tmp/$1.apk" "https://f-droid.org/repo/${1}_${vc}.apk"
	[ -f "$tmp/$1.apk" ] && install_apk "$tmp/$1.apk" "$2" || echo "    FAILED $2 (fetch)"
}
install_gh() { # repo id name [filter]
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
	if curl -sL --max-time 300 -o "$tmp/$2.apk" "https://github.com/$1/releases/download/$tag/$apk"; then
		install_apk "$tmp/$2.apk" "$3"
	else
		echo "    FAILED $3 (fetch)"
	fi
}
install_ironfox() { # arm64-v8a from custom fdroid repo
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
	[ -n "$apk" ] && curl -sL --max-time 300 -o "$tmp/ironfox.apk" "https://fdroid.ironfoxoss.org/fdroid/repo/$apk"
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
foss_count=38
YESALL=0
echo "  $foss_count apps:"
if ask "would you like to install these FOSS private apps?"; then
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
	yes_install com.nutomic.syncthingandroid "Syncthing" && install_gh syncthing/syncthing-android com.nutomic.syncthingandroid "Syncthing"
	yes_install eu.faircode.netguard "NetGuard" && install_gh M66B/NetGuard eu.faircode.netguard "NetGuard"
	yes_install app.organicmaps "Organic Maps" && install_gh organicmaps/organicmaps app.organicmaps "Organic Maps"
	yes_install com.breezyweather "Breezy Weather" && install_gh breezy-weather/breezy-weather com.breezyweather "Breezy Weather"
	yes_install ch.protonmail.android "Proton Mail" && install_gh ProtonMail/proton-mail-android ch.protonmail.android "Proton Mail"
	yes_install proton.android.pass.fdroid "Proton Pass" && install_fd proton.android.pass.fdroid "Proton Pass"
	yes_install me.proton.android.drive "Proton Drive" && install_gh ProtonDriveApps/android-drive me.proton.android.drive "Proton Drive"
	yes_install com.protonvpn.android "Proton VPN" && install_gh ProtonVPN/android-app com.protonvpn.android "Proton VPN"
	yes_install com.moez.QKSMS "QUIK" && install_gh quik-sms/quik dev.octoshrimpy.quik.fdroid "QUIK" 'fdroid'
	yes_install org.mozilla.thunderbird "Thunderbird" && install_gh thunderbird/thunderbird-android org.mozilla.thunderbird "Thunderbird"
	yes_install com.localsend.localsend "LocalSend" && install_gh localsend/localsend com.localsend.localsend "LocalSend" 'arm64v8'
	yes_install com.pgpony.android "PGPony" && install_fd com.pgpony.android "PGPony"
	yes_install org.eu.exodus_privacy.exodusprivacy "Exodus Privacy" && install_fd org.eu.exodus_privacy.exodusprivacy "Exodus Privacy"
	yes_install com.termux "Termux" && install_gh termux/termux-app com.termux "Termux"
	yes_install com.valhalla.thor "Thor App Manager" && install_gh trinadhthatakula/Thor com.valhalla.thor "Thor App Manager" 'foss-release'
	yes_install org.torproject.vpn "Tor VPN" && install_fd org.torproject.vpn "Tor VPN"
else
	echo "  skipped"
fi

echo "vpn kill-switch:"
if adb shell pm path com.protonvpn.android >/dev/null 2>&1; then
	r=n
	if [ "$ACCEPT_ALL" = 1 ]; then
		r=y
	else
		echo -n "  enable always-on vpn (proton) + lockdown? make sure you're logged into proton first [y/n] "
		read -r r
	fi
	case "$r" in
		y|Y|yes|YES)
			adb shell settings put global always_on_vpn_package com.protonvpn.android
			adb shell settings put global always_on_vpn_lockdown 1
			echo "  always-on vpn + lockdown enabled (blocks all non-vpn traffic)"
			;;
	esac
else
	echo "  skip (proton vpn not installed)"
fi
# manual apps (play-store only, not on f-droid): cloudflare 1.1.1.1 warp vpn (com.cloudflare.onedotonedotonedotone)

echo "tier 2 (removals):"
if adb shell pm path fr.neamar.kiss >/dev/null 2>&1; then
	disable com.sec.android.app.launcher
	adb shell cmd package set-home-activity fr.neamar.kiss/fr.neamar.kiss.MainActivity >/dev/null 2>&1 || true
else
	echo "  skip One UI Home (kiss launcher not installed)"
fi
if adb shell pm path com.fossify.phone >/dev/null 2>&1; then
	disable com.samsung.android.dialer
else
	echo "  skip samsung dialer (fossify phone not installed)"
fi

echo "settings:"
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.adguard-dns.com
adb shell settings put secure wifi_scan_always_enabled 0
adb shell settings put secure bluetooth_scan_always_enabled 0
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
adb shell settings put global bixby_pregranted_permissions ""
adb shell settings put global link_to_windows_pregranted_permissions ""
adb shell settings put global link_to_windows_service_pregranted_permissions ""
echo "settings applied (dns, scanning off, 60s timeout, location off, lock-screen notif hidden, verifier on, backup off)"

echo "gms (google play services) lockdown:"
gms_uid="$(adb shell pm list packages -U 2>/dev/null | tr -d '\r' | sed -n 's/^package:com.google.android.gms.*uid:\([0-9]*\).*/\1/p' | head -1)"
if [ -n "$gms_uid" ]; then
	for op in CAMERA RECORD_AUDIO ACCESS_FINE_LOCATION ACCESS_COARSE_LOCATION \
		READ_CONTACTS WRITE_CONTACTS READ_CALL_LOG WRITE_CALL_LOG \
		READ_SMS WRITE_SMS RECEIVE_SMS SEND_SMS BODY_SENSORS ACTIVITY_RECOGNITION; do
		adb shell cmd appops set --uid "$gms_uid" "$op" deny >/dev/null 2>&1
	done
	echo "  denied sensitive app-ops for gms (uid $gms_uid); push/network untouched"
else
	echo "  skip (gms not present)"
fi

echo "performance:"
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
adb shell settings put system screen_brightness_mode 1
adb shell settings put secure doze_pulse_on_pick_up 0
adb shell settings put secure double_tap_to_wake 0
adb shell settings put secure wake_gesture_enabled 0
adb shell settings put global adaptive_battery_management_enabled 1
adb shell settings put global app_standby_enabled 1
adb shell settings put secure aod_mode 0
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
	if curl -sL --max-time 300 -o "$tmp" "$url" && adb install -r "$tmp"; then
		echo "  installed $url"
	else
		echo "  install failed"
	fi
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

echo "user picks:"
disable "${userpicks[@]}"

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
