#apply available canonical updates and clean up temp files
sudo apt-get update
sudo apt-get upgrade
sudo apt-get autoremove
sudo apt-get autoclean

#for an Internet-facing web server, automated updates are a strong consideration
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

#apply IP spoofing protection, block SYN attacks and control IP packet forwarding
sudo nano /etc/sysctl.conf
: net.ipv4.conf.default.rp_filter = 1
: net.ipv4.conf.all.rp_filter = 1
: net.ipv4.tcp_syncookies = 1
: net.ipv4.ip_forward = 0

#Disable weak HMAC algorithms within the TLS configuration of a Linux server running Apache httpd
sudo sed -i 's/^\(.*SSLHonorCipherOrder.*\)/#\1/' /etc/apache2/mods-available/ssl.conf
sudo sed -i 's/^\(.*SSLCipherSuite.*\)/#\1/' /etc/apache2/mods-available/ssl.conf

#Enable strong HMAC algorithms
SSLHonorCipherOrder on
SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:!DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA

#harden OpenSSH
sudo nano /etc/ssh/sshd_config
: Port <port>
: Protocol 2
: LogLevel VERBOSE
: PermitRootLogin no
: StrictModes yes
: RSAAuthentication yes
: IgnoreRhosts yes
: RhostsAuthentication no
: RhostsRSAAuthentication no
: PermitEmptyPasswords no
: PasswordAuthentication no
: ClientAliveInterval 300
: ClientAliveCountMax 0
: AllowTcpForwarding no
: X11Forwarding no
: UseDNS no
sudo service ssh restart

#Restart Apache to apply the changes
sudo systemctl restart apache2