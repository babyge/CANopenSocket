# Makefile for application with CANopenNode and Linux socketCAN
# It includes gateway with SDOclient and CO_LSSmaster


DRV_SRC = CANopenNode/socketCAN
CANOPEN_SRC = CANopenNode
APPL_SRC = .


LINK_TARGET = basicDeviceWithGateway
VERSION_FILE = CO_version.h


INCLUDE_DIRS = \
	-I$(DRV_SRC) \
	-I$(CANOPEN_SRC) \
	-I$(APPL_SRC)

#	$(DRV_SRC)/CO_OD_storage.c \

SOURCES = \
	$(DRV_SRC)/CO_driver.c \
	$(DRV_SRC)/CO_error.c \
	$(DRV_SRC)/CO_epoll_interface.c \
	$(CANOPEN_SRC)/301/CO_ODinterface.c \
	$(CANOPEN_SRC)/301/CO_NMT_Heartbeat.c \
	$(CANOPEN_SRC)/301/CO_HBconsumer.c \
	$(CANOPEN_SRC)/301/CO_Emergency.c \
	$(CANOPEN_SRC)/301/CO_SDOserver.c \
	$(CANOPEN_SRC)/301/CO_SDOclient.c \
	$(CANOPEN_SRC)/301/CO_TIME.c \
	$(CANOPEN_SRC)/301/CO_SYNC.c \
	$(CANOPEN_SRC)/301/CO_PDO.c \
	$(CANOPEN_SRC)/301/crc16-ccitt.c \
	$(CANOPEN_SRC)/301/CO_fifo.c \
	$(CANOPEN_SRC)/303/CO_LEDs.c \
	$(CANOPEN_SRC)/305/CO_LSSslave.c \
	$(CANOPEN_SRC)/305/CO_LSSmaster.c \
	$(CANOPEN_SRC)/309/CO_gateway_ascii.c \
	$(CANOPEN_SRC)/CANopen.c \
	$(APPL_SRC)/CO_application.c \
	$(APPL_SRC)/OD.c \
	$(APPL_SRC)/testingVariables.c \
	$(DRV_SRC)/CO_main_basic.c


OBJS = $(SOURCES:%.c=%.o)
CC ?= gcc
OPT = -g
#OPT = -g -pedantic -Wshadow -fanalyzer
CFLAGS = -Wall -DCO_DRIVER_CUSTOM -DCO_GATEWAY $(OPT) $(INCLUDE_DIRS)
LDFLAGS = -pthread


.PHONY: all clean

all: clean version $(LINK_TARGET)

clean:
	rm -f $(OBJS) $(LINK_TARGET) $(VERSION_FILE)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(LINK_TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

version:
	echo "#define CO_VERSION_CANOPENNODE \"$(shell git -C CANopenNode describe --tags --long --dirty)\"" > $(VERSION_FILE)
	echo "#define CO_VERSION_APPLICATION \"$(shell git describe --tags --long --dirty)\"" >> $(VERSION_FILE)
