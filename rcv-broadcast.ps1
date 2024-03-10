### 
#  Start of Script 
## 

# Listen on 6112
# Endpoint
[int] $port = 6112
$address = [system.net.IPAddress]::Loopback
$localEP = New-Object System.Net.IPEndPoint $address, $port 
# Socket 
$sType    = [System.Net.Sockets.SocketType]::Dgram 
$pType    = [System.Net.Sockets.ProtocolType]::Udp
$sock     = New-Object System.Net.Sockets.Socket $sType, $pType
# bind
$sock.ReceiveTimeout = 10000
$sock.EnableBroadcast = $true


$sock.Bind($localEP)

# listen


#
$remoteIP = [System.Net.IPAddress]::Any
$remoteEP = New-Object System.Net.IPEndPoint $remoteIP, $port

$msgBuf = New-Object Byte[] 256

$sock.ReceiveFrom($msgBuf, 0, 256, [System.Net.Sockets.SocketFlags]::Broadcast, [ref] $remoteEP)

$msgBuf | Format-Hex

$sock.Close()