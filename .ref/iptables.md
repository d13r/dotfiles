Block an IP:

    iptables -A INPUT -s 1.2.3.4 -j REJECT -m comment --comment 'Reason here'

Block a range:

    iptables -A INPUT -s 1.2.3.0/24 -j REJECT -m comment --comment 'Reason here'

List rules:

    iptables -L INPUT --line-numbers

Delete a rule:

    iptables -D INPUT 123
