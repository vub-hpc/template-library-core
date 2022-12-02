# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Stijn De Weirdt <stijn.deweirdt@ugent.be>
#

# 

declaration template components/systemd/schema;

include 'quattor/types/component';
include 'components/accounts/functions';

# TODO: issue https://github.com/quattor/template-library-core/issues/97: some generic types, candidates for template-library-core
@documentation{
    hwloc (Portable Hardware Locality, hwloc(7)) location, e.g. node:1 for NUMAnode 1
}
type hwloc_location = string with match(SELF, '^[\w:.]+$');

@documentation{
    syslog facility to use when logging to syslog
}
type syslog_facility = string with match(SELF,
    '^(kern|user|mail|daemon|auth|syslog|lpr|news|uucp|cron|authpriv|ftp|local[0-7])$');

@documentation{
    syslog level to use when logging to syslog or the kernel log buffer
}
type syslog_level = string with match(SELF, '^(emerg|alert|crit|err|warning|notice|info|debug)$');

type systemd_skip = {
    "service" : boolean = false
} = dict();

type systemd_unit_architecture = string with match(SELF,
    '^(native|x86(-64)?|ppc(64)?(-le)?|ia64|parisc(64)?|s390x?|sparc(64)?)' +
    '|mips(-le)?|alpha|arm(64)?(-be)?|sh(64)?|m86k|tilegx|cris$');

type systemd_unit_security = string with match(SELF, '^!?(selinux|apparmor|ima|smack|audit)$');

type systemd_unit_virtualization = string with match(SELF,
    '^(0|1|vm|container|qemu|kvm|zvm|vmware|microsoft|oracle|xen' +
    '|bochs|uml|openvz|lxc(-libvirt)?|systemd-nspawn|docker)$');

# TODO: https://github.com/quattor/configuration-modules-core/issues/646:
#    make this more finegrained, e.g. has to be existing unit; or check types
type systemd_valid_unit = string;

# executable paths can have a number of special prefixes
type systemd_valid_execpath = string with match(SELF, '^([@+!:-]|!!)?/');

# type for a relative directory: no leading / and may not include ".."
type systemd_relative_directory = string with !match(SELF, '(^/|\.\.)');

# adding new ones
# go to http://www.freedesktop.org/software/systemd/man/systemd.directives.html
# and follow the link to the manual

@documentation{
    Condition/Assert entries in Unit section
    All lists can start with empty string to reset previously defined values.
}
type systemd_unitfile_config_unit_condition = {
    'ACPower' ? boolean
    'Architecture' ? systemd_unit_architecture[]
    'Capability' ? linux_capability[]
    'DirectoryNotEmpty' ? string[]
    'FileIsExecutable' ? string[]
    'FileNotEmpty' ? string[]
    'FirstBoot' ? boolean
    'Host' ? string[] # TODO: make custom type for hostname or machineid
    'KernelCommandLine' ? string[]
    'NeedsUpdate' ? string with match(SELF, '^!?/(var|etc)')
    'PathExistsGlob' ? string[]
    'PathExists' ? string[]
    'PathIsDirectory' ? string[]
    'PathIsMountPoint' ? string[]
    'PathIsReadWrite' ? string[]
    'PathIsSymbolicLink' ? string[]
    'Security' ? systemd_unit_security[]
    'Virtualization' ? systemd_unit_virtualization[]
};

@documentation{
the [Unit] section
http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options
}
type systemd_unitfile_config_unit = {
    'After' ? systemd_valid_unit[]
    'AllowIsolate' ? boolean
    'Assert' ? systemd_unitfile_config_unit_condition
    'Before' ? systemd_valid_unit[]
    'BindsTo' ? systemd_valid_unit[]
    'Condition' ? systemd_unitfile_config_unit_condition
    'Conflicts' ? systemd_valid_unit[]
    'DefaultDependencies' ? boolean
    'Description' ? string
    'Documentation' ? string
    'IgnoreOnIsolate' ? boolean
    'IgnoreOnSnapshot' ? boolean
    'JobTimeoutAction' ? string
    'JobTimeoutRebootArgument' ? string
    'JobTimeoutSec' ? long(0..)
    'JoinsNamespaceOf' ? systemd_valid_unit[]
    'NetClass' ? string
    'OnFailure' ? string[]
    'OnFailureJobMode' ? string with match(SELF,
        '^(fail|replace(-irreversibly)?|isolate|flush|ignore-(dependencies|requirements))$')
    'PartOf' ? systemd_valid_unit[]
    'PropagatesReloadTo' ? string[]
    'RefuseManualStart' ? boolean
    'RefuseManualStop' ? boolean
    'ReloadPropagatedFrom' ? string[]
    'Requires' ? systemd_valid_unit[]
    'RequiresMountsFor' ? string[]
    'RequiresOverridable' ? systemd_valid_unit[]
    'Requisite' ? systemd_valid_unit[]
    'RequisiteOverridable' ? systemd_valid_unit[]
    'SourcePath' ? string
    'StopWhenUnneeded' ? boolean
    'Wants' ? systemd_valid_unit[]
};

