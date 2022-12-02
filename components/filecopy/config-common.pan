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
# filecopy, 21.12.1-SNAPSHOT, SNAPSHOT20221202140314, Fri Dec 02 2022
#

unique template components/filecopy/config-common;

include 'components/filecopy/schema';

# Set prefix to root of component configuration.
prefix '/software/components/filecopy';

#'version' = '21.12.1-SNAPSHOT';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
