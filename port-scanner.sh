#!/bin/bash

# =============================================
# Port Scanner Utility
# Author: Ihor Kriazhev (IgorUspehov)
# GitHub: https://github.com/IgorUspehov
# Tested on: Linux Mint 21.3
# Compatible: Debian, Ubuntu, Linux Mint
# =============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "======================================"
echo "       Port Scanner Utility"
echo "======================================"
echo -e "${NC}"

TARGET=${1:-"127.0.0.1"}
MODE=${2:-"common"}

echo -e "${YELLOW}Target: ${TARGET}${NC}"
echo ""

if [ "$MODE" = "common" ]; then
  PORTS=(21 22 23 25 53 80 110 143 443 445 3306 3389 5432 6379 8080 8443 8888 9090 27017)
  echo -e "${YELLOW}Scanning common ports...${NC}"
elif [ "$MODE" = "full" ]; then
  PORTS=($(seq 1 1024))
  echo -e "${YELLOW}Scanning ports 1-1024...${NC}"
else
  PORTS=($(echo "$MODE" | tr ',' ' '))
  echo -e "${YELLOW}Scanning custom ports: ${MODE}${NC}"
fi

echo ""
OPEN=0
CLOSED=0

for PORT in "${PORTS[@]}"; do
  (echo >/dev/tcp/$TARGET/$PORT) 2>/dev/null
  if [ $? -eq 0 ]; then
    SERVICE=""
    case $PORT in
      21) SERVICE="FTP" ;;
      22) SERVICE="SSH" ;;
      23) SERVICE="Telnet" ;;
      25) SERVICE="SMTP" ;;
      53) SERVICE="DNS" ;;
      80) SERVICE="HTTP" ;;
      110) SERVICE="POP3" ;;
      143) SERVICE="IMAP" ;;
      443) SERVICE="HTTPS" ;;
      445) SERVICE="SMB" ;;
      3306) SERVICE="MySQL" ;;
      3389) SERVICE="RDP" ;;
      5432) SERVICE="PostgreSQL" ;;
      6379) SERVICE="Redis" ;;
      8080) SERVICE="HTTP-Alt" ;;
      8443) SERVICE="HTTPS-Alt" ;;
      27017) SERVICE="MongoDB" ;;
      *) SERVICE="Unknown" ;;
    esac
    echo -e "    ${GREEN}[OPEN]${NC}   Port $PORT  ${CYAN}$SERVICE${NC}"
    ((OPEN++))
  else
    ((CLOSED++))
  fi
done

echo ""
echo -e "${CYAN}======================================"
echo -e "  Scan complete!"
echo -e "  Open ports:   ${GREEN}${OPEN}${NC}"
echo -e "  Closed ports: ${RED}${CLOSED}${NC}"
echo -e "======================================${NC}"
