# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Ronald Starink <ronalds@nikhef.nl>
#

# 
# #
# gmetad, 21.12.1-SNAPSHOT, SNAPSHOT20221202140314, Fri Dec 02 2022
#

unique template components/gmetad/config-common;

include 'components/gmetad/schema';

# Set prefix to root of component configuration.
prefix '/software/components/gmetad';

#'version' = '21.12.1-SNAPSHOT';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
