#include <stdio.h>
#include <string.h>
#include <stdlib.h>

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
            char *tokens[10];
            tokens[0] = strtok(buffer, " \t\n");
            execute(tokens);
        }
    }
}

void execute(char *args[]) {
    char *path = NULL;
    path = malloc(6 + strlen(args[0]));
    strcat(path, "/bin/");
    strcat(path, args[0]);

    char *input[2];
    input[0] = malloc(512);
    strcpy(input[0], path);
    input[1] = NULL;

    pid_t pid = fork*();
    if(pid < 0) {
        printf("ERROR: fork failed.");
        exit(0);
    } else if(pid == 0) {
        execv(input[0], input);
    }

    free(path);
    free(input[0]);
}