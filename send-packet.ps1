### 
#  Start of Script 
## 

# Define port and target IP address 
# Random here! 
[int] $Port = 6112
$IP = "192.168.200.6" 
$Address = [system.net.IPAddress]::Parse($IP)

# Create IP Endpoint 
$End = New-Object System.Net.IPEndPoint $address, $port 

# Create Socket 
$Stype    = [System.Net.Sockets.SocketType]::Raw 
$Ptype    = [System.Net.Sockets.ProtocolType]::Udp
$Sock     = New-Object System.Net.Sockets.Socket $stype, $ptype 
$Sock.TTL = 26

$LocalIP = [system.net.IPAddress]::Parse("192.168.200.1")
$LocalEP = New-Object System.Net.IPEndPoint $LocalIP, 0
$Sock.Bind($LocalEP)

# Connect to socket 
$Sock.Connect($end)

# Create encoded buffer
$Data = '17e017e000a4f2b5f7309c00505833571d00000008000000fc923a014c6f63616c2047616d6520284a6167756172446565722900000103490701019501d99501179987434dfb6171732f536365756f6173696f2f295d35295761734369af61736573732f77e7336d014b616775336173456565730165017f99f113a99d6533fb11817dd51fc5977db1ab334f29000500000009000000010000000400000008000000e017'

$Buffer  = [byte[]] -split ($Data -replace '..', '0x$& ')

# Send the buffer 
$Sent = $Sock.Send($Buffer) 
"{0} characters sent to: {1} " -f $Sent,$IP
# End of Script 

# original
# udp 17e017e00018d8bcf72f1000505833571d00000000000000
# ip src 169.254.165.99  == a9fea563
# ip dst 255.255.255.255 == ffffffff


# modified
# ip src 127.0.0.1 = 7f000001
# ip dst 127.0.0.1 = 7f000001

# diff
# high src orig = a9fe
# high src modi = 7f00
#  low src orig = a563
#  low src modi = 0001

# high src diff = 2afe
#  low src diff = a562

# high dst orig = ffff
# high dst modi = 7f00
#  low dst orig = ffff
#  low dst modi = 0001

# high dst diff = 80ff
#  low dst diff = fffe

# checksum orig = d8bc
# checksum modi = 32a19 = 2a1c