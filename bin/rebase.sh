#/bin/bash

set -o errexit	# set -e
set -o nounset	# set -u

IFS=$'\n'

HIGH=0
LOW=2000000000

EMAILS=()
ALL_FILES=($(find . -type f | sort))

for i in ${ALL_FILES[*]}; do
	if [[ "$i" =~ .*/([[:digit:]]{10})[.] ]]; then
		DATE="${BASH_REMATCH[1]}"
		[ $DATE -gt $HIGH ] && HIGH=$DATE
		[ $DATE -lt $LOW  ] && LOW=$DATE
		EMAILS+=($i)
	fi
done

NOW=$(date '+%s')

echo "Range: $LOW - $HIGH"
echo "Now:   $NOW"

REBASE=$((NOW - HIGH))

echo "Rebasing ${#EMAILS[*]} emails by $((REBASE / 86400)) days"

for i in ${EMAILS[*]}; do
	if [[ "$i" =~ (.*/)([[:digit:]]{10})([.].*) ]]; then
		START="${BASH_REMATCH[1]}"
		DATE="${BASH_REMATCH[2]}"
		END="${BASH_REMATCH[3]}"

		NEW_DATE=$((DATE + REBASE))
		DATE_STR="$(date -d "@$NEW_DATE" "+%a, %d %b %Y %H:%M:%S %z (%Z)")"
		sed -i "s/^Date: .*/Date: $DATE_STR/" "$i"
		git mv "$i" "$START$NEW_DATE$END"
	fi
done

