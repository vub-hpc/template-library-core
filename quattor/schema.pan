################################################################################
# This is 'namespaces/standard/quattor/schema.tpl', a pan-templates's file
################################################################################
#
# VERSION:    3.2.9, 25/11/09 16:16
# AUTHOR:     Martin Bock
# MAINTAINER: Marco Emilio Poleggi <Marco.Emilio.Poleggi@cern.ch>, German Cancio <German.Cancio.Melia@cern.ch>, Michel Jouvin <jouvin@lal.in2p3.fr>
# LICENSE:    http://cern.ch/eu-datagrid/license.html
#
################################################################################
# Coding style: emulate <TAB> characters with 4 spaces, thanks!
################################################################################
#
# Type definition for the following structures:
#
#     * annotation
#     * ram
#     * harddisk
#     * cpu
#     * nic
#     * cards
#     * hardware
#     * interface_alias
#     * interface
#     * network
#     * route
#     * edg
#     * software
#     * system
#     * component
#     * profile
#
################################################################################

declaration template quattor/schema;

include { 'pan/types' };
include { 'quattor/functions/hardware' };
include { 'quattor/functions/validation' };

# To be defined
include { 'monitoring/lemon/schema' };



#######################################################################
# structure_annotation
#
# optional hardware specific information
#######################################################################
type structure_annotation = {
   "name"         ? string # "product name"
   "type"         ? string # "product type"
   "model"        ? string # "product model"
   "manufacturer" ? string # "manufacturer name"
   "vendor"       ? string # "vendor name"
   "version"      ? string # "product version"
   "chipset"      ? string # "product chipset"
   "serialnumber" ? string # "product serialnumber"
   "arch"         ? string # "product architecture" i386, amd64, m68k, ...
   "bus"          ? string # "bus of peripheral"
   "clock"        ? long   # "clock of peripheral"
   "lang"         ? string # "language of the product"
   "power"        ? long   # "power in watts"
   "location"     ? string # "location of the hardware"
   # ...
   # please do add your stuff here and enhance it by whatever you need!
};


# Partitions, disks, LVM, software RAID and filesystems
include { 'quattor/blockdevices' };
include { 'quattor/filesystems' };


############################################################
# structure_ram
############################################################
type structure_ram = {
    include structure_annotation
#     "name" : string
    "size" : long # "Size of module in MB"
    # usually given in N*MB or N*GB or (possibly) N*TB as defined in pan/units
    "data_rate" ? string
};


############################################################
# structure_cpu
############################################################
type structure_cpu = {
    include structure_annotation
    "speed"  : long # "CPU clock speed in MHz"
    # Number of cores on each CPU chip, defaults to 1.
    "cores" : long(1..) = 1
    # usually given in N * MHz or N * GHz as defined in pan/units
};


############################################################
# structure_nic
############################################################
type structure_nic = {
    include structure_annotation
    "hwaddr"       : type_hwaddr
    "driver"       ? string
    "driverrpms"   ? string[]
    "media"        ? string
    "name"         ? string
    "pxe"          ? boolean
    "boot"         ? boolean
    "maxspeed"     ? long
    "role"         ? string = ''
};

############################################################
# Rack definition
############################################################
type structure_rack = {
  "name" : string
};

############################################################
# Fiber channel data types
############################################################
type fcahwaddr = string with is_a_fcahwaddr (SELF);
type structure_fca = { 
    include structure_annotation 
    "hwaddr" ? fcahwaddr # "IEEE fiber Channel World Wide Name" 
    "active" ? boolean # "Is this port being used" 
};
############################################################
# BMC controller
############################################################
type structure_bmc = { 
    include structure_annotation 
    "hwaddr" ? type_hwaddr 
};

############################################################
# structure_cards
############################################################
# New structure_cards, merging CERN's development for other hardware,
# not just NIC.
type structure_cards = {
    # Indexed by device name (eth0, venet0...)
    "nic" : structure_nic{}
    # Fiber channel
    "fca" ? structure_fca[]
    # For hardware RAID controllers
    "raid" ? structure_raid{}
    # For describing IDE controllers
    "ide" ? structure_raid{}
    # For describing SATA controllers
    "sata" ? structure_raid{}
    # For describing Parallel SCSI controllers
    "scsi" ? structure_raid{}
    # For describing SAS controllers
    "sas" ? structure_raid{}
    # For describing BMC controllers
    "bmc" ? structure_bmc[]
} with is_valid_card_ports (SELF);

