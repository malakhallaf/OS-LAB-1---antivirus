DIR = dir
MAL = malicious_dir
SECS = 6

setup:
	mkdir -p $(MAL)
	chmod +x antivirusd.sh restore.sh

daemon: setup
	./antivirusd.sh $(DIR) $(MAL) $(SECS)

restore:
	./restore.sh $(DIR) $(MAL)