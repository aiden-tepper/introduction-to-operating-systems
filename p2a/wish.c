#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <fcntl.h>

char **paths;
int execute_program();

void throw_err() {
    char error_message[30] = "An error has occurred\n";
    write(STDERR_FILENO, error_message, strlen(error_message));
}

void my_exit(char *args[]) {
    if(args[1] != NULL) {
        throw_err();
        return;
    }
    exit(0);
}

void my_cd(char *args[]) {
    if(args[1] == NULL || args[2] != NULL) {
        throw_err();
        return;
    }
    chdir(args[1]);
}

void my_path(char **args) {
    free(paths);
    paths = malloc(32 * sizeof(char*));
    for(int i = 1; args[i] != NULL; i++) {
        paths[i-1] = strdup(args[i]);
    }
    if(args[1] == NULL) {
        paths[0] = NULL;
    }
}

void my_if(char *args[]) {
    int command = execute_program(args[1], NULL);
    char* operator = args[2];
    int constant = atoi(args[3]);
    if(strcmp(operator, "==") == 0) {
        if(command == constant)
            printf(args[5]);
    } else if(strcmp(operator, "!=") == 0) {
        if(command != constant)
            printf(args[5]);
    }
}

void (*builtins[]) (char **) = {
  &my_exit,
  &my_cd,
  &my_path,
  &my_if
};

char *const builtins_list[4] = {
    "exit",
    "cd",
    "path",
    "if"
};

int execute_program(char *args[], char *redir_file) {
    if(paths[0] == NULL) {
        throw_err();
        return -1;
    }

    char *path = malloc(sizeof(char*));

    for(int i = 0; paths[i] != NULL; i++) {
        free(path);
        path = malloc(sizeof(paths[i]) + sizeof(char*));
        strcpy(path, paths[i]);
        strcat(path, "/");
        strcat(path, args[0]);
        if(access(path, X_OK) == 0)
            break;
    }

    pid_t pid = fork();
    int ret;

    if(pid == 0) {
        if(redir_file != NULL) {
            int fd = open(redir_file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
            dup2(fd, fileno(stdout));
            close(fd);
        }
        ret = execv(path, args);
        throw_err();
    }

    int status;
    waitpid(pid, &status, 0);

    free(path);
    return ret;
}

char *is_redir(char *args[]) {
    char *redir_file = NULL;
    for(int i = 0; args[i] != NULL; i++) {
        if(strcmp(args[i], ">") == 0) {
            if(args[i+1] == NULL || args[i+2] != NULL) {
                throw_err();
                redir_file = "abort";
                break;
            }
            args[i] = NULL;
            redir_file = args[i+1];
            args[i+1] = NULL;
            break;
        }
    }
    return redir_file;
}

void execute(char *args[]) {
    if(args[0] == NULL)
        return;

    char *redir_file = is_redir(args);
    if(redir_file != NULL && strcmp(redir_file, "abort") == 0)
        return;

    int builtin = 0;
    for(int i = 0; i < 4; i++) {
        if(strcmp(args[0], builtins_list[i]) == 0) {
            (*builtins[i])(args);
            builtin = 1;
        }
    }
    
    if(!builtin)
        execute_program(args, redir_file);
}

int has_redir(char *token) {
    int index = -1;
    for(int i = 1; i < strlen(token); i++) {
        if(token[i] == '>')
            return i;
    }
    return index;
}

char **parse_input(char *input) {
    char **tokens = malloc(256 * sizeof(char*));
    char *token;
    int index = 0;

    token = strtok(input, " \t\n");
    while(token != NULL) {
        if(index == 0 && strcmp(token, ">") == 0) {
            tokens[0] = "NULL";
            return tokens;
        }
        int i = has_redir(token);
        if(i != -1) {
            token = strtok(token, ">");
            tokens[index++] = token;
            tokens[index++] = ">";
            token = strtok(NULL, " \t\r\n\v");
            continue;
        }
        tokens[index++] = token;
        token = strtok(NULL, " \t\r\n\v");
    }

    tokens[index] = '\0';
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

void interactive() {
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

void batch(char *argv[]) {
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    char **args;

    fp = fopen(argv[1], "r");

    if(fp == NULL) {
        throw_err();
        exit(1);
    }

    while((read = getline(&line, &len, fp))) {
        args = parse_input(line);
        if(args[0] == NULL)
            break;
        execute(args);
        free(args);
    }

    fclose(fp);
    free(line);

    exit(0);
}

int main(int argc, char *argv[]) {
    paths = malloc(32 * sizeof(char*));
    paths[0] = "/bin";

    if(argc == 1) {
        interactive();
    } else if(argc == 2) {
        batch(argv);
    } else {
        throw_err();
        exit(1);
    }
}