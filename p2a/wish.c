#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

void execute(char *argv[]);

int main(int argc, char *argv[]) {
    while(1) {
        char *buffer;
        size_t bufsize = 32;
        size_t characters;
        buffer = (char *)malloc(bufsize * sizeof(char));

        printf("wish> ");
        characters = getline(&buffer, &bufsize, stdin);

        if(characters == -1 || strcmp(buffer, "exit\n") == 0) {
            exit(0);
        }

        if(characters != -1) {
            buffer[characters-1] = '\0';

            char *tokens[32];
            char *token;
            token = strtok(buffer, " ");
            for(int i = 0; token != NULL; i++) {
                tokens[i] = token;
                token = strtok(NULL, " ");
            }

            execute(tokens);
        }
    }
}

void execute(char *argv[]) {
    char *tmp = strdup(argv[0]);
    strcpy(argv[0], "/usr/bin/");
    strcat(argv[0], tmp);

    // char *input[2];
    // input[0] = malloc(512);
    // strcpy(input[0], path);
    // input[1] = NULL;

    pid_t pid = fork();

    if(pid == 0) {
        int ret = execv(argv[0], argv);
        printf("Fails to execute %s\n", argv[0]);
        exit(1);
    }

    free(tmp);
}