# BTR0BTR1
# #define CAN_BAUD_1M 0x0014 // 1 Mbit/s
# #define CAN_BAUD_500K 0x001C // 500 kBit/s
# #define CAN_BAUD_250K 0x011C // 250 kBit/s
# #define CAN_BAUD_125K 0x031C // 125 kBit/s
# #define CAN_BAUD_100K 0x432F // 100 kBit/s
# #define CAN_BAUD_50K 0x472F // 50 kBit/s
# #define CAN_BAUD_20K 0x532F // 20 kBit/s
# #define CAN_BAUD_10K 0x672F // 10 kBit/s
# #define CAN_BAUD_5K 0x7F7F // 5 kBit/s

CAN_BAUD_1M := 0x0014 # 1 Mbit/s
CAN_BAUD_500K := 0x001C # 500 kBit/s
CAN_BAUD_250K := 0x011C # 250 kBit/s
CAN_BAUD_125K := 0x031C # 125 kBit/s
CAN_BAUD_100K := 0x432F # 100 kBit/s
CAN_BAUD_50K := 0x472F # 50 kBit/s
CAN_BAUD_20K := 0x532F # 20 kBit/s
CAN_BAUD_10K := 0x672F # 10 kBit/s
CAN_BAUD_5K := 0x7F7F # 5 kBit/s

type := extended
baud := $(CAN_BAUD_250K)

send-extended-frames := -e

.PHONY: go
go \
  : hello-world-$(type).pcan \
  ; transmitest \
      -t=usb \
      $(send-$(type)-frames) \
      -b=$(baud) \
      $<

.PHONY: receive
receive\
  : \
  ; receivetest \
      -t=usb \
      $(send-$(type)-frames) \
      -b=$(baud)
