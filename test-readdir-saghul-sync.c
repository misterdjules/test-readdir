#include <assert.h>
#include <stdio.h>

#include <uv.h>

int main(int argc, char* argv[]) {
  uv_fs_t     req;
  uv_dir_t    dir_handle;
  uv_dirent_t dir_entry;

  uv_fs_opendir(uv_default_loop(),
    &req,
    &dir_handle,
    argv[1],
    UV_DIR_FLAGS_NONE,
    NULL);

  while (uv_fs_readdir(uv_default_loop(),
                       &req,
                       &dir_handle,
                       &dir_entry,
                       NULL) != UV_EOF) {
    printf("%s\n", dir_entry.name);
  }

  uv_fs_closedir(uv_default_loop(), &req, &dir_handle, NULL);

  return 0;
}
