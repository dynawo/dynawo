# Makefile for simple simulation control task,
# c client, library for python and a shared memory reader and writer

all: master-rt-task shm-reader libpython-shm-io.so

shm-reader: shm-reader.c sim-control.h
	gcc -g -Wall -o shm-reader shm-reader.c

master-rt-task: master-rt-task.c sim-control.h
	gcc -g -Wall -o master-rt-task master-rt-task.c -lm -pthread -lrt

libpython-shm-io.so: python-shm-io.c
	gcc -Wall -shared -o libpython-shm-io.so -fPIC python-shm-io.c

python-shm-io.c: python-shm-io.awk
	./python-shm-io.awk sim-control.h > python-shm-io.c

clean:
	rm -f master-rt-task client-rt-task shm-reader *.o *.so python-shm-io.c
