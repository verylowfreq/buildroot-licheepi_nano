#!/bin/sh


# Target system root is TARGET_DIR

#
# Copy missing library file (libatomis.so.1)
#
if [ ! -e "${TARGET_DIR}/usr/lib/libatomic.so" ];then
	FILE_LIBATOMIC=`find "${TARGET_DIR}/../build" -path "*host-gcc-final*" -and -path "*arm-buildroot-linux-gnueabi*" -and -name "libatomic.so.1"`
	cp "${FILE_LIBATOMIC}" "${TARGET_DIR}/usr/lib"
	(cd "${TARGET_DIR}/usr/lib"; ln -s libatomic.so.1 libatomic.so)
fi


#
# Disable unused daemon scripts
#

chmod -x output/target/etc/init.d/*sshd || true
chmod -x output/target/etc/init.d/*dropbear || true
chmod -x output/target/etc/init.d/*dhcpcd || true


#
# Enable tty on LCD
#

if [ -z "`grep agetty "${TARGET_DIR}/etc/inittab"`" ]; then
	cat - <<EOT >> "${TARGET_DIR}/etc/inittab"

/dev/tty0::respawn:/sbin/agetty --noclear -a root -s tty0 vt100

EOT
fi

