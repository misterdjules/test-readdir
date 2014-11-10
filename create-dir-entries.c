#include <assert.h>
#include <stdio.h>

#include <uv.h>

int main(int argc, char* argv[]) {
  char pattern[128] = {0};
  char buff[128] = {0};
  size_t nb_entries = 10000000;
  size_t start_offset = 0;
  size_t index = 0;

  int r;
  uv_loop_t* loop;
  uv_fs_t open_req;
  uv_fs_t close_req;

  loop = uv_default_loop();

  strcpy(pattern, argv[1]);
  strcat(pattern, "/%d");
  printf("pattern: %s\n", pattern);

  for (index = start_offset; index < nb_entries; ++index) {
    sprintf(buff, pattern, index);
    //printf("Creating filename: %s\n...", buff);

    r = uv_fs_open(loop, &open_req, buff, O_WRONLY | O_CREAT,
                   S_IWUSR | S_IRUSR, NULL);
    assert(r >= 0);

    uv_fs_req_cleanup(&open_req);

    r = uv_fs_close(loop, &close_req, open_req.result, NULL);
    assert(r == 0);

    uv_fs_req_cleanup(&close_req);
    //printf("Done!\n");

    memset(buff, 0, sizeof(buff));
  }

}