@documentation{
the [Install] section
http://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BInstall%5D%20Section%20Options
}
type systemd_unitfile_config_install = {
    'Alias' ? string[]
    'Also' ? systemd_valid_unit[]
    'DefaultInstance' ? string
    'RequiredBy' ? systemd_valid_unit[]
    'WantedBy' ? systemd_valid_unit[]
};

type systemd_unitfile_config_systemd_exec_stdouterr =  string with match(SELF,
    '^(inherit|null|tty|journal|syslog|kmsg|journal+console|syslog+console|kmsg+console|socket)$');

@documentation{
systemd.kill directives
http://www.freedesktop.org/software/systemd/man/systemd.kill.html
valid for [Service], [Socket], [Mount], or [Swap] sections
}
type systemd_unitfile_config_systemd_kill = {
    'KillMode' ? string with match(SELF, '^(control-group|process|mixed|none)$')
    'KillSignal' ? string with match(SELF,
        '^SIG(HUP|INT|QUIT|ILL|ABRT|FPE|KILL|SEGV|PIPE|ALRM|TERM|USR[12]|CHLD|CONT|STOP|T(STP|TIN|TOU))$')
    'SendSIGHUP' ? boolean
    'SendSIGKILL' ? boolean
};

@documentation{
systemd.exec directives
http://www.freedesktop.org/software/systemd/man/systemd.exec.html
valid for [Service], [Socket], [Mount], or [Swap] sections
}
type systemd_unitfile_config_systemd_exec = {
    'CacheDirectoryMode' ? type_octal_mode
    'CacheDirectory' ? systemd_relative_directory[]
    'ConfigurationDirectoryMode' ? type_octal_mode
    'ConfigurationDirectory' ? systemd_relative_directory[]
    'CPUAffinity' ? long[][] # start with empty list to reset
    'CPUSchedulingPolicy' ? string with match(SELF, '^(other|batch|idle|fifo|rr)$')
    'CPUSchedulingPriority' ? long(1..99) # 99 = highest
    'CPUSchedulingResetOnFork' ? boolean
    'Environment' ? string{}[] # start with empty list
    'EnvironmentFile' ? string[] # overrides variables defined in Environment
    'Group' ? defined_group
    'IOSchedulingClass' ? string with match(SELF, '^([0-3]|none|realtime|best-effort|idle)$')
    'IOSchedulingPriority' ? long(0..7) # 0 = highest
    'LimitAS' ? long(-1..) # The maximum size of the process's virtual memory (address space) in bytes.
    'LimitCORE' ? long(-1..) # Maximum size of a core file
    'LimitCPU' ? long(-1..) # CPU time limit in seconds
    'LimitDATA' ? long(-1..) # he maximum size of the process's data segment (initialized data, uninitialized data, and heap)
    'LimitFSIZE' ? long(-1..) # The maximum size of files that the process may create
    'LimitLOCKS' ? long(-1..) # (Early Linux 2.4 only) A limit on the number of locks
    'LimitMEMLOCK' ? long(-1..) # The maximum number of bytes of memory that may be locked into RAM
    'LimitMSGQUEUE' ? long(-1..) # pecifies the limit on the number of bytes that can be allocated for POSIX message queues for the real user ID of the calling process.
    'LimitNICE' ? long(0..40) # Specifies a ceiling to which the process's nice value can be raised. The actual ceiling for the nice value is calculated as 20 - rlim_cur.
    'LimitNOFILE' ? long(-1..) # Specifies a value one greater than the maximum file descriptor number that can be opened by this process.
    'LimitNPROC' ? long(-1..) # The maximum number of processes (or, more precisely on Linux, threads) that can be created for the real user ID of the calling process.
    'LimitRSS' ? long(-1..) # Specifies the limit (in pages) of the process's resident set (the number of virtual pages resident in RAM).
    'LimitRTPRIO' ? long(-1..) # Specifies a ceiling on the real-time priority that may be set for this process
    'LimitRTTIME' ? long(-1..) # Specifies a limit (in microseconds) on the amount of CPU time that a process scheduled under a real-time scheduling policy may consume without making a blocking system call.
    'LimitSIGPENDING' ? long(-1..) # Specifies the limit on the number of signals that may be queued for the real user ID of the calling process.
    'LimitSTACK' ? long(-1..) # The maximum size of the process stack, in bytes.
    'LogsDirectoryMode' ? type_octal_mode
    'LogsDirectory' ? systemd_relative_directory[]
    'Nice' ? long(-20..19)
    'OOMScoreAdjust' ? long(-1000..1000)
    'PrivateTmp' ? boolean
    'RootDirectory' ? systemd_relative_directory
    'RuntimeDirectoryMode' ? type_octal_mode
    'RuntimeDirectoryPreserve' ? choice('yes', 'no', 'restart')
    'RuntimeDirectory' ? systemd_relative_directory[]
    'StandardError' ? systemd_unitfile_config_systemd_exec_stdouterr
    'StandardInput' ? string with match(SELF, '^(null|tty(-(force|fail))?|socket)$')
    'StandardOutput' ? systemd_unitfile_config_systemd_exec_stdouterr
    'StateDirectoryMode' ? type_octal_mode
    'StateDirectory' ? systemd_relative_directory[]
    'SupplementaryGroups' ? defined_group[]
    'SyslogFacility' ? syslog_facility
    'SyslogIdentifier' ? string
    'SyslogLevel' ? syslog_level
    'SyslogLevelPrefix' ? boolean
    'TTYPath' ? string
    'TTYReset' ? boolean
    'TTYVHangup' ? boolean
    'TTYVTDisallocate' ? boolean
    'UMask' ? type_octal_mode
    'User' ? defined_user
    'WorkingDirectory' ? string
};

