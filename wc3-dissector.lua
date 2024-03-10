-- trivial protocol example
-- declare our protocol
trivial_proto = Proto("WC3GAME","Warcraft III Game")
-- create a function to dissect it
function trivial_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "WC3GAME"
    local subtree = tree:add(trivial_proto,buffer(),"Warcraft III Game Data")
    subtree:add(buffer(0,1),"Magic: 0x" .. buffer(0,1):bytes():tohex())
    subtree:add(buffer(1,1),"OPcode: 0x" .. buffer(1,1):bytes():tohex())
    subtree:add(buffer(2,2),"Length: 0x" .. buffer(2,2):bytes():tohex())
end
-- load the udp.port table
udp_table = DissectorTable.get("udp.port")
-- register our protocol to handle udp port 6112
udp_table:add(6112,trivial_proto)