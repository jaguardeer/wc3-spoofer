### 
#  Start of Script 
## 

# Define port and target IP address 
# Random here! 
[int] $Port = 6112 
$IP = "127.0.0.1" 
$Address = [system.net.IPAddress]::Parse($IP)

# Create IP Endpoint 
$End = New-Object System.Net.IPEndPoint $address, $port 

# Create Socket 
$Saddrf   = [System.Net.Sockets.AddressFamily]::InterNetwork 
$Stype    = [System.Net.Sockets.SocketType]::Dgram 
$Ptype    = [System.Net.Sockets.ProtocolType]::UDP 
$Sock     = New-Object System.Net.Sockets.Socket $saddrf, $stype, $ptype 
$Sock.TTL = 26

# Connect to socket 
$sock.Connect($end) 

# Create encoded buffer
$Data = 'f730a000505833571d00000001000000269782004c6f63616c2047616d6520284a616775617244656572290000810349070101d501bd71012dddbd374ddb6171732f456f77d96f6d6f61652f473f616961734f5351b7475f77315f33451b312f773379014b9f6167756173456563657301018b27bf7f0d29a36b7721796df7618785d53bef0b7ff9e700070000000100000001000000060000007c010000e017'

$Buffer  = [byte[]] -split ($Data -replace '..', '0x$& ')

# Send the buffer 
$Sent   = $Sock.Send($Buffer) 
"{0} characters sent to: {1} " -f $Sent,$IP
# End of Script 



