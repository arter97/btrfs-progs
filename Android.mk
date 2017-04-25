LOCAL_PATH:= $(call my-dir)

#include $(call all-subdir-makefiles)

common_cflags := -g -O1 -Wall -D_FORTIFY_SOURCE=2 -include config.h \
	-DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC \
	-Wno-unused-variable -Wno-unused-parameter -Wno-sign-compare -Wno-pointer-arith

objects := \
	backref.c \
	ctree.c \
	dir-item.c \
	disk-io.c \
	extent-cache.c \
	extent_io.c \
	extent-tree.c \
	file.c \
	file-item.c \
	find-root.c \
	free-space-cache.c \
	free-space-tree.c \
	fsfeatures.c \
	help.c \
	inode.c \
	inode-item.c \
	inode-map.c \
	messages.c \
	print-tree.c \
	props.c \
	qgroup.c \
	qgroup-verify.c \
	raid56.c \
	repair.c \
	root-tree.c \
	send-dump.c \
	string-table.c \
	task-utils.c \
	utils.c \
	volumes.c \
	kernel-lib/crc32c.c \
	kernel-lib/list_sort.c \
	kernel-lib/radix-tree.c \
	kernel-lib/rbtree.c \
	kernel-shared/ulist.c \
	mkfs/common.c

cmds_objects := \
	cmds-balance.c \
	cmds-check.c \
	cmds-device.c \
	cmds-fi-du.c \
	cmds-filesystem.c \
	cmds-fi-usage.c \
	cmds-inspect.c \
	cmds-inspect-dump-super.c \
	cmds-inspect-dump-tree.c \
	cmds-inspect-tree-stats.c \
	cmds-property.c \
	cmds-qgroup.c \
	cmds-quota.c \
	cmds-receive.c \
	cmds-replace.c \
	cmds-rescue.c \
	cmds-restore.c \
	cmds-scrub.c \
	cmds-send.c \
	cmds-subvolume.c \
	chunk-recover.c \
	super-recover.c

btrfs_shared_libraries := libext2_uuid libext2_blkid
btrfs_static_libraries := libext2_uuid_static libext2_blkid

libbtrfs_objects := send-stream.c send-utils.c btrfs-list.c \
                   uuid-tree.c utils-lib.c rbtree-utils.c
libbtrfs_headers := send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
                   crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
                   extent_io.h ioctl.h ctree.h btrfsck.h version.h

TESTS := fsck-tests.sh convert-tests.sh
blkid_objects := partition/ superblocks/ topology/


# external/e2fsprogs/lib is needed for uuid/uuid.h
common_C_INCLUDES := $(LOCAL_PATH) $(LOCAL_PATH)/kernel-lib/ external/e2fsprogs/lib/ external/lzo/include/ external/zlib/

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(libbtrfs_objects)
LOCAL_CFLAGS := $(common_cflags)
LOCAL_MODULE := libbtrfs
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := btrfs
#LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_SRC_FILES := \
		$(objects) \
		$(cmds_objects) \
		btrfs.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_cflags)
LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
LOCAL_STATIC_LIBRARIES := libbtrfs liblzo-static libz

LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
#LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := mkfs.btrfs
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_SRC_FILES := \
                $(objects) \
                mkfs/main.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_cflags)
LOCAL_STATIC_LIBRARIES := libbtrfs liblzo-static $(btrfs_static_libraries)

LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
#LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#---------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := btrfstune
LOCAL_SRC_FILES := \
                $(objects) \
                btrfstune.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_cflags)
LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
LOCAL_STATIC_LIBRARIES := libbtrfs liblzo-static

LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)
#--------------------------------------------------------------
