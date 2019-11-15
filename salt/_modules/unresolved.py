# -*- coding: utf-8 -*-
"""
"""

from __future__ import absolute_import
import socket


def addresses():
    """
    """
    failing = []
    for protocol in ['ipv4', 'ipv6']:
        for address in __salt__['grains.get'](protocol):
            try:
                socket.gethostbyaddr(address)
            except:
                failing.append(address)
    if failing:
        return ("These addresses are not resolving:\n" + "\n".join(failing) +
                "\nConsider adding these to /etc/hosts as a workaround\n" +
                "And yes, Salt should ignore fe80 addresses\n")

    return ""
