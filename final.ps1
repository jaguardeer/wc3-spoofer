# Ping game host with game query packet 0x2F

using namespace System.Net
using namespace System.Net.Sockets




#function calcChecksum($buffer){
#	$buffer
#}
#calcChecksum(123)


# todo - pass this as args or smth
$host_ip_str = '192.168.200.1'
[int] $game_host_port = 6112

# create game host endpoint
$game_host_ip = [IPAddress]::Parse($host_ip_str)
$game_host_endpoint = New-Object IPEndpoint $game_host_ip, $game_host_port

# generate game query datagram
$game_query_str = 'f72f1000505833571d00000000000000'
[byte[]] $game_query_datagram = [byte[]] -split ($game_query_str -replace '..', '0x$& ')

# create socket, send game query
$game_query_socket = New-Object Socket( [AddressFamily]::InterNetwork, [SocketType]::Dgram, [ProtocolType]::UDP)
$game_query_socket.Connect($game_host_endpoint)
$null = $game_query_socket.Send($game_query_datagram)

# receive reply
$query_reply = New-Object byte[] 512
$query_reply_length = $game_query_socket.Receive($query_reply)
$query_reply = $query_reply[0..($query_reply_length - 1)]

# $query_reply | Format-Hex


# Create UDP packet

# udp header
$src_port = 6112
$dst_port = 6112
$length = $query_reply_length + 8
$checksum = 0

$udp_header = [byte[]] -split ((($src_port, $dst_port, $length, $checksum | % {$_.ToString('x4')}) -join '') -replace '..', '0x$& ')

$final_packet = $udp_header + $query_reply[0..($query_reply_length - 1)]
# $final_packet | Format-Hex

# $final_packet.Length


# send packet on interfaces

$wg_interface = 'wg0'
# create socket for wireguard interface
$wg_local_ip = (Get-NetIPAddress | ? InterfaceAlias -eq $wg_interface).IPAddress
$wg_ep = New-Object IPEndpoint ([IPAddress]::Parse($wg_local_ip), 0)
# use raw socket to spoof port
$raw_sock = New-Object Socket ([AddressFamily]::InterNetwork, [SocketType]::Raw, [ProtocolType]::Udp)
#$raw_sock.Bind($wg_ep)

# get wireguard peers
$wg_peer_ips = (wg show $wg_interface | ss '(?<=allowed ips: )\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}').Matches
$wg_peer_ips += "192.168.203.32" # for BigMan
#$wg_peer_ips

# send packet to each peer
$peer_eps = $wg_peer_ips | % {New-Object IPEndpoint ([IPAddress]::Parse($_), $wc3_port)}
$peer_eps | % {
	$peer_ep = $_
	try {
		$bytes_sent = $raw_sock.SendTo($final_packet, $peer_ep)
		"$bytes_sent bytes sent to $peer_ep"
	}
	catch {
		"Failed to send to $peer_ep"
	}
}

$raw_sock.Close()