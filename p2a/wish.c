#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>

void my_exit(char *args[]) {
    exit(0);
}

void my_cd(char *args[]) {
    printf("cd!\n");
}

void my_path(char *args[]) {
    printf("path!\n");
}

void (*builtins[]) (char **) = {
  &my_exit,
  &my_cd,
  &my_path
};


char *const builtins_list[3] = {
    "exit\n",
    "cd\n",
    "path\n"
};

void execute_program(char *args[]) {
    char *path = malloc(5 + sizeof(char*));
    strcpy(path, "/bin/");
    strcat(path, args[0]);

    pid_t pid = fork();

    if(pid == 0) {
        int ret = execv(path, args);
        printf("Fails to execute %s\n", args[0]);
        exit(1);
    }

    int status;
    waitpid(pid, &status, 0);

    free(path);
}

void execute(char *args[]) {
    int builtin = 0;
    for(int i = 0; i < 3; i++) {
        if(strcmp(args[0], builtins_list[i]) == 0) {
            (*builtins[i])(args);
            builtin = 1;
        }
    }
    
    if(!builtin)
        execute_program(args);
}

char **parse_input(char *input) {
    char **tokens = malloc(256 * sizeof(char*));
    char *token;
    int index = 0;

    token = strtok(input, " ");
    while(token != NULL) {
        tokens[index++] = token;
        token = strtok(NULL, " \n");
    }

    tokens[index] = NULL;
    return tokens;
}

char *read_input() {
    char *buffer;
    size_t bufsize = 256;
    size_t characters;
    buffer = (char *)malloc(bufsize * sizeof(char));
    characters = getline(&buffer, &bufsize, stdin);

    return buffer;
}

int main(int argc, char *argv[]) {

    char *input;
    char **args;

    while(1) {
        printf("wish> ");
        input = read_input();
        args = parse_input(input);
        execute(args);

        free(input);
        free(args);
    }
}