############################################################
# structure_serial_console
############################################################
type structure_serial_console = {
    include structure_annotation
    "parity" ? string with match(SELF, "^(n|p)$")
    "speed"  ? long
    "unit"   ? long
    "word"   ? long(7..8)
};

############################################################
# structure_telnet_console
############################################################
type structure_telnet_console = {
    "port" : long = 23
    "fqdn" : string
};
############################################################
# structure_ipmi_console
############################################################
type structure_ipmi_console = {
    "fqdn"      ? string
    "hwaddr"    : type_hwaddr
};
############################################################
# structure_ssh_console
############################################################
type structure_ssh_console = {
    "fqdn"      ? string
    "hwaddr"    : type_hwaddr
};
############################################################
# structure_bmc_console
############################################################
type structure_bmc_console = {
    "fqdn"      ? string
    "hwaddr"    : type_hwaddr
};
############################################################
# structure_dpc_console
############################################################
type structure_dpc_console = {
    "fqdn"      ? string
    "hwaddr"    : type_hwaddr
};
############################################################
# structure_console
############################################################
type structure_console = extensible {
    "serial" ? structure_serial_console
    "telnet" ? structure_telnet_console
    "ssh"    ? structure_ssh_console
    "ipmi"   ? structure_ipmi_console
    "dpc"    ? structure_dpc_console
    "bmc"    ? structure_dpc_console
    "preferred" : string[]
};

############################################################
# structure_hardware
############################################################
type structure_hardware = {
    include structure_annotation
    "cpu"          ? structure_cpu[]
    "ram"          ? structure_ram[]
    "cards"        ? structure_cards
    "rack"	   ? structure_rack
    # Obsolete field, use the appropriate "cards" sub-field instead!!
    "harddisks"    ? structure_raidport{}
    "console"      ? structure_console
};

# network schema defined within component area
include {"components/network/core-schema"};


############################################################
# structure_edg*
#
# type definition for EDG (legacy support for DataGrid)
############################################################
type structure_edg_config = {
    "EDG_LOCATION"              ? string
    "EDG_LOCATION_VAR"          ? string
    "EDG_TMP"                   ? string
    "CERTDIR"                   ? string
    "X509_USER_CERT"            ? string
    "X509_USER_KEY"             ? string
    "GRIDMAP"                   ? string
    "GRIDMAPDIR"                ? string
    "EDG_WL_BKSERVERD_ADDOPTS"  ? string
    "EDG_WL_RGMA_FILE"          ? string
    "EDG_WL_RGMA_SOCK"          ? string
};

type structure_edg = {
    "config" ? structure_edg_config
};


############################################################
# structure_glite*
#
# type definition for gLite
############################################################
type structure_glite_config = {
    "GLITE_LOCATION"      : string = '/opt/glite'
    "GLITE_LOCATION_VAR"  : string = '/var/glite'
    "GLITE_LOCATION_LOG"  : string = '/var/log/glite'
    "GLITE_TMP"           : string = '/tmp'
    "GLITE_USER"          ? string
    "GLITE_GROUP"         ? string
    "GLITE_X509_PROXY"    ? string
};

type structure_glite = {
    "config" ? structure_glite_config
};


############################################################
# structure_lcg*
#
# type definition for LCG
############################################################
type structure_lcg_config = {
    "LCG_LOCATION"      ? string
    "LCG_LOCATION_VAR"  ? string
    "LCG_TMP"           ? string
};

type structure_lcg = {
    "config" ? structure_lcg_config
};


############################################################
# structure_vo_*
############################################################
type structure_vo_auth = {
    "uri"   : type_hostURI
    "user"  : string
};

type structure_vo_voms = {
    "fqan"  : string
    "user"  ? string
    "group" ? string
};

type structure_vo_services_wms = {
    "lbhosts"   : type_hostport[]
    "nshosts"   ? type_hostport[]
    "wmproxies" : type_hostURI[]
};

type structure_vo_services = {
    "myproxy" ? type_hostname
    "hlr"     ? type_hostname
    "nshosts" ? type_hostport[]
    "lbhosts" ? type_hostport[]
    "wms"     ? structure_vo_services_wms
};

type structure_vo = {
    "name"      : string
    "auth"      ? structure_vo_auth[]
    "services"  ? structure_vo_services
    "voms"      ? structure_vo_voms[]
};

# AII definitions

type structure_aii_module = extensible {
    "dummy" ? string
};

type structure_aii_hook = extensible {
    "module" : string
};

