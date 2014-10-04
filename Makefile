BUILD_DIR=./out

READDIR_SOURCES = test-readdir.c
READDIR_OBJECTS = $(subst .c,.o,$(READDIR_SOURCES))

SCANDIR_SOURCES = test-scandir.c
SCANDIR_OBJECTS = $(subst .c,.o,$(SCANDIR_SOURCES))

LIBUV_DIR=/Users/JulienGilli/dev/libuv

CFLAGS = -I$(LIBUV_DIR)/include -O0 -g
LDFLAGS = $(LIBUV_DIR)/out/Debug/libuv.a

all: $(BUILD_DIR) test-readdir test-scandir

$(BUILD_DIR):
	mkdir -p $@

.c.o:
	$(CC) $(CFLAGS) -c $? -o $(addprefix $(BUILD_DIR)/,$@)

test-readdir: $(READDIR_OBJECTS)
	$(CC) $(addprefix $(BUILD_DIR)/,$?) -o $(BUILD_DIR)/$@ $(LDFLAGS)

test-scandir: $(SCANDIR_OBJECTS)
	$(CC) $(addprefix $(BUILD_DIR)/,$?) -o $(BUILD_DIR)/$@ $(LDFLAGS)
