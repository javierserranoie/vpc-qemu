#!/usr/bin/env bash
iptables-save >/etc/iptables/iptables.rules
systemctl enable iptables
systemctl restart iptables
