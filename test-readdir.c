#include <assert.h>
#include <stdio.h>

#include <uv.h>

uv_dir_t    dir_handle;
uv_dirent_t dir_entry;
uv_fs_t     req;

static void close_cb(uv_handle_t* handle) {
  uv_dir_t* closed_handle = (uv_dir_t*)handle;
  assert(&dir_handle == closed_handle);
}

static void readdir_cb(uv_fs_t* req) {
  assert(req->ptr == &dir_entry);
  assert(req->dir_handle == &dir_handle);

  if (req->result == UV_EOF) {
    uv_close((uv_handle_t*)&dir_handle, close_cb);
  } else {
    printf("%s\n", ((uv_dirent_t*)req->ptr)->name);

    uv_fs_readdir(uv_default_loop(),
                  req,
                  &dir_handle,
                  &dir_entry,
                  readdir_cb);
  }

  uv_fs_req_cleanup(req);
}

static void opendir_cb(uv_fs_t* req) {
  assert(req->ptr == &dir_handle);

  uv_fs_readdir(uv_default_loop(),
                req,
                &dir_handle,
                &dir_entry,
                readdir_cb);

  uv_fs_req_cleanup(req);
}

int main(int argc, char* argv[]) {

  uv_fs_opendir(uv_default_loop(),
    &req,
    &dir_handle,
    argv[1],
    UV_DIR_FLAGS_NONE,
    opendir_cb);

  uv_run(uv_default_loop(), UV_RUN_DEFAULT);

  return 0;
}
