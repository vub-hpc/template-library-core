# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Charles Loomis <charles.loomis@cern.ch>
#

# 
# #
# hostsaccess, 15.4.0-rc12, rc12_1, 2015-06-03T08:50:01Z
#

unique template components/hostsaccess/config-common;

include { 'components/hostsaccess/schema' };

# Set prefix to root of component configuration.
prefix '/software/components/hostsaccess';

#'version' = '15.4.0-rc12';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
