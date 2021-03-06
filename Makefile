
PLATFORM=$(shell uname)
BUILD_DIR=./out

READDIR_SOURCES = test-readdir.c
READDIR_OBJECTS = $(subst .c,.o,$(READDIR_SOURCES))

READDIR_SYNC_SOURCES = test-readdir-sync.c
READDIR_SYNC_OBJECTS = $(subst .c,.o,$(READDIR_SYNC_SOURCES))

READDIR_SAGHUL_SOURCES = test-readdir-saghul.c
READDIR_SAGHUL_OBJECTS = $(subst .c,.o,$(READDIR_SAGHUL_SOURCES))

READDIR_SAGHUL_SYNC_SOURCES = test-readdir-saghul-sync.c
READDIR_SAGHUL_SYNC_OBJECTS = $(subst .c,.o,$(READDIR_SAGHUL_SYNC_SOURCES))

SCANDIR_SOURCES = test-scandir.c
SCANDIR_OBJECTS = $(subst .c,.o,$(SCANDIR_SOURCES))

IDLE_SOURCES = test-idle.c
IDLE_OBJECTS = $(subst .c,.o,$(IDLE_SOURCES))

CREATE_DIR_ENTRIES_SOURCES = create-dir-entries.c
CREATE_DIR_ENTRIES_OBJECTS = $(subst .c,.o,$(CREATE_DIR_ENTRIES_SOURCES))

ifndef LIBUV_DIR
$(error Please set LIBUV_DIR to a directory that contains a version of libuv \
 that has been built *with autotools*)
endif

#CFLAGS=-I $(LIBUV_DIR)/include -O0 -g -Wall -Wextra
CFLAGS=-I $(LIBUV_DIR)/include -O2 -Wall -Wextra
#LDFLAGS=$(LIBUV_DIR)/.libs/libuv.a
LDFLAGS=$(LIBUV_DIR)/.libs/libuv.a -O2

ifeq ($(PLATFORM),SunOS)
	LDFLAGS+=-lkstat -lnsl -lsendfile -lsocket -lpthread
endif
ifeq ($(PLATFORM),Linux)
	LDFLAGS+=-lpthread -lrt
endif

all: $(BUILD_DIR) test-readdir test-readdir-sync test-readdir-saghul test-scandir test-idle

clean:
	$(RM) -r $(READDIR_OBJECTS) $(READDIR_SYNC_OBJECTS) \
	$(READDIR_SAGHUL_OBJECTS) $(READDIR_SAGHUL_SYNC_OBJECTS) $(SCANDIR_OBJECTS)

$(BUILD_DIR):
	mkdir -p $@

.c.o:
	$(CC) $(CFLAGS) -c $? -o $@

test-readdir: $(READDIR_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)

test-readdir-sync: $(READDIR_SYNC_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)

test-readdir-saghul: $(READDIR_SAGHUL_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)

test-readdir-saghul-sync: $(READDIR_SAGHUL_SYNC_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)

test-scandir: $(SCANDIR_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)

test-idle: $(IDLE_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)

create-dir-entries: $(CREATE_DIR_ENTRIES_OBJECTS)
	$(CC) $? -o $@ $(LDFLAGS)
