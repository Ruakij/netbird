package netbird

import future.keywords.if
import future.keywords.in
import future.keywords.contains

# get_rule builds a netbird rule object from given parameters
get_rule(peer_id, direction, action, port) := rule if {
    peer := input.peers[_]
    peer.ID == peer_id
    rule := {
        "ID": peer.ID,
        "IP": peer.IP,
        "Direction": direction,
        "Action": action,
        "Port": port,
    }
}

# peers_from_group returns a list of peer ids for a given group id
peers_from_group(group_id) := peers if {
	group := input.groups[_]
	group.ID == group_id
	peers := [peer | peer := group.Peers[_]]
}

# netbird_rules_from_groups returns a list of netbird rules for a given list of group names
rules_from_groups(groups, direction, action, port) := rules if {
	group_id := groups[_]
	rules := [get_rule(peer, direction, action, port) | peer := peers_from_group(group_id)[_]]
}

# is_peer_in_any_group checks that input peer present at least in one group
is_peer_in_any_group(groups) := count([group_id]) > 0 if {
	group_id := groups[_]
	group := input.groups[_]
	group.ID == group_id
	peer := group.Peers[_]
	peer == input.peer_id
}
