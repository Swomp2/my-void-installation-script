This scripts helps you to install DE and useful progs on your Void linux.

git clone https://www.gitlab.com/c8292/my-void-installation-script
cd my-void-installation-script
chmod +x chroot.sh desktop-void-install.sh

First you need to create a /mnt/boot mount point with chroot.sh script and mount all your partitions to /mnt and etc.
Then you need to run chroot.sh again.
After changing to chroot you need to run "cd my-void-installation-script" and "./desktop-void-install.sh".
That's all :3
