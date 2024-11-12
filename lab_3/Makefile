#
CC=gcc
LEX=flex

% : %.tab.o %.o 
	$(CC) $< $*.o $(LDFLAGS) -o $@

%.tab.c %.tab.h: %.y
	bison -d $<

%.c: %.l %.tab.h
	$(LEX) -t $< > $@

ada: ada.y ada.l

clean:
	rm -f *.o *.tab.c *.tab.h *.output ada output.txt