type systemd_unitfile_config_systemd_resource_control_devicelist = string[] with length(SELF) == 2 &&
        match(SELF[0], '^(char-|block-|/dev/)') && match(SELF[1], '^[rwm]{1,3}$');

type systemd_unitfile_config_systemd_resource_control_block_weight = string[] with length(SELF) == 2 &&
        match(SELF[0], '^/') && match(SELF[1], '^[0-9]+$');

@documentation{
systemd.resource-control directives
https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
valid for [Slice], [Scope], [Service], [Socket], [Mount], or [Swap] sections
}
type systemd_unitfile_config_systemd_resource_control = {
    'CPUAccounting' ? boolean
    'CPUShares' ? long(2..262144)
    'StartupCPUShares' ? long(2..262144)
    'CPUQuota' ? long(0..100)  # percentages
    'MemoryAccounting' ? boolean
    'MemoryLimit' ? long  # in bytes
    'TasksAccounting' ? boolean
    'TasksMax' ? string with match(SELF, '^([0-9]+%?|infinity)$')
    'BlockIOAccounting' ? boolean
    'BlockIOWeight' ? long(10..1000)
    'StartupBlockIOWeight' ? long(10..1000)
    'BlockIODeviceWeight' ? systemd_unitfile_config_systemd_resource_control_block_weight[]
    'BlockIOReadBandwidth' ? systemd_unitfile_config_systemd_resource_control_block_weight[]
    'BlockIOWriteBandwidth' ? systemd_unitfile_config_systemd_resource_control_block_weight[]
    'DeviceAllow' ? systemd_unitfile_config_systemd_resource_control_devicelist[]
    'DevicePolicy' ? choice('auto', 'closed', 'strict')
    'Slice' ? string
    'Delegate' ? boolean
};

@documentation{
the [Service] section
http://www.freedesktop.org/software/systemd/man/systemd.service.html
}
type systemd_unitfile_config_service = {
    include systemd_unitfile_config_systemd_exec
    include systemd_unitfile_config_systemd_kill
    include systemd_unitfile_config_systemd_resource_control
    'AmbientCapabilities' ? linux_capability[]
    'BusName' ? string
    'BusPolicy' ? string[] with length(SELF) == 2 && match(SELF[1], '^(see|talk|own)$')
    'CapabilityBoundingSet' ? linux_capability[]
    'ExecReload' ? string
    'ExecStart' ? string
    'ExecStartPost' ? transitional_string_or_list_of_strings
    'ExecStartPre' ? transitional_string_or_list_of_strings
    'ExecStop' ? string
    'ExecStopPost' ? transitional_string_or_list_of_strings
    'GuessMainPID' ? boolean
    'NonBlocking' ? boolean
    'NotifyAccess' ? string with match(SELF, '^(none|main|all)$')
    'PIDFile' ? string with match(SELF, '^/')
    'PermissionsStartOnly' ? boolean
    'RemainAfterExit' ? boolean
    'Restart' ? string with match(SELF, '^(no|on-(success|failure|abnormal|watchdog|abort)|always)$')
    'RestartForceExitStatus' ? long[]
    'RestartPreventExitStatus' ? long[]
    'RestartSec' ? long(0..) # TODO default is 100ms, which can't be expressed like this
    'RootDirectoryStartOnly' ? boolean
    'Sockets' ? systemd_valid_unit[]
    'SuccessExitStatus' ? long[]
    'TimeoutSec' ? long(0..)
    'TimeoutStartSec' ? long(0..)
    'TimeoutStopSec' ? long(0..)
    'Type' ? string with match(SELF, '^(simple|forking|oneshot|dbus|notify|idle)$')
    'WatchdogSec' ? long(0..)
} with {
    if(exists(SELF['Type']) && (SELF['Type'] == 'dbus') && (! exists(SELF['BusName']))) {
        error('BusName has to be specified with Type=dbus');
    };
    true;
};

