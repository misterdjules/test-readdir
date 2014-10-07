#include <assert.h>
#include <stdio.h>

#include <uv.h>

uv_dir_t    dir_handle;
uv_dirent_t dir_entry;

static void closedir_cb(uv_fs_t* req) {
}

static void readdir_cb(uv_fs_t* readdir_req) {
  assert(readdir_req->ptr == &dir_entry);
  assert(readdir_req->dir_handle == &dir_handle);

  if (readdir_req->result == UV_EOF) {
    uv_fs_closedir(uv_default_loop(), readdir_req, &dir_handle, closedir_cb);
  } else {
    printf("%s\n", ((uv_dirent_t*)readdir_req->ptr)->name);
    uv_fs_readdir(uv_default_loop(),
      readdir_req,
      &dir_handle,
      &dir_entry,
      readdir_cb);
  }
}

static void opendir_cb(uv_fs_t* opendir_req) {
  assert(opendir_req->ptr == &dir_handle);
  uv_fs_readdir(uv_default_loop(),
                opendir_req,
                opendir_req->ptr,
                &dir_entry,
                readdir_cb);
}

int main(int argc, char* argv[]) {
  uv_fs_t opendir_req;

  uv_fs_opendir(uv_default_loop(),
    &opendir_req,
    &dir_handle,
    argv[1],
    UV_DIR_FLAGS_NONE,
    opendir_cb);

  uv_run(uv_default_loop(), UV_RUN_DEFAULT);

  return 0;
}
