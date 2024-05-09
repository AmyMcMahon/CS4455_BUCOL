%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <string.h>
    #include <stdlib.h>
    #include <math.h>

    void yyerror(const char* s);
    void moveInt(int val, char* id);
    void moveVar(char* id1, char* id2);
    void create_var(char* name, int value);
	void printVal(char* id);
	void addVarVar(char* id1, char* id2);
	int isExisting(char* id);
	bool checkSize(char* id, int num);
	void addition(char* id, int val);

    int yylex();
	extern FILE *yyin;
	extern int yylineno;

    
	typedef struct{
		char name[100];
		int integer;	
		int capacity;
	} Vars;

	Vars vars[250];
	int num_id = 0;


%}

%union { int value; char* id; int size;}


%start program
%token <size> CAPACITY
%token <id> IDENTIFIER
%token STRING
%token <value> INTEGER
%token BEGINNING BODY END PRINT MOVE INPUT ADD TO
%token SEMICOLON LINE_END UNKNOWN

%%
program:			beginning body end {};
beginning:          BEGINNING LINE_END declerations {};
declerations:       decleration declerations
                    | decleration body{} ;
decleration:        CAPACITY IDENTIFIER LINE_END {create_var($2, $1);};
body:               BODY LINE_END statements{};
statements:         statement statements
                    | statement end{};
statement:          print | move | input | add {};  
print:              PRINT print_val;
print_val:          STRING SEMICOLON print_val {}
                    | IDENTIFIER SEMICOLON print_val {printVal($1);}
                    | STRING LINE_END  {}
                    | IDENTIFIER LINE_END  {isExisting($1);};
move:               MOVE IDENTIFIER TO IDENTIFIER LINE_END {moveVar($2, $4); }
                    | MOVE INTEGER TO IDENTIFIER LINE_END {moveInt($2, $4); }
add:                ADD INTEGER TO IDENTIFIER LINE_END {addition($4, $2);}
                    | ADD IDENTIFIER TO IDENTIFIER LINE_END {addVarVar($2, $4);}
input:              INPUT input_val {};
input_val:          IDENTIFIER SEMICOLON input_val {isExisting($1);}
                    | IDENTIFIER LINE_END {isExisting($1);};
end:                END LINE_END {printf("Your program is well formatted :)\n"); exit(1);};

%%
int main()
    {
    do yyparse();
        while(!feof(yyin));
	
	
    }
 
void yyerror(const char *message)
{
	fprintf(stderr, "An error occured on line %d: You havent formatted the program correctly\n", yylineno);
	exit(1);
	
}

void printVal(char* id){
	int index = isExisting(id);
	if(index != -1){
		return;
	} else {
		printf("Warning on line %d:  you have not yet defined the var %s.\n", yylineno, id);
		exit (1);
	}
}

void create_var(char* named, int cap){	
    int existing = isExisting(named);
	if (named[0] && named[1] == 'x' || named[0] && named[1] == 'X'){
		printf("Error on line %d:  you cannot start a var with a sequence of Xs.\n", yylineno);
		return;
	}
    if (existing == -1) {
        strcpy(vars[num_id].name, named);
        vars[num_id].integer = 0;
        vars[num_id].capacity = cap;
		printf("Added %s with value %d and capacity %d\n", vars[num_id].name, vars[num_id].integer, vars[num_id].capacity);
		num_id++;
    }
}

int isExisting (char* id){
	if (num_id == 0){
		return -1;
	}
	bool found = false;
	for (int i = 0; i < num_id; i++)
		if (strcmp(vars[i].name, id) == 0){
			found = true;
			return i;
		}
	return -1;
} 

void addition (char* id, int val){
	int cap = 0;
	int existing = isExisting(id);
	if(existing != -1){
		int value = vars[existing].integer + val;
		if(checkSize(id, value)){
			vars[existing].integer = value;
			printf("Added %d to %s\n", val, id);
		} else {
			printf("Error on line %d:  %s does not have a valid size for %d.\n", yylineno, id, val);
		
		}
	} else {
		printf("Warning on line %d:  you have not yet defined the var %s.\n", yylineno, id);
		exit(1);
	}

}

void addVarVar (char* id1, char* id2){
	int index1 = isExisting(id1);
	int index2 = isExisting(id2);
	if(index1 != -1 && index2 != -1){
		int value = vars[index1].integer + vars[index2].integer;
		if(checkSize(id1, value)){
			vars[index1].integer = value;
			printf("Added %s to %s\n", id1, id2);
		}
	} else {
		printf("Warning on line %d:  you have not yet defined the var .\n", yylineno);
		exit(1);
	}
}

bool checkSize (char* id, int num){
	int index = isExisting(id);
	bool valid = false;
	int nDigits = floor(log10(abs(num))) + 1;
	if(index != -1){
		if(nDigits <= vars[index].capacity){
			valid = true;
		}
	} else {
		printf("Warning on line %d:  you have not yet defined the var %s.\n", yylineno, id);
		exit(1);
	}
	return valid;
}

void moveInt(int val, char* id){
	bool valid = checkSize(id, val);
	if(valid){
		int index = isExisting(id);
		if(index != -1){
			vars[index].integer = val;
			printf("Moved %d to %s\n", val, id);
		} else {
			printf("Warning on line %d:  you have not yet defined the var %s.\n", yylineno, id);
			exit(1);
		}
	}    
}

void moveVar(char* id1, char* id2){
    int index1 = isExisting(id1);
	int index2 = isExisting(id2);

	if(index1 != -1 && index2 != -1){
		if(vars[index1].capacity <= vars[index2].capacity){
			vars[index2].integer = vars[index1].integer;
			printf("Moved %s to %s\n", id1, id2);
		}
		else{
			printf("Error on line %d: %s does not have a valid size for %s.\n", yylineno, id1, id2);
			exit(1);
		}
	} else {
		printf("Warning on line %d:  you have not yet defined the var.\n", yylineno);
		exit(1);
	}
}