@documentation{
the [Socket] section
http://www.freedesktop.org/software/systemd/man/systemd.socket.html
}
type systemd_unitfile_config_socket = {
    include systemd_unitfile_config_systemd_exec
    include systemd_unitfile_config_systemd_kill
    include systemd_unitfile_config_systemd_resource_control
    'ListenStream' ? string[]
    'ListenDatagram' ? string[]
    'ListenSequentialPacket' ? string[]
    'ListenFIFO' ? absolute_file_path
    'ListenSpecial' ? absolute_file_path
    'ListenNetlink' ? string
    'ListenMessageQueue' ? string with match(SELF, '^/')
    'ListenUSBFunction' ? string
    'SocketProtocol' ? choice('udplite', 'sctp')
    'BindIPv6Only' ? choice('default', 'both', 'ipv6-only')
    'Backlog' ? long(0..)
    'BindToDevice' ? string
    'SocketUser' ? defined_user
    'SocketGroup' ? defined_group
    'SocketMode' ? type_octal_mode
    'DirectoryMode' ? type_octal_mode
    'Accept' ? boolean
    'Writable' ? boolean
    'MaxConnections' ? long(0..)
    'MaxConnectionsPerSource' ? long(0..)
    'KeepAlive' ? boolean
    'KeepAliveTimeSec' ? long(0..)
    'KeepAliveIntervalSec' ? long(0..)
    'KeepAliveProbes' ? long(0..)
    'NoDelay' ? boolean
    'Priority' ? long(0..)
    'DeferAcceptSec' ? long(0..)
    'ReceiveBuffer' ? long(0..)
    'SendBuffer' ? long(0..)
    'IPTOS' ? string with match(SELF, '^([0-9]+|low-delay|throughput|reliability|low-cost)$')
    'IPTTL' ? long
    'Mark' ? long
    'ReusePort' ? boolean
    'SmackLabel' ? string
    'SmackLabelIPIn' ? string
    'SmackLabelIPOut' ? string
    'SELinuxContextFromNet' ? boolean
    'PipeSize' ? long(0..)
    'MessageQueueMaxMessages' ? long
    'MessageQueueMessageSize' ? long
    'FreeBind' ? boolean
    'Transparent' ? boolean
    'Broadcast' ? boolean
    'PassCredentials' ? boolean
    'PassSecurity' ? boolean
    'TCPCongestion' ? choice('westwood', 'veno', 'cubic', 'lp')
    'ExecStartPost' ? systemd_valid_execpath[]
    'ExecStartPre' ? systemd_valid_execpath[]
    'ExecStopPre' ? systemd_valid_execpath[]
    'ExecStopPost' ? systemd_valid_execpath[]
    'TimeoutSec' ? long(0..)
    'Service' ? string
    'RemoveOnStop' ? boolean
    'Symlinks' ? string[]
    'FileDescriptorName' ? string with match(SELF, '^[^:]{1,255}$')
    'TriggerLimitIntervalSec' ? long(0..)
    'TriggerLimitBurst' ? long(0..)
} with {
    if(exists(SELF['Service']) && exists(SELF['Accept']) && SELF['Accept']) {
        error('You can only specify a Service when Accept=false');
    };
    true;
};

@documentation{
the [mount] section
http://www.freedesktop.org/software/systemd/man/systemd.mount.html
}
type systemd_unitfile_config_mount = {
    include systemd_unitfile_config_systemd_exec
    include systemd_unitfile_config_systemd_kill
    'What': string
    'Where': absolute_file_path
    'Type' ? string
    'Options' ? string[]
    'SloppyOptions' ? boolean
    'LazyUnmount' ? boolean
    'ReadWriteOnly' ? boolean
    'ForceUnmount' ? boolean
    'DirectoryMode' ? type_octal_mode
    'TimeoutSec' ? long(0..)
};

