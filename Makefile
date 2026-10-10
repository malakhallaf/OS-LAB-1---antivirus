DIR = dir
MAL = malicious_dir
SECS = 6

setup:
	mkdir -p $(DIR) $(MAL)
	chmod +x antivirusd.sh restore.sh antivirus-cron.sh

daemon: setup
	./antivirusd.sh $(DIR) $(MAL) $(SECS)

cron-job: setup
	./antivirus-cron.sh $(DIR) $(MAL)

restore:
	./restore.sh $(DIR) $(MAL)

cleanup:
	rm -rf $(DIR) $(MAL) directory-info.last directory-info.new whitelist.txt 