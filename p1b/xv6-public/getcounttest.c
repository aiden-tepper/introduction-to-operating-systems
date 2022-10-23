#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[]) {
   // printf(1, (char) getcount());
    int ret = trace((char*) 0xA000);
    printf(1, "%d\n", ret);
    // open("testopen", 0);
   // printf(1, getcount());
    exit();
}
