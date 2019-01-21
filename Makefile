SUBDIRS := $(filter-out bin/.,$(wildcard */.))

all:
	for x in $(SUBDIRS); do\
		make -C $$x;\
	done

clean:
	for x in $(SUBDIRS); do\
		make -iC $$x clean;\
	done
