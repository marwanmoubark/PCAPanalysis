#!/usr/bin/bash

function analyze_traffic() {
    declare pcap_file="$1"
    total_packets=$(tshark -r "$pcap_file" | wc -l)

    # HTTP packets
    http_packets=$(tshark -r "$pcap_file" -Y "http" | wc -l)
    
    # HTTPS/TLS packets
    https_packets=$(tshark -r "$pcap_file" -Y "tls" | wc -l)

    # Top 5 source IPs
    echo "----- Network Traffic Analysis Report -----"
    echo "1. Total Packets: $total_packets"
    echo "2. Protocols:"
    echo "   - HTTP: $http_packets packets"
    echo "   - HTTPS/TLS: $https_packets packets"

    echo ""
    echo "3. Top 5 Source IP Addresses:"
    tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -5 | awk '{print "   - " $2 ": " $1 " packets"}'
    echo ""
    echo "4. Top 5 Destination IP Addresses:"
    tshark -r "$pcap_file" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -5 | awk '{print "   - " $2 ": " $1 " packets"}'
    echo ""
    echo "----- End of Report -----"
}
function main () {
    declare FILEPATH="$1"
    if [ ! -f "$FILEPATH" ]; then
        echo "File $FILEPATH NOT exists"
        exit 1
    fi
    echo "FILEPATH IS : $FILEPATH"
    analyze_traffic "$FILEPATH"
}
main "$1"
