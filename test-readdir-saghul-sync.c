#include <assert.h>
#include <stdio.h>

#include <uv.h>

#define NB_ENTRIES 10

int main(int argc, char* argv[]) {
  uv_fs_t     opendir_req;
  uv_fs_t     readdir_req;
  uv_fs_t     closedir_req;

  uv_dir_t    dir;
  uv_dirent_t dirents[NB_ENTRIES];

  int nb_entries_read;

  unsigned int dirent_idx;

  uv_fs_opendir(uv_default_loop(), &opendir_req, argv[1], NULL);
  uv_fs_req_cleanup(&opendir_req);

  while ((nb_entries_read = uv_fs_readdir(uv_default_loop(),
                                          &readdir_req,
                                          opendir_req.dir,
                                          dirents,
                                          NB_ENTRIES,
                                          NULL)) > 0) {
    for (dirent_idx = 0; dirent_idx < (unsigned int)nb_entries_read; ++dirent_idx) {
      printf("%s\n", dirents[dirent_idx].name);
    }

    uv_fs_req_cleanup(&readdir_req);
  }

  uv_fs_closedir(uv_default_loop(), &closedir_req, &dir, NULL);
  uv_fs_req_cleanup(&closedir_req);

  return 0;
}