@documentation{
the [Automount] section
http://www.freedesktop.org/software/systemd/man/systemd.automount.html
}
type systemd_unitfile_config_automount = {
    'Where': absolute_file_path
    'DirectoryMode' ? type_octal_mode
    'TimeoutSec' ? long(0..)
};

@documentation{
the [Timer] section
http://www.freedesktop.org/software/systemd/man/systemd.timer.html
}
type systemd_unitfile_config_timer = {
    'OnActiveSec' ? long(0..)
    'OnBootSec' ? long(0..)
    'OnStartupSec' ? long(0..)
    'OnUnitActiveSec' ? long(0..)
    'OnUnitInactiveSec' ? long(0..)
    'OnCalendar' ? string[]
    'AccuracySec' ? long(0..)
    'RandomizedDelaySec' ? long(0..)
    'FixedRandomDelay' ? boolean
    'OnClockChange' ? boolean
    'OnTimezoneChange' ? boolean
    'Unit' ? string
    'Persistent' ? boolean
    'WakeSystem' ? boolean
    'RemainAfterElapse' ? boolean
};

@documentation{
Unit configuration sections
    includes, unit and install are type agnostic
        unit and install are mandatory, but not enforced by schema (possible issues in case of replace=true)
    the other attributes are only valid for a specific type
}
type systemd_unitfile_config = {
    @{list of existing/other units to base the configuration on
      (e.g. when creating a new service with a different name, based on an exsiting one)}
    'includes' ? string[]
    'install' ? systemd_unitfile_config_install
    'service' ? systemd_unitfile_config_service
    'socket' ? systemd_unitfile_config_socket
    'mount' ? systemd_unitfile_config_mount
    'automount' ? systemd_unitfile_config_automount
    'timer' ? systemd_unitfile_config_timer
    'unit' ? systemd_unitfile_config_unit
};

@documentation{
Custom unit configuration to allow inserting computed configuration data
It overrides the data defined in the regular config schema,
so do not forget to set those as well (can be dummy value).
}
type systemd_unitfile_custom = {
    @{CPUAffinity list determined via
      'hwloc-calc --physical-output --intersect PU <location0> <location1>'
      Allows to cpubind on numanodes (as we cannot trust logical CPU indices, which regular CPUAffinity requires)
      Forces an empty list to reset any possible previously defined affinity.}
    'CPUAffinity' ? hwloc_location[]
};

@documentation{
    Unit file configuration
}
type systemd_unitfile = {
    @{unitfile configuration data}
    "config" : systemd_unitfile_config
    @{custom unitfile configuration data}
    "custom" ? systemd_unitfile_custom
    @{replaceunitfile configuration: if true, only the defined parameters will be used by the unit; anything else is ignored}
    "replace" : boolean = false
    @{only use the unit parameters for unitfile configuration,
      ignore other defined here such as targets (but still allow e.g. values defined by legacy chkconfig)}
    "only" ? boolean
};

# legacy conversion
#   1 -> rescue
#   234 -> multi-user
#   5 -> graphical
# for now limit the targets
type systemd_target = string with match(SELF, "^(default|poweroff|rescue|multi-user|graphical|reboot)$");

type systemd_unit_type = {
    "name" ? string # shortnames are ok; fullnames require matching type
    "targets" : systemd_target[] = list("multi-user")
    "type" : choice('service', 'target', 'sysv', 'socket', 'mount', 'automount', 'timer') = 'service'
    "startstop" : boolean = true
    "state" : string = 'enabled' with match(SELF, '^(enabled|disabled|masked)$')
    @{unitfile configuration}
    "file" ? systemd_unitfile
};

type systemd_component = {
    include structure_component
    "skip" : systemd_skip
    @{what to do with unconfigured units: ignore, enabled, disabled, on (enabled+start), off (disabled+stop; advanced option)}
    "unconfigured" : string = 'ignore' with match (SELF, '^(ignore|enabled|disabled|on|off)$') # harmless default
    # escaped full unitnames are allowed (or use shortnames and type)
    "unit" ? systemd_unit_type{}
} with {
    foreach(name; unit; SELF["unit"]) {
        if (unit["type"] == "mount" && exists(unit["file"]) && exists(unit["file"]["config"]["mount"])) {
            goodname = systemd_make_mountunit(unit["file"]["config"]["mount"]["Where"]);
            if(goodname != name) {
                error('Incorrect name for mount unit, the name must match Where: %s vs %s', name, goodname);
            };
        };
    };
    true;
};
