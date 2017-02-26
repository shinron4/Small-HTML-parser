#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <fcntl.h>
#define MAX 1000

int main(int argc, char *argv[]){

	//Variable Declaration

    DIR *dp;
    struct dirent *ep;    
    int fd;
    char directory[200], *ptr;
    FILE *designation, *responsibility, *email, *phone, *website, *awards, *ms, *phd, *pub, *proj;

    //Creating Directory for storing the the .csv files.

    mkdir("Tables", 0700);

    //Creating the csv files and writing the column names.

    designation = fopen("Tables/designation.csv", "a");
    fprintf(designation, "%s;%s\n", "name", "designation");
    fflush(designation);
    responsibility = fopen("Tables/responsibility.csv", "a");
    fprintf(responsibility, "%s;%s\n", "name", "reponsibility");
    fflush(responsibility);
    email = fopen("Tables/email.csv", "a");
    fprintf(email, "%s;%s\n", "name", "email");
    fflush(email);
    phone = fopen("Tables/phone.csv", "a");
    fprintf(phone, "%s;%s\n", "name", "phone");
    fflush(phone);
    website = fopen("Tables/website.csv", "a");
    fprintf(website, "%s;%s\n", "name", "website");
    fflush(website);
    awards = fopen("Tables/awards.csv", "a");
    fprintf(awards, "%s;%s\n", "name", "awards");
    fflush(awards);
    ms = fopen("Tables/ms.csv", "a");
    fprintf(ms, "%s;%s;%s\n", "name", "student", "researcharea");
    fflush(ms);
    phd = fopen("Tables/phd.csv", "a");
    fprintf(phd, "%s;%s;%s\n", "name", "student", "researcharea");
    fflush(phd);
    pub = fopen("Tables/pub.csv", "a");
    fprintf(pub, "%s;%s;%s;%s\n", "name", "title", "author", "year");
    fflush(pub);
    proj = fopen("Tables/proj.csv", "a");
    fprintf(proj, "%s;%s;%s\n", "name", "title", "ajency");
    fflush(proj);

    //Opening the directory containing the .html files.

    dp = opendir (argv[1]);
    strcpy(directory, argv[1]);
    strcat(directory, "/");
    ptr = &directory[strlen(directory)];
    if (dp != NULL)
    {
    	//Reading each .html file.

        while (ep = readdir (dp))
            if(strstr(ep->d_name, "cs")){
                strcpy(ptr, ep->d_name);
                printf("parsing : %s\n", directory);
                fd = open(directory, O_RDONLY);

                //Calling the parser program to parse the .html file.

                if(fork() == 0){
                    dup2(fd, 0);
                    execlp("./parser", "./parser", (char *)0);
                }

                //Wait for parser to parse the file.

                wait(NULL);

                //Closing the file.

                close(fd);
            }

        //Closing the directory.

        closedir (dp);
    }
    else
        perror ("Couldn't open the directory");

    //Closing the .csv file.
    
    fclose(designation);
    fclose(responsibility);
    fclose(email);
    fclose(phone);
    fclose(website);
    fclose(awards);
    return 0;
}