
#!/usr/bin/env bash

a_output=()
a_output2=()
a_port_list=("25" "465" "587")

for l_port_number in "${a_port_list[@]}"; do
    if ss -plntu 2>/dev/null |
       grep -P -- ':'"$l_port_number"'\b' |
       grep -Pvq -- '\h+(127\.0\.0\.1|\[?::1\]?):'"$l_port_number"'\b'; then

        a_output2+=("Port $l_port_number is listening on a non-loopback interface")
    else
        a_output+=("Port $l_port_number is not listening on a non-loopback interface")
    fi
done

l_interfaces=""

if command -v postconf >/dev/null 2>&1; then
    l_interfaces="$(postconf -h inet_interfaces 2>/dev/null)"
elif command -v exim >/dev/null 2>&1; then
    l_interfaces="$(exim -bP local_interfaces 2>/dev/null)"
elif command -v sendmail >/dev/null 2>&1; then
    l_interfaces="$(grep -i 'O DaemonPortOptions=' /etc/mail/sendmail.cf 2>/dev/null |
        grep -oP '(?<=Addr=)[^,+]+' |
        grep -v '^127\.0\.0\.1$' || true)"
fi

if [ -n "$l_interfaces" ]; then
    if grep -Pqi '\ball\b' <<< "$l_interfaces"; then
        a_output2+=("MTA is bound to all network interfaces: $l_interfaces")
    elif ! grep -Pqi '(inet_interfaces\s*=\s*)?(127\.0\.0\.1|::1|loopback-only)' <<< "$l_interfaces"; then
        a_output2+=("MTA interface binding requires review: $l_interfaces")
    fi
else
    a_output+=("MTA not detected or not in use")
fi

if [ "${#a_output2[@]}" -eq 0 ]; then
    echo "COMPLIANT"
    printf '%s\n' "${a_output[@]}"
else
    echo "NON_COMPLIANT"
    printf '%s\n' "${a_output2[@]}"
    printf '%s\n' "${a_output[@]}"
fi

exit 0
