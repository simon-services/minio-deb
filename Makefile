.PHONY: all
all: build 

minio:
	git clone https://github.com/minio/minio
	cd minio && git checkout 'RELEASE.2020-05-08T02-40-49Z'
	cd minio && $(MAKE) build

build: clean minio
	mkdir tmp
	mv minio/minio opt/github.com/minio/minio/bin/minio
	rm -fv opt/github.com/minio/minio/bin/.empty
	chmod +x opt/github.com/minio/minio/bin/minio
	rm -rf minio
	rsync -ax --exclude tmp ./ tmp/
	rm -rfv tmp/Makefile tmp/.git* tmp/LICENSE tmp/README.md
	dpkg-deb --build tmp minio-0.0.1-amd64.deb
	rm -rf tmp

.PHONY: clean 
clean:
	rm -fv *~ .*.swp *.deb
	rm -rf minio
