### 
#  Start of Script 
## 

# Define port and target IP address 
# Random here! 
[int] $Port = 6112 
$IP = "192.168.222.1" 
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
[byte[]] $Message = 0xf7, 0x2f, 0x10, 0x00, 0x50, 0x58, 0x33, 0x57, 0x1d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
$Buffer  = $Message

# Send the buffer 
$Sent   = $Sock.Send($Buffer) 
"{0} characters sent to: {1} " -f $Sent,$IP
# End of Script 



