#include <stdio.h>

#include <uv.h>

uv_dirent_t dent;

static void scandir_cb(uv_fs_t* req) {
  if (req) {
    while (UV_EOF != uv_fs_scandir_next(req, &dent)) {
      printf("dent: %s\n", dent.name);
    }
  }
}

int main(int argc, char* argv[]) {
  uv_loop_t* loop = uv_default_loop();
  int r = -1;
  uv_fs_t scandir_req;

  r = uv_fs_scandir(loop, &scandir_req, argv[1], 0, scandir_cb);
  if (r) {
    fprintf(stderr, "Error when calling uv_fs_scandir: %s\n", uv_strerror(r));
  }

  uv_run(loop, UV_RUN_DEFAULT);

  return 0;
}
