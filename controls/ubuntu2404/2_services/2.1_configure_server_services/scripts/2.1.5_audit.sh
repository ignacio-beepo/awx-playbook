#!/usr/bin/env bash

packages=('kea')
    units=('kea-dhcp-ddns-server.service' 'kea-dhcp4-server.service' 'kea-dhcp6-server.service')
    installed=()
    enabled=()
    active=()
    for pkg in "${packages[@]}"; do
      dpkg-query -s "$pkg" >/dev/null 2>&1 && installed+=("$pkg")
    done
    for unit in "${units[@]}"; do
      state="$(systemctl is-enabled "$unit" 2>/dev/null || true)"
      active_state="$(systemctl is-active "$unit" 2>/dev/null || true)"
      [[ "$state" == "enabled" || "$state" == "enabled-runtime" || "$state" == "static" ]] && enabled+=("$unit:$state")
      [[ "$active_state" == "active" ]] && active+=("$unit")
    done
    if [ "${#installed[@]}" -eq 0 ]; then
      echo "COMPLIANT: target package(s) not installed"
    elif [ "${#enabled[@]}" -eq 0 ] && [ "${#active[@]}" -eq 0 ]; then
      echo "COMPLIANT: package installed but service(s) inactive and not enabled"
    else
      echo "NON_COMPLIANT: package/service in use"
    fi
    printf 'Installed packages: %s\\n' "${installed[*]:-none}"
    printf 'Enabled/static units: %s\\n' "${enabled[*]:-none}"
    printf 'Active units: %s\\n' "${active[*]:-none}"

	exit 0