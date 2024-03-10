# Goal is to find packets outgoing to 255.255.255.255 and duplicate them towards a unicast address.

using namespace system.net.sockets

[int] $listenPort = 0
$listenIP = [ipaddress]::Any

$localEP = New-Object IPEndPoint $listenIP, $listenPort

## Create socket
$udpSocketArgs = (
	[AddressFamily]::InterNetwork,
	[SocketType]::Dgram,
	[ProtocolType]::UDP
)

$localSock = New-Object Socket $udpSocketArgs

$localSock.bind($localEP)

$remoteIP = [IPAddress]::Any
$remotePort = [int] 6112
$remoteEP = New-Object IPEndPoint $remoteIP, $remotePort

Sleep 30

$msg = New-Object Byte[] 256
#$localSock.ReceiveFrom($msg, $msg.Length, [SocketFlags]::None, [ref] $remoteEP)

#$msg