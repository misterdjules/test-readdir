BUILD_DIR=./out

READDIR_SOURCES = test-readdir.c
READDIR_OBJECTS = $(subst .c,.o,$(READDIR_SOURCES))

READDIR_SYNC_SOURCES = test-readdir-sync.c
READDIR_SYNC_OBJECTS = $(subst .c,.o,$(READDIR_SYNC_SOURCES))

READDIR_SAGHUL_SOURCES = test-readdir-saghul.c
READDIR_SAGHUL_OBJECTS = $(subst .c,.o,$(READDIR_SAGHUL_SOURCES))

SCANDIR_SOURCES = test-scandir.c
SCANDIR_OBJECTS = $(subst .c,.o,$(SCANDIR_SOURCES))

LIBUV_DIR=/Users/JulienGilli/dev/libuv

CFLAGS = -I$(LIBUV_DIR)/include -O0 -g -Wall -Wextra
LDFLAGS = $(LIBUV_DIR)/out/Debug/libuv.a

all: $(BUILD_DIR) test-readdir test-readdir-sync test-readdir-saghul test-scandir

clean:
	$(RM) -r $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $@

.c.o:
	$(CC) $(CFLAGS) -c $? -o $(addprefix $(BUILD_DIR)/,$@)

test-readdir: $(READDIR_OBJECTS)
	$(CC) $(addprefix $(BUILD_DIR)/,$?) -o $(BUILD_DIR)/$@ $(LDFLAGS)

test-readdir-sync: $(READDIR_SYNC_OBJECTS)
	$(CC) $(addprefix $(BUILD_DIR)/,$?) -o $(BUILD_DIR)/$@ $(LDFLAGS)

test-readdir-saghul: $(READDIR_SAGHUL_OBJECTS)
	$(CC) $(addprefix $(BUILD_DIR)/,$?) -o $(BUILD_DIR)/$@ $(LDFLAGS)

test-scandir: $(SCANDIR_OBJECTS)
	$(CC) $(addprefix $(BUILD_DIR)/,$?) -o $(BUILD_DIR)/$@ $(LDFLAGS)