type structure_aii_hooklist = {
    "pre_install" ? structure_aii_hook[]
    "post_install" ? structure_aii_hook[]
    "post_reboot" ? structure_aii_hook[]
    "anaconda" ? structure_aii_hook[]
    # Intended to be used by nbp plug-in
    "rescue" ? structure_aii_hook[]
    "install" ? structure_aii_hook[]
    "remove" ? structure_aii_hook[]
    "boot" ? structure_aii_hook[]
};

type structure_aii = extensible {
    "osinstall" ? structure_aii_module{}
    "nbp" ? structure_aii_module{}
    "dhcp" ? structure_aii_module
    "hooks" ? structure_aii_hooklist
};

############################################################
# system-related structures
############################################################

type structure_import = {
    "source"     : string # with isURI(SELF)
    "mountpoint" ? string with match(SELF, '^(/[a-zA-Z\_\d/]*|none|swap)$')
    "options"    ? string
};

type structure_export = {
    "localpath" : string
    "options"   ? string
};

type structure_cluster = {
    "name" : string
    "type" ? string
};

type structure_kernel = {
    "version"   ? string # "kernel version to use (eg. 2.4.18-27.7.x.cernsmp)"
};

type structure_oldname = {
    "name" : string
    "date" : string
};


############################################################
# structure_enclosure
#
# describe a "box" as a collection of several nodes. We distinguish
# 3 types of enclosures:
#   blade       -> physical boxes with intelligence, such as, NIC, disk, etc
#   dump        -> physical boxes with no intelligence (just power unit)
#   hypervisor  -> virtual machines
# Each enclosure describes a parent-child relation, where "children" lists
# profile names which must exist. Warning! If you have a node called 'foo',
# use 'foo' as a profile name, *not* 'profile_foo' which raises a validation
# error; however, to allow a smooth transition, each name will be transparently
# matched against 'foo' and 'profile_foo', which are considered to be the same.
# The optional "maxchildren", if set, is used for validating the children
# list's size when defined: it must satisfy
#   "maxchildren" >= length("children")
# this allow to describe an empty enclosure by defining *only*
#   "/system/enclosure/type" = "...";
#   "/system/enclosure/maxchildren" = 0;
############################################################
final variable ENC_TYPES = 'blade|dumb|hypervisor';
type structure_enclosure = {
    "type"          : string with match(SELF, ENC_TYPES)
                        || error("enclosure type must be one of: "+ENC_TYPES)
    "children"      ? string[1..] with is_profile_list(SELF)
    "maxchildren"   ? long
} with {
    if (exists(SELF['children']) && exists(SELF['maxchildren'])) {
        SELF['maxchildren'] >= length(SELF['children'])
        || error("enclosure has too many children, max is " +
            to_string(SELF['maxchildren']));
    } else {
        true;
    };
};


type structure_system = {
    "aii"           ? structure_aii
    "architecture"  ? string    # with match (SELF,'i386|ia64|x86_64|sparc')
                                # "system architecture"
    "cluster"       ? structure_cluster
    "edg"           ? structure_edg
    "enclosure"     ? structure_enclosure
    "filesystems"   ? structure_filesystem[]
    "blockdevices" ? structure_blockdevices
    "glite"         ? structure_glite
    "kernel"        : structure_kernel         # required by ncm-grub
    "lcg"           ? structure_lcg
    "network"       : structure_network
    # monitoring-related structures should go elsewhere. TBD.
    "monitoring"    ? structure_monitoring
    "oldnames"      ? structure_oldname[]
    "rootmail"      : type_email
    "siterelease"   ? string
    "state"         ? string with match (SELF,
        'production|standby|test|development|onloan') # "production|out-of-production|test|development|onloan"
    "vo"            ? structure_vo{}
};


############################################################
# structure_component*
############################################################

type structure_component_dependency = {
    "pre"       ? string[] with is_component_list(SELF)
    "post"      ? string[] with is_component_list(SELF)
};

type structure_component_code = {
    "script"    : string
    "data"      ? string{}
};

type structure_component = extensible {
    "active"            : boolean = true # "component active?"
    "dispatch"          : boolean = true # "run with cdispd?"
    "version"           ? string with match(SELF, '^\d+.\d+.\d+$')
    "register_change"   ? element*[]
    "dependencies"      ? structure_component_dependency
    "code"              ? structure_component_code
};


############################################################
# structure_software
#
# generic definition of the software tree. This is made more specific if the
# SPMA definitions are included
############################################################
type structure_software = {
    "components"    ? structure_component{}
    "repositories"  ? list
    "packages"      ? nlist
    "groups"        ? nlist
};


############################################################
# structure_profile
############################################################
type structure_profile = {
    "hardware" : structure_hardware
    "software" ? structure_software
    "system"   : structure_system
};
