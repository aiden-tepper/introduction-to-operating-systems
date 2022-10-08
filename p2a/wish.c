#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>

void execute(char *argv[]) {
    char *path = malloc(5 + sizeof(char*));
    strcpy(path, "/bin/");
    strcat(path, argv[0]);

    pid_t pid = fork();

    if(pid == 0) {
        int ret = execv(path, argv);
        printf("Fails to execute %s\n", argv[0]);
        exit(1);
    }

    int status;
    waitpid(pid, &status, 0);

    free(path);
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

    if(characters == -1 || strcmp(buffer, "exit\n") == 0) {
        exit(0);
    }

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