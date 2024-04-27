#!/bin/bash
# Generate 52 Emails ranging from 51 hours ago to now

FRUIT=(apple banana cherry damson elderberry fig guava hawthorn ilama jackfruit kumquat lemon mango nectarine olive papaya quince raspberry strawberry tangerine ugli vanilla wolfberry xigua yew ziziphus)

DATE_FMT1="+%a %b %d %H:%M:%S %Y"
DATE_FMT2="+%a, %d %b %Y %H:%M:%S %z (%Z)"

NUM=$((${#FRUIT[@]}*2 - 1))

for fruit in "${FRUIT[@]}" "${FRUIT[@]}"; do
	DATE1=$(date -d "$NUM hours ago" "$DATE_FMT1")
	DATE2=$(date -d "$NUM hours ago" "$DATE_FMT2")

	cat <<-EOF
		From ${fruit}@example.com ${DATE1}
		From: ${fruit} <${fruit}@example.com>
		To: rich@example.com
		Subject: ${fruit@u} ${fruit} ${fruit}
		Date: ${DATE2}
		Status: RO

		message ${fruit}

	EOF

	: $((NUM--))
done

