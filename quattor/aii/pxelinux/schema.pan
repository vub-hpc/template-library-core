# #
# Software subject to following license(s):
#   The Apache Software License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.txt)
#   null
#

# #
# Current developer(s):
#   Luis Fernando Muñoz Mejías <Luis.Munoz@UGent.be>
#

# #
# Author(s): Michel Jouvin, Gabor Gombas, Ben Jones
#

# #
# pxelinux, 21.12.1-SNAPSHOT, SNAPSHOT20221202140742, Fri Dec 02 2022
#

declaration template quattor/aii/pxelinux/schema;

include 'pan/types';

@documentation{
    PXE configuration
}
type structure_pxelinux_pxe_info = {
    @{Kernel path (string in exact syntax).
      If this contains a '@pattern@' substring, the kernel path is generated based on
        the (first) enabled SPMA repository with name matching this glob pattern (without the '@').}
    "kernel" : string
    @{Initrd path (string in exact syntax).
      If this contains a '@pattern@' substring, the initrd path is generated based on
        the (first) enabled SPMA repository with name matching this glob pattern (without the '@').}
    "initrd" : string
    @{try to resolve the hostname (when relevant) for EFI kernel and/or initrd; to use the ip instead of the hostname}
    "efi_name_lookup" ? boolean
    "ksdevice"  : string with match(SELF, '^(bootif|link)$') || is_hwaddr(SELF) ||
        exists("/system/network/interfaces/" + escape(SELF))
    "kslocation" : type_absoluteURI
    "label"  : string
    "append" ? string
    "rescue" ? string
    "livecd" ? string
    "firmware" ? string
    "setifnames" ? boolean
    "updates" ? type_absoluteURI
    @{Get (static) IP details used for ksdevice configuration form this device.
      For most network configs like bridges and bonds, this is not required.}
    "ipdev" ? string with exists(format("/system/network/interfaces/%s", SELF))